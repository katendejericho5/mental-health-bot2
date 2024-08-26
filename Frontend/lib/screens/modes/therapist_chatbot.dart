import 'package:WellCareBot/models/history_model.dart';
import 'package:WellCareBot/screens/settings/history.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/ad_helper.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TherapistChatBot extends StatefulWidget {
  final String threadId;

  const TherapistChatBot({super.key, required this.threadId});

  @override
  State<TherapistChatBot> createState() => _TherapistChatBotState();
}

class _TherapistChatBotState extends State<TherapistChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();
  final List<types.Message> _messages = [];
  late String _userId = '';
  final String _botId = 'bot123';

  @override
  void initState() {
    super.initState();
    AdHelper.loadRewardedAd();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _fetchUserData();
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

  void _loadMessages() {
    _firestoreService.getMessages(widget.threadId).listen((messages) {
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

  void _sendMessage(types.PartialText message) async {
    final userInput = message.text;
    if (userInput.isNotEmpty) {
      final chatMessage = ChatMessageHistory(
        id: DateTime.now().toString(),
        threadId: widget.threadId,
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
        final response = await _apiService.getChatbotResponseTherapist(
          userInput,
        );
        final botMessage = ChatMessageHistory(
          id: DateTime.now().toString(),
          threadId: widget.threadId,
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
          title: Text('Rate Limit Exceeded'),
          content:
              Text('You have reached the rate limit. Would you like to renew?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Watch Ad'),
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
          SnackBar(content: Text('Rate limit renewed successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to renew rate limit: $e')),
        );
      }
    });

    if (!adShown) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to show ad. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.brightness == Brightness.light
        ? Colors.white // Light theme background
        : Colors.grey[900]!; // Dark theme background

    return Scaffold(
      appBar: AppBar(
        title: Text('Therapist'),
        actions: [
          IconButton(
            icon: Icon(Icons.history_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHistoryPage(
                    therapistThreadId: 'therapist_thread_id',
                    companion_thread_id: 'companion_thread_id',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: (message) {
          _sendMessage(message);
        },
        user: types.User(id: _userId),
        showUserAvatars: true,
        showUserNames: true,
        scrollPhysics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        theme: DefaultChatTheme(
          backgroundColor: backgroundColor,
          inputTextCursorColor: theme.colorScheme.primary,
          inputSurfaceTintColor: theme.colorScheme.surfaceTint,
          inputBackgroundColor: theme.colorScheme.surface,
          inputTextColor: theme.colorScheme.onSurface,
          sendButtonIcon: Icon(Icons.send, color: theme.colorScheme.primary),
          inputMargin:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          inputTextStyle: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
          inputBorderRadius: const BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
          inputContainerDecoration: BoxDecoration(
            color: theme.colorScheme.surface,
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
