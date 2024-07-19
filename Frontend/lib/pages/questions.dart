import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mentalhealth/pages/selectionpage.dart';

class QuizoneQuestion extends StatefulWidget {
  final String question;
  final String buttonText;

  QuizoneQuestion({required this.question, required this.buttonText});

  @override
  _QuizoneQuestionState createState() => _QuizoneQuestionState();
}

class _QuizoneQuestionState extends State<QuizoneQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "lib/images/quizone.svg",
                    width: 100,
                    height: 175,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        widget.question,
                        textAlign: TextAlign.left,
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                width: double.infinity,
                height: 100,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: ' Enter your text Here',
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizTwopage()),
                  );
                },
                color: Color.fromARGB(255, 72, 11, 214),
                textColor: Colors.white,
                child: Text(
                  widget.buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizTwo extends StatefulWidget {
  final String question;
  final List<String> options;

  QuizTwo({
    required this.question,
    required this.options,
  });

  @override
  _QuizTwoState createState() => _QuizTwoState();
}

class _QuizTwoState extends State<QuizTwo> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "lib/images/quizone.svg",
                    width: 100,
                    height: 175,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        widget.question,
                        textAlign: TextAlign.left,
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ...widget.options.map((option) {
                int index = widget.options.indexOf(option);
                return Column(
                  children: [
                    _buildOption(index, option),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: MaterialButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                onPressed: () {},
                color: Color.fromARGB(255, 72, 11, 214),
                textColor: Colors.white,
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(int value, String text) {
    bool isSelected = selectedOption == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = value;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.orange : Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 0,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: selectedOption,
              activeColor: Colors.orange,
              onChanged: (int? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
