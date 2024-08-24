import 'package:WellCareBot/models/history_model.dart';
import 'package:WellCareBot/screens/settings/history.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/ad_helper.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanionChatBot extends StatefulWidget {
  final String threadId;

  const CompanionChatBot({Key? key, required this.threadId}) : super(key: key);

  @override
  State<CompanionChatBot> createState() => _CompanionChatBotState();
}

class _CompanionChatBotState extends State<CompanionChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  final FirestoreService _firestoreService = FirestoreService();
  List<ChatMessageHistory> _messages = [];
  String _userId = '';
  final String _botId = 'bot123';
  bool _isTyping = false;
  Map<String, bool> _typingUsers = {};

  // Custom color scheme
  late final ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    AdHelper.loadRewardedAd();
    _initializeData();
    _listenToTypingStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorScheme = _getColorScheme(Theme.of(context).brightness);
  }

  ColorScheme _getColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: Colors.tealAccent, // Green accent color
      onPrimary: Colors.black,
      secondary: Colors.tealAccent,
      onSecondary: Colors.white,
      background:
          brightness == Brightness.light ? Colors.white : Color(0xFF1C1E21),
      onBackground:
          brightness == Brightness.light ? Colors.black : Colors.white,
      surface:
          brightness == Brightness.light ? Colors.white : Color(0xFF242526),
      onSurface: brightness == Brightness.light ? Colors.black : Colors.white,
      error: Colors.red,
      onError: Colors.white,
    );
  }

  void _listenToTypingStatus() {
    FirebaseFirestore.instance
        .collection('threads')
        .doc(widget.threadId)
        .collection('typing')
        .snapshots()
        .listen((snapshot) {
      Map<String, bool> typingUsers = {};
      for (var doc in snapshot.docs) {
        typingUsers[doc.id] = doc.data()['isTyping'] ?? false;
      }
      setState(() {
        _typingUsers = typingUsers;
      });
    });
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
        _messages = messages;
      });
      _scrollToBottom();
    });
  }

  void _sendMessage() async {
    final userInput = _controller.text;
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
        _messages.add(chatMessage);
        _isTyping = true;
      });
      _scrollToBottom();

      await _firestoreService.addMessage(chatMessage);
      await _updateTypingStatus(false);
      _controller.clear();

      try {
        final response = await _apiService.getChatbotResponseCompanion(
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
          _messages.add(botMessage);
          _isTyping = false;
        });
        _scrollToBottom();

        await _firestoreService.addMessage(botMessage);
      } catch (e) {
        if (e.toString().contains('Rate limit exceeded')) {
          _showRateLimitDialog();
        } else {
          setState(() {
            _messages.add(ChatMessageHistory(
              id: DateTime.now().toString(),
              threadId: widget.threadId,
              userId: _botId,
              author: _botId,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              text: "Oops!😟 Something went wrong. Please try again later.",
            ));
            _isTyping = false;
          });
          _scrollToBottom();
        }
      }
    }
  }

  Future<void> _updateTypingStatus(bool isTyping) async {
    await FirebaseFirestore.instance
        .collection('threads')
        .doc(widget.threadId)
        .collection('typing')
        .doc(_userId)
        .set({'isTyping': isTyping}, SetOptions(merge: true));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showRateLimitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate Limit Exceeded',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
              content: Text('Failed to renew rate limit: $e',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.greenAccent,
                Colors.tealAccent,
              ],
            ),
          ),
        ),
        title: Row(
          children: [
            // Container(
            //   padding: EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //   ),
            //   child: Icon(
            //     Icons.psychology,
            //     color: Colors.greenAccent,
            //     size: 24,
            //   ),
            // ),
            SizedBox(width: 12),
            Text(
              'Companion',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: _colorScheme.onPrimary,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black26,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history_outlined, color: _colorScheme.onPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHistoryPage(
                    therapistThreadId: 'therapist_thread_id',
                    companionshipThreadId: 'companionship_thread_id',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: _colorScheme.onPrimary),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        color: _colorScheme.background,
        child: Column(
          children: [
            if (_typingUsers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _typingUsers.keys
                          .where((id) => _typingUsers[id]!)
                          .join(', ') +
                      ' is typing...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _colorScheme.primary,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message.author == _userId;

                  return Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? _colorScheme.primary
                            : _colorScheme.brightness == Brightness.light
                                ? Color(0xFFE4E6EB)
                                : Color(0xFF3A3B3C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.text,
                        style: GoogleFonts.poppins(
                          color: isUserMessage
                              ? _colorScheme.onPrimary
                              : _colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Typing...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _colorScheme.primary,
                  ),
                ),
              ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              color: _colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.poppins(
                            color: _colorScheme.onSurface.withOpacity(0.6)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: _colorScheme.brightness == Brightness.light
                            ? Color(0xFFE4E6EB)
                            : Color(0xFF3A3B3C),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      style: GoogleFonts.poppins(
                        color: _colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorScheme.primary,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: _colorScheme.onPrimary),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
