import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 37, 150, 190),
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(179, 37, 149, 190),
            height: 80,
            child: Center(
              child: Container(
                height: 50,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(84, 152, 216, 240),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
