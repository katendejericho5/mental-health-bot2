import 'package:flutter/material.dart';
import 'package:mentalhealth/pages/questions.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 205, 223, 238),
      ),
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      body: QuizoneQuestion(
        question: 'How do you feel today. Please describe how you feel',
        buttonText: 'SUBMIT',
      ),
    );
  }
}
