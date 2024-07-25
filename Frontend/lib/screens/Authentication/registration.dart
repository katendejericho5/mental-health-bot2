import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mentalhealth/screens/Authentication/profile.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Handle registration logic here
      print('Name: $_name');
      print('Email: $_email');
      print('Password: $_password');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateProfileScreen(),
        ),
      );
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: Text(
                      'Wellcare Bot',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // this will be replaced by gradient
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  // labelStyle: TextStyle(color: Colors.blue),
                  // prefixIcon: Icon(Icons.person, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  // labelStyle: TextStyle(color: Colors.green),
                  // prefixIcon: Icon(Icons.email, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
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
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  // labelStyle: TextStyle(color: Colors.red),
                  // prefixIcon: Icon(Icons.lock, color: Colors.red),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      // color: Colors.red,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
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
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      // Handle login navigation
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Brand(Brands.google),
                    iconSize: 50.0,
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  SizedBox(width: 20.0),
                  IconButton(
                    icon: Brand(Brands.microsoft),
                    iconSize: 50.0,
                    onPressed: () {
                      // Handle Microsoft login
                    },
                  ),
                  SizedBox(width: 20.0),
                  IconButton(
                    icon: Brand(Brands.apple_logo),
                    iconSize: 50.0,
                    onPressed: () {
                      // Handle Apple login
                    },
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
