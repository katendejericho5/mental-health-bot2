import 'package:WellCareBot/screens/Authentication/registration.dart';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Welcome to Wellcare Bot",
      body: "Your personal virtual therapist for mental well-being.",
      image: _buildRoundedImage('assets/ai-generated-8562019_1280.jpg'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 18.0),
        imagePadding: EdgeInsets.only(top: 40),
      ),
    ),
    PageViewModel(
      title: "24/7 Support",
      body: "Get help anytime, anywhere. We're always here for you.",
      image: _buildRoundedImage('assets/relaxation-7282116_1280.jpg'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 18.0),
        imagePadding: EdgeInsets.only(top: 40),
      ),
    ),
    PageViewModel(
      title: "Personalized Care",
      body: "Tailored therapy sessions based on your unique needs.",
      image: _buildRoundedImage('assets/finger-7921766_1920.jpg'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 18.0),
        imagePadding: EdgeInsets.only(top: 40),
      ),
    ),
    PageViewModel(
      title: "Track Your Progress",
      body: "Monitor your mental health journey with easy-to-use tools.",
      image: _buildRoundedImage('assets/light-bulb-5947393_1920.png'),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 18.0),
        imagePadding: EdgeInsets.only(top: 40),
      ),
    ),
  ];

  static Widget _buildRoundedImage(String imagePath, {bool isAsset = true}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: isAsset
            ? Image.asset(imagePath, width: 350, height: 350, fit: BoxFit.cover)
            : Image.network(imagePath,
                width: 350, height: 350, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () {
        // navigate to home page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
      onSkip: () {
        // Navigate to the main app when skipped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.navigate_next),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
