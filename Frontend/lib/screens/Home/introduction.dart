import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Dual-Mode AI Interaction",
      body:
          "Seamlessly switch between companion and therapist modes. Our AI adapts to your emotional state and needs.",
      image: _buildLottieAnimation('assets/conversation2.json'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.teal[800]),
        bodyTextStyle:
            GoogleFonts.roboto(fontSize: 18.0, color: Colors.blueGrey[700]),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[50]!, Colors.teal[100]!],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Cutting-Edge Conversations",
      body:
          "Experience mind-blowing chats powered by the latest AI tech. It's like texting the future!",
      image: _buildLottieAnimation('assets/conversation.json'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.indigo[800]),
        bodyTextStyle:
            GoogleFonts.roboto(fontSize: 18.0, color: Colors.blueGrey[700]),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[50]!, Colors.indigo[100]!],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Evidence-Based Approach",
      body:
          "Access clinically-informed strategies based on up-to-date mental health research.",
      image: _buildLottieAnimation('assets/knowledge_based.json'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.green[800]),
        bodyTextStyle:
            GoogleFonts.roboto(fontSize: 18.0, color: Colors.blueGrey[700]),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.green[100]!],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Comprehensive Ecosystem",
      body:
          "Track your mood, and book physical therapist appointments all in one place.",
      image: _buildLottieAnimation('assets/doctor.json'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.purple[800]),
        bodyTextStyle:
            GoogleFonts.roboto(fontSize: 18.0, color: Colors.blueGrey[700]),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[50]!, Colors.purple[100]!],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Accessible & Affordable",
      body:
          "Get 24/7 on-demand support with flexible pricing options, including a free tier.",
      image: _buildLottieAnimation('assets/acessible.json'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.orange[800]),
        bodyTextStyle:
            GoogleFonts.roboto(fontSize: 18.0, color: Colors.blueGrey[700]),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.orange[100]!],
          ),
        ),
      ),
    ),
  ];

  static Widget _buildLottieAnimation(String path) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Lottie.asset(
        path,
        width: 350,
        height: 350,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      showSkipButton: true,
      skip: Text("Skip",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600, color: Colors.grey[600])),
      next: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
      done: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "Get Started",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(8, 8),
        color: Colors.grey[300]!,
        activeSize: Size(16, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        activeColor: Colors.teal,
        spacing: EdgeInsets.symmetric(horizontal: 3),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding: EdgeInsets.fromLTRB(8, 4, 8, 8),
      dotsContainerDecorator: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      isProgressTap: true,
      isProgress: true,
      freeze: false,
      animationDuration: 400,
    );
  }
}
