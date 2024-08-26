import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Dual-Mode AI Interaction",
      body:
          "Seamlessly switch between companion and therapist modes. Our AI adapts to your emotional state and needs.",
      image: _buildRoundedImage(
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.teal[800]),
        bodyTextStyle:
            GoogleFonts.poppins(fontSize: 18.0, color: Colors.blueGrey[700]),
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
      image: _buildRoundedImage(
          'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
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
      image: _buildRoundedImage(
          'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.green[800]),
        bodyTextStyle:
            GoogleFonts.poppins(fontSize: 18.0, color: Colors.blueGrey[700]),
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
      image: _buildRoundedImage(
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
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
      image: _buildRoundedImage(
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: Colors.orange[800]),
        bodyTextStyle:
            GoogleFonts.poppins(fontSize: 18.0, color: Colors.blueGrey[700]),
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
  static Widget _buildRoundedImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imagePath,
          width: 350,
          height: 350,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
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
