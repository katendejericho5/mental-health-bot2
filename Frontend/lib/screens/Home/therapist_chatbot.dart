import 'package:WellCareBot/services/ad_helper.dart';
import 'package:WellCareBot/services/api_service.dart';
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
  final List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();
    AdHelper.loadRewardedAd();
  }

  void _sendMessage(types.PartialText message) async {
    final userInput = message.text;
    if (userInput.isNotEmpty) {
      setState(() {
        _messages.add(types.TextMessage(
          author: types.User(id: 'user'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: DateTime.now().toString(),
          text: userInput,
        ));
      });

      try {
        final response = await _apiService.getChatbotResponseTherapist(
            userInput, widget.threadId);
        setState(() {
          _messages.add(types.TextMessage(
            author: types.User(id: 'bot'),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: DateTime.now().toString(),
            text: response,
          ));
        });
      } catch (e) {
        if (e.toString().contains('Rate limit exceeded')) {
          _showRateLimitDialog();
        } else {
          setState(() {
            _messages.add(types.TextMessage(
              author: types.User(id: 'bot'),
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
                _showAd(); // Show the rewarded ad
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Therapist'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: (message) {
          _sendMessage(message);
        },
        user: types.User(id: 'user'),
        showUserAvatars: true,
        showUserNames: true,
        scrollPhysics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        theme: DefaultChatTheme(
          // INPUT TEXTFIELD THEME
          inputTextCursorColor: Colors.blue,
          inputSurfaceTintColor: Colors.yellow,
          inputBackgroundColor: Colors.white,
          inputTextColor: Colors.black,
          sendButtonIcon: const Icon(Icons.send, color: Colors.lightBlue),
          inputMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          inputTextStyle: const TextStyle(
            color: Colors.black,
          ),
          inputBorderRadius: const BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
          inputContainerDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(30),
              right: Radius.circular(30),
            ),
          ),
          // OTHER CHANGES IN THEME
          primaryColor: Colors.blue,
        ),
      ),
    );
  }
}
