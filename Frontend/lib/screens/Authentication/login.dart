// login_screen.dart

import 'package:WellCareBot/components/default_button.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/user_model.dart';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:WellCareBot/screens/Authentication/forgot_password.dart';
import 'package:WellCareBot/screens/Authentication/registration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      AppUser? user = await FirebaseAuthHelper.signInUsingEmailPassword(
        context: context,
        email: _email,
        password: _password,
      );

      if (user != null) {
        // Navigate to the home screen or user profile screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Replace with your target screen
          ),
        );
      } else {
        // Handle login failure (e.g., show an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                image: AssetImage('assets/images/onboarding/welcome.png'),
                height: getProportionateScreenHeight(150),
              ),
              SizedBox(height: getProportionateScreenHeight(2)),
              Text(
                "Sign In",
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Sign in to continue!",
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w300),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 6.0, top: 6.0, bottom: 6.0),
                    child: Text(
                      "Email Address",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(45))
                ],
              ),
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
                        borderSide: BorderSide(color: Colors.white))),
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
              SizedBox(height: getProportionateScreenHeight(2)),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 6.0, top: 6.0, bottom: 6.0),
                    child: Text(
                      "Password",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(45))
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'krona',
                  ),
                  suffixIcon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
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
                obscureText: _obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              DefaultButton(
                press: _submit,
                text: 'Login',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // Handle forgot password logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.nunito(
                            color: Colors.blueAccent,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.normal)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      '\tSign Up',
                      style: GoogleFonts.nunito(
                          color: Colors.blueAccent,
                          fontSize: getProportionateScreenWidth(15),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white.withOpacity(0.8),
                      height: 36,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('or',
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.normal)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white.withOpacity(0.8),
                      height: 36,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(2, 106, 111, 0.5),
                            Color.fromRGBO(3, 226, 246, 0.5)
                          ]),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Brand(Brands.google),
                      iconSize: 50.0,
                      onPressed: () {
                        // Handle Google login
                        FirebaseAuthHelper().signInWithGoogle(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Container(
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(2, 106, 111, 0.5),
                            Color.fromRGBO(3, 226, 246, 0.5)
                          ]),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Brand(Brands.microsoft),
                      iconSize: 50.0,
                      onPressed: () async {
                        // Handle Microsoft login
                        FirebaseAuthHelper().signInWithMicrosoft(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Container(
                    height: getProportionateScreenHeight(50),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(2, 106, 111, 0.5),
                            Color.fromRGBO(3, 226, 246, 0.5)
                          ]),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Brand(Brands.apple_logo),
                      iconSize: 50.0,
                      onPressed: () {
                        // Handle Apple login
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
