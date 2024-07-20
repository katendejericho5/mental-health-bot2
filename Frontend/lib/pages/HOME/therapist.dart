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
                    // Circular Container with White Glow Effect around SVG
                    Container(
                      width: 250, // Adjust the size as needed
                      height: 250, // Adjust the size as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.7),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 0), // Shadow position
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 150, // SVG size
                          height: 150, // SVG size
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: SvgPicture.asset(
                            'assets/undraw_mindfulness_8gqa.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Icons below the Circular Container
                    Positioned(
                      bottom: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 140),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.comments,
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
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/homepage');
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
