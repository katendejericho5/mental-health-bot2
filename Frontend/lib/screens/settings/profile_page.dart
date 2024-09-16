import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/Authentication/login.dart';
import 'package:WellCareBot/screens/settings/about.dart';
import 'package:WellCareBot/screens/settings/feedback.dart';
import 'package:WellCareBot/screens/welcome/welcome_screen.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'history.dart';
import 'privacy_and_policy.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();

  String? _therapistThreadId;
  String? _companionThreadId;

  Future<Map<String, dynamic>> _fetchUserData() async {
    final User user = _auth.currentUser!;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _fetchUserData();
      await _getOrSetThreadIdTherapist();
      await _getOrSetThreadIdCompanion();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void _logout() async {
    await FirebaseAuthHelper.logout(context);
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _getOrSetThreadIdTherapist() async {
    _therapistThreadId = await _apiService.getThreadId('therapist');
  }

  Future<void> _getOrSetThreadIdCompanion() async {
    _companionThreadId = await _apiService.getThreadId('companion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator and default profile data
                  return _buildProfileContent(
                      profilePictureURL: '',
                      fullName: 'Loading...',
                      email: 'Loading...',
                      isLoading: true,
                      number: 'Loading...');
                } else if (snapshot.hasError || !snapshot.hasData) {
                  // Display error message and default profile data
                  return _buildProfileContent(
                      profilePictureURL: '',
                      fullName: 'Error loading data',
                      email: 'Please try again later',
                      isLoading: false,
                      number: 'Loading...');
                } else {
                  final data = snapshot.data!;
                  return _buildProfileContent(
                      profilePictureURL: data['profilePictureURL'] ?? '',
                      fullName: data['fullName'] ?? 'No Name',
                      email: data['email'] ?? 'No Email',
                      isLoading: false,
                      number: data['phoneNumber'] ?? 'No Number');
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(62, 82, 213, 0.8),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text(
                    "Edit Profile",
                    style: GoogleFonts.nunitoSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: getProportionateScreenWidth(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 20),
                  subtitle: Text(
                    "Name, Phone Number, Adress",
                    style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color.fromRGBO(62, 82, 213, 0.8),
                  child: ListTile(
                    onTap: () {
                      // Navigate to Privacy Settings page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage()),
                      );
                    },
                    leading: const Icon(Icons.feedback,
                        color: Colors.white, size: 35),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 20),
                    title: Text(
                      "Feedback",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "Help us improve!",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(62, 82, 213, 0.8),
                child: ListTile(
                  onTap: () {
                    // Navigate to Privacy Settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                    );
                  },
                  leading: const Icon(
                    Icons.shield_moon,
                    color: Colors.white,
                    size: 35,
                  ),
                  title: Text("Privacy policy",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 20),
                  subtitle: Text(
                    "Get to know about out privacy policy",
                    style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Color.fromRGBO(62, 82, 213, 0.8),
                child: ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                  leading: const Icon(Icons.map, color: Colors.white, size: 35),
                  title: Text("About Us",
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(17),
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      color: Colors.white, size: 20),
                  subtitle: Text(
                    "know more about us, terms and conditions",
                    style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
      {required String profilePictureURL,
      required String fullName,
      required String email,
      required bool isLoading,
      required String number}) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
                child: Column(
              children: [
                Container(
                    height: getProportionateScreenHeight(270),
                    width: getProportionateScreenWidth(450),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profilePictureURL),
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.blue, BlendMode.darken),
                      ),
                    )),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
              ],
            )),
            Positioned(
                bottom: getProportionateScreenHeight(10),
                left: getProportionateScreenWidth(140),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profilePictureURL),
                  ),
                )),
            Positioned(
                top: getProportionateScreenHeight(10),
                right: getProportionateScreenWidth(10),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(fullName,
                              style: GoogleFonts.nunitoSans(
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          content: Text("Are you sure you want to logout?",
                              style: GoogleFonts.nunitoSans(
                                fontSize: getProportionateScreenWidth(13),
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              )),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              // onPressed: () => Navigator.pushNamed(
                              //     context, SignInScreen.routeName),
                              child: const Text("OK"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: getProportionateScreenWidth(25),
                    weight: getProportionateScreenWidth(15),
                  ),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(fullName,
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(email,
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(14),
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(number,
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(14),
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
