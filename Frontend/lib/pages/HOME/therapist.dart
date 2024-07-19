import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(151, 1, 129, 248),
              Color.fromARGB(255, 198, 223, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            // Title
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Mental Health',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.blueGrey[800],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular Container
                    Container(
                      width: 250, // Adjust the size as needed
                      height: 250, // Adjust the size as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0, // Border width
                        ),
                      ),
                    ),
                    // SVG Image
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          width: 150, // Adjust the size as needed
                          height: 150, // Adjust the size as needed
                          child: SvgPicture.asset(
                            'assets/undraw_mindfulness_8gqa.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Icons on top of the SVG image
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.houseMedicalFlag,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 100),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.userDoctor,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Therapist Mode Button with padding and increased width
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          // Define your onPressed function here
                        },
                        child: const Text('Therapist Mode'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
