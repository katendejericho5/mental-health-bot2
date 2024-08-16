import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About WellCareBot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'At WellCareBot, our mission is to provide accessible and effective mental health support through technology. We aim to assist individuals in managing their mental health by offering a companion that listens and responds empathetically.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We envision a world where everyone has access to mental health support, regardless of their location or financial situation. Through WellCareBot, we strive to break down barriers and promote mental well-being for all.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              'Our Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Our team is composed of dedicated professionals with a passion for mental health and technology. We work tirelessly to improve WellCareBot and ensure it meets the needs of our users.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[600],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions, feedback, or need support, please feel free to reach out to us at wellcarebot@gmail.com. We are here to help and support you in your mental health journey.',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/relaxation-7282116_1280.jpg',
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
