import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 37, 150, 190),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Color.fromARGB(179, 37, 149, 190),
                  height: 80,
                  child: Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          'Companion Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color.fromARGB(146, 0, 0, 0),
                          ),
                        ),
                      ),
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(84, 152, 216, 240),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Image(
                        image: AssetImage('lib/images/ponytail.png'),
                        height: 100,
                      ),
                      Container(
                        height: 110,
                        width: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(33),
                          color: Color.fromARGB(193, 10, 83, 110),
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Hi! This is Becky your Companion, how can\ni help you',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                ..._messages.map((message) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 110,
                          width: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            color: Color.fromARGB(255, 155, 214, 236),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Color.fromARGB(193, 10, 83, 110),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Image(
                          image: AssetImage('lib/images/manager.png'),
                          height: 90,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(179, 37, 149, 190),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
