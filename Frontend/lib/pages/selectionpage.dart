import 'package:flutter/material.dart';
import 'package:mentalhealth/pages/questions.dart';

class QuizTwopage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuizTwo(
        question: 'Choose any of the two options for quick recommendation',
        options: [
          'Immediate Recommendations',
          'Ai Assistant',
        ],
      ),
    );
  }
}
