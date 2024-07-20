import 'package:flutter/material.dart';
import 'package:mentalhealth/pages/HOME/companion.dart';
import 'package:mentalhealth/pages/HOME/homepage.dart';
import 'package:mentalhealth/pages/WelcomeScreen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'pages/HOME/therapist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        // '/home': (context) => const MentalHealthPage(),
        '/home': (context) => const CompanionModePage(),
        '/homepage': (context) => const Homepage(),
      },
    );
  }
}
