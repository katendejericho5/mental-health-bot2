import 'package:WellCareBot/components/default_button.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Call the resetPassword method from FirebaseAuthHelper
      await FirebaseAuthHelper.resetPassword(
        email: _email,
        context: context,
      );

      // Navigate back or show a message to the user
      Navigator.pop(
          context); // Go back to the previous screen or you can redirect to another screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 14, 132, 1),
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
                Color.fromRGBO(17, 6, 60, 1),
                Color.fromRGBO(37, 14, 132, 1)
              ]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image(
                image: AssetImage('assets/images/authentication/forgot.png'),
                height: getProportionateScreenHeight(350),
              ),
              Text(
                "Forgot Password?",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(32),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20.0),
              Text(
                'Please enter your email address to receive a password reset link.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'krona',
                  ),
                  suffixIcon: Icon(
                    Icons.email,
                    color: Color.fromRGBO(3, 226, 246, 1),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20.0),
              DefaultButton(
                press: _submit,
                text: 'Reset Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
