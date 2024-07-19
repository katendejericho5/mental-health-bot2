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
      body: ListView(
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
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image(
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
                )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              height: 50,
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(179, 37, 149, 190),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 110,
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: Color.fromARGB(193, 10, 83, 110),
                  ),
                ),
                Image(
                  image: AssetImage('lib/images/ponytail.png'),
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
