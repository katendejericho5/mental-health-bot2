import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/Authentication/login.dart';
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
      image: Image.asset('assets/images/onboarding/dual.png'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyTextStyle: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(17),
            fontWeight: FontWeight.w400),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(17, 6, 60, 1),
              Color.fromRGBO(37, 14, 132, 1)
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Cutting-Edge Conversations",
      body:
          "Experience mind-blowing chats powered by the latest AI tech. It's like texting the future!",
      image: Image.asset('assets/images/onboarding/interaction.png'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyTextStyle: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(17),
            fontWeight: FontWeight.w400),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(17, 6, 60, 1),
              Color.fromRGBO(37, 14, 132, 1)
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Evidence-Based Approach",
      body:
          "Access clinically-informed strategies based on up-to-date mental health research.",
      image: Image.asset('assets/images/onboarding/evidence.png'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyTextStyle: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(17),
            fontWeight: FontWeight.w400),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(17, 6, 60, 1),
              Color.fromRGBO(37, 14, 132, 1)
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Comprehensive Ecosystem",
      body:
          "Track your mood, and book physical therapist appointments all in one place.",
      image: Image.asset('assets/images/onboarding/mood.png'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyTextStyle: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(17),
            fontWeight: FontWeight.w400),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(17, 6, 60, 1),
              Color.fromRGBO(37, 14, 132, 1)
            ],
          ),
        ),
      ),
    ),
    PageViewModel(
      title: "Accessible & Affordable",
      body:
          "Get 24/7 on-demand support with flexible pricing options, including a free tier.",
      image: Image.asset('assets/images/onboarding/affordable.png'),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.nunito(
            fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white),
        bodyTextStyle: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(17),
            fontWeight: FontWeight.w400),
        imagePadding: EdgeInsets.only(top: 40),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromRGBO(17, 6, 60, 1),
              Color.fromRGBO(37, 14, 132, 1)
            ],
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
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      onSkip: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      showSkipButton: true,
      skip: Text(
        "Skip",
        style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w400),
      ),
      next: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(2, 106, 111, 1),
                Color.fromRGBO(3, 226, 246, 1)
              ]),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Next',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      done: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 199, 222, 241),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 124, 188, 240),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Start",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
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
        activeColor: Colors.blue,
        spacing: EdgeInsets.symmetric(horizontal: 3),
      ),
      curve: Curves.linear,
      controlsPadding: EdgeInsets.fromLTRB(8, 4, 8, 8),
      dotsContainerDecorator: BoxDecoration(
        color: Color.fromRGBO(17, 6, 60, 1),
        borderRadius: BorderRadius.zero,
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
