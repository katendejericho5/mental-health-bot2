import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          // First full-screen SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/undraw_chat_re_re1u.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          // Second SVG as a design element or additional background
          Positioned(
            top: 20,
            left: 20,
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/undraw_mindfulness_8gqa.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'About WellCareBot',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Mission',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'At WellCareBot, our mission is to provide accessible and effective mental health support through technology. We aim to assist individuals in managing their mental health by offering a companion that listens and responds empathetically.',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Vision',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'We envision a world where everyone has access to mental health support, regardless of their location or financial situation. Through WellCareBot, we strive to break down barriers and promote mental well-being for all.',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Our Team',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Our team is composed of dedicated professionals with a passion for mental health and technology. We work tirelessly to improve WellCareBot and ensure it meets the needs of our users.',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Us',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'If you have any questions, feedback, or need support, please feel free to reach out to us at wellcarebot@gmail.com. We are here to help and support you in your mental health journey.',
                  style: GoogleFonts.poppins(fontSize: 18),
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
        ],
      ),
    );
  }
}
