import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/history_model.dart';
import 'package:WellCareBot/screens/settings/history.dart';
import 'package:WellCareBot/services/ad_helper.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanionChatBot extends StatefulWidget {
  final String threadId;

  const CompanionChatBot({super.key, required this.threadId});

  @override
  State<CompanionChatBot> createState() => _CompanionChatBotState();
}

class _CompanionChatBotState extends State<CompanionChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();
  final List<types.Message> _messages = [];
  late String _userId = '';
  final String _botId = 'bot123';
  final spinkit = SpinKitThreeBounce(
    color: Colors.blueAccent,
  );
  String? _therapistThreadId;
  String? _companionThreadId;

  @override
  void initState() {
    super.initState();
    AdHelper.loadRewardedAd();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _fetchUserData();
      await _getOrSetThreadIdTherapist();
      await _getOrSetThreadIdCompanion();
      _loadMessages();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;
        _userId = userData['uid'] ?? user.uid;
      } else {
        _userId = user.uid;
      }
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> _getOrSetThreadIdTherapist() async {
    _therapistThreadId = await _apiService.getThreadId('therapist');
  }

  Future<void> _getOrSetThreadIdCompanion() async {
    _companionThreadId = await _apiService.getThreadId('companion');
  }

  void _loadMessages() {
    if (_companionThreadId != null) {
      _firestoreService.getMessages(_companionThreadId!).listen((messages) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages.map((message) => types.TextMessage(
                author: types.User(id: message.author),
                createdAt: message.createdAt,
                id: message.id,
                text: message.text,
              )));
        });
      });
    }
  }

  Future<void> _sendMessage(types.PartialText message) async {
    final userInput = message.text;
    if (userInput.isNotEmpty && _companionThreadId != null) {
      final chatMessage = ChatMessageHistory(
        id: DateTime.now().toString(),
        threadId: _companionThreadId!,
        userId: _userId,
        author: _userId,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: userInput,
      );

      setState(() {
        _messages.add(types.TextMessage(
          author: types.User(id: _userId),
          createdAt: chatMessage.createdAt,
          id: chatMessage.id,
          text: userInput,
        ));
      });

      await _firestoreService.addMessage(chatMessage);

      try {
        final response = await _apiService.getChatbotResponseCompanion(
          userInput,
        );
        final botMessage = ChatMessageHistory(
          id: DateTime.now().toString(),
          threadId: _companionThreadId!,
          userId: _botId,
          author: _botId,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          text: response,
        );

        setState(() {
          _messages.add(types.TextMessage(
            author: types.User(id: _botId),
            createdAt: botMessage.createdAt,
            id: botMessage.id,
            text: response,
          ));
        });

        await _firestoreService.addMessage(botMessage);
      } catch (e) {
        if (e.toString().contains('Rate limit exceeded')) {
          _showRateLimitDialog();
        } else {
          setState(() {
            _messages.add(types.TextMessage(
              author: types.User(id: _botId),
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: DateTime.now().toString(),
              text: "Oops!😟 Something went wrong. Please try again later.",
            ));
          });
        }
      }

      _controller.clear();
    }
  }

  void _showRateLimitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate Limit Exceeded', style: GoogleFonts.poppins()),
          content: Text(
              'You have reached the rate limit. Would you like to renew?',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Watch Ad', style: GoogleFonts.poppins()),
              onPressed: () async {
                Navigator.of(context).pop();
                _showAd();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAd() async {
    bool adShown = await AdHelper.showRewardedAd(() async {
      try {
        await _apiService.renewRateLimit();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Rate limit renewed successfully',
                  style: GoogleFonts.poppins())),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to renew rate limit',
                  style: GoogleFonts.poppins())),
        );
      }
    });

    if (!adShown) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to show ad. Please try again later.',
                style: GoogleFonts.poppins())),
      );
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        child: child,
        color: _userId != message.author.id ||
                message.type == types.MessageType.image
            ? Color.fromRGBO(108, 104, 250, 1)
            : Colors.white,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _userId != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
      );

  Future<void> _showMessageLoader() async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: spinkit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          'Companion',
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.w700),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.gear,
                color: Colors.white, size: getProportionateScreenHeight(20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHistoryPage(
                    therapistThreadId: _therapistThreadId!,
                    companion_thread_id: _companionThreadId!,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(getProportionateScreenHeight(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(
                color: Colors.white,
              ),
            )),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: (message) async {
          _showMessageLoader();
          await _sendMessage(message);
          Navigator.pop(context);
        },
        emptyState: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: getProportionateScreenHeight(85)),
              Image.asset(
                'assets/images/bots/nomessages.png',
                height: getProportionateScreenHeight(300),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No messages yet',
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
        user: types.User(id: _userId),
        bubbleBuilder: _bubbleBuilder,
        showUserAvatars: false,
        showUserNames: false,
        scrollPhysics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        theme: DefaultChatTheme(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          messageBorderRadius: 15,
          dateDividerTextStyle: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(15),
              fontWeight: FontWeight.w600),
          // INPUT TEXTFIELD THEME
          inputTextCursorColor: theme.colorScheme.primary,
          inputSurfaceTintColor: theme.colorScheme.surfaceTint,
          inputBackgroundColor: theme.colorScheme.surface,
          inputTextColor: theme.colorScheme.onSurface,
          sendButtonIcon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromRGBO(2, 106, 111, 1),
                    Color.fromRGBO(3, 226, 246, 1)
                  ]),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Icon(FontAwesomeIcons.solidPaperPlane,
                    color: Colors.white, size: getProportionateScreenWidth(15)),
              ),
            ),
          ),
          inputMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          inputTextStyle: GoogleFonts.nunito(
              fontSize: getProportionateScreenWidth(15),
              fontWeight: FontWeight.normal),
          sentMessageBodyTextStyle: GoogleFonts.poppins(
            textStyle: GoogleFonts.nunito(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.normal),
          ),
          receivedMessageBodyTextStyle: GoogleFonts.poppins(
              textStyle: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.white,
                  fontWeight: FontWeight.normal)),
          inputBorderRadius: const BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
          inputContainerDecoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            border: Border.all(color: theme.colorScheme.outline, width: 1.0),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(30),
              right: Radius.circular(30),
            ),
          ),
          primaryColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
