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
      backgroundColor: const Color.fromARGB(255, 205, 223, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 150, 190),
      ),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(179, 37, 149, 190),
            height: 80,
            child: Center(
              child: Container(
                height: 50,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(84, 152, 216, 240),
                ),
                child: const Center(
                    child: Text(
                  'Companion Mode',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color.fromARGB(146, 0, 0, 0)),
                )),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
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
                    color: const Color.fromARGB(193, 10, 83, 110),
                  ),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Hi! This is Becky your Companion, how can\ni help you',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              height: 50,
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(179, 37, 149, 190),
              ),
            ),
          ),
          const SizedBox(
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
                    color: const Color.fromARGB(255, 155, 214, 236),
                  ),
                  child: const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Okay! This is Jessy and i have a few questions\nfor you',
                      style: TextStyle(
                        color: Color.fromARGB(193, 10, 83, 110),
                      ),
                    ),
                  )),
                ),
                const Image(
                  image: AssetImage('lib/images/manager.png'),
                  height: 90,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
