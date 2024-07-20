// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:mentalhealth/pages/OTHERS/homepage.dart';
// import 'package:mentalhealth/pages/AUTHENTICATION/OTHERS/Profile.dart';
// import 'package:mentalhealth/pages/AUTHENTICATION/OTHERS/chatbot.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int index = 0;

//   final screens = [const Homepage(), const ChatBot(), const Profile()];

//   @override
//   Widget build(BuildContext context) {
//     final items = <Widget>[
//       const Icon(Icons.home, color: Color.fromARGB(255, 205, 223, 238)),
//       const Icon(Icons.chat, color: Color.fromARGB(255, 205, 223, 238)),
//       const Icon(Icons.person, color: Color.fromARGB(255, 205, 223, 238)),
//     ];
//     return Scaffold(
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: const Color.fromARGB(255, 205, 223, 238),
//         color: const Color.fromARGB(255, 37, 150, 190),
//         index: index,
//         items: items,
//         onTap: (index) => setState(() => this.index = index),
//       ),
//       backgroundColor: const Color.fromARGB(255, 205, 223, 238),
//       body: screens[index],
//     );
//   }
// }
