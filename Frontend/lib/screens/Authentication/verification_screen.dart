import 'dart:async';
import 'package:WellCareBot/components/default_button.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/Authentication/create_profile.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Send verification email and start checking
    FirebaseAuthHelper.sendEmailVerification(context: context);
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;

    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // Navigate to the appropriate page after verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreateProfileScreen()),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(38, 230, 248, 0.9),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromRGBO(1, 60, 63, 1),
                  Color.fromRGBO(38, 230, 248, 1)
                ]),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: getProportionateScreenHeight(5)),
              Image(
                image: AssetImage(
                    'assets/images/authentication/email-confirm.png'),
                height: getProportionateScreenHeight(250),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Check Your Email",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                'We have sent an email to ${user?.email}. Please check your inbox and follow the instructions to verify your email.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(3, 226, 246, 1)),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                'Verifying email...',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              DefaultButton(
                text: '               Resend Email            ',
                press: () {
                  FirebaseAuthHelper.sendEmailVerification(context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
