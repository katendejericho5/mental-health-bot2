import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mentalhealth/services/api_service.dart';

class CompanionChatBot extends StatefulWidget {
  final String threadId;

  const CompanionChatBot({super.key, required this.threadId});

  @override
  State<CompanionChatBot> createState() => _CompanionChatBotState();
}

class _CompanionChatBotState extends State<CompanionChatBot> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final List<types.Message> _messages = [];

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
        final response =
            await _apiService.getChatbotResponse(userInput, widget.threadId);
        setState(() {
          _messages.add(types.TextMessage(
            author: types.User(id: 'bot'),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: DateTime.now().toString(),
            text: response,
          ));
        });
      } catch (e) {
        setState(() {
          _messages.add(types.TextMessage(
            author: types.User(id: 'bot'),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: DateTime.now().toString(),
            text: "Error: ${e.toString()}",
          ));
        });
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companion'),
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
        scrollToUnreadOptions: const ScrollToUnreadOptions(
          scrollOnOpen: true,
        ),
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