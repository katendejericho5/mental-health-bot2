import 'package:flutter/material.dart';
import 'package:mentalhealth/companion.dart';
// import 'package:mentalhealth/pages/HOME/homepage.dart';
// import 'package:mentalhealth/pages/WelcomeScreen.dart';
import 'pages/OTHERS/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'therapist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CompanionModePage(),
      routes: {
        // '/home': (context) => const MentalHealthPage(),

        '/home': (context) => const MentalHealthPage(),
        '/homepage': (context) => const MentalHealthPage(),
      },
    );
  }
}
