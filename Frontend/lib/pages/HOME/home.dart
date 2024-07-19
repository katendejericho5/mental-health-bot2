import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mentalhealth/pages/HOME/homepage.dart';
import 'package:mentalhealth/pages/OTHERS/Profile.dart';
import 'package:mentalhealth/pages/chatbot.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  final screens = [Homepage(), ChatBot(), Profile()];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, color: Color.fromARGB(255, 205, 223, 238)),
      Icon(Icons.chat, color: Color.fromARGB(255, 205, 223, 238)),
      Icon(Icons.person, color: Color.fromARGB(255, 205, 223, 238)),
    ];
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(255, 205, 223, 238),
        color: Color.fromARGB(255, 37, 150, 190),
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
      ),
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      body: screens[index],
    );
  }
}
