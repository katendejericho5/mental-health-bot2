import 'dart:async';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/screens/welcome/welcome_screen.dart';
import 'package:WellCareBot/services/shared_preferences.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'constant/size_config.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData.dark(),
          home: AuthCheck(),
          routes: {
            '/settings': (context) => SettingsPage(),
          },
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                      color: Color.fromRGBO(3, 226, 246, 1))));
        } else if (snapshot.hasData) {
          // User is logged in
          return HomePage(); // Navigate to home page
        } else {
          // User is not logged in
          return WelcomeScreen(); // Navigate to welcome screen
        }
      },
    );
  }
}
