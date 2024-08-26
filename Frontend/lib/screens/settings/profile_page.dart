import 'package:WellCareBot/screens/Authentication/login.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'settings.dart';
import 'history.dart';
import 'privacy_and_policy.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _fetchUserData() async {
    final User user = _auth.currentUser!;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    return userDoc.data() as Map<String, dynamic>;
  }

  // void _logout() async {
  //   await FirebaseAuthHelper.logout(context);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //   );
  // }
  void _logout() async {
    await FirebaseAuthHelper.logout(context);
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Stack(
          children: [
            // First full-screen SVG Background
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/undraw_chat_re_re1u.svg',
                fit: BoxFit.contain,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
              ),
            ),
            // Second SVG as a design element or additional background
            Positioned(
              top: 20,
              left: 20,
              width: 80,
              height: 80,
              child: SvgPicture.asset(
                'assets/undraw_mindfulness_8gqa.svg',
                fit: BoxFit.contain,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
              ),
            ),
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
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  // Display error message and default profile data
                  return _buildProfileContent(
                    profilePictureURL: '',
                    fullName: 'Error loading data',
                    email: 'Please try again later',
                    isLoading: false,
                  );
                } else {
                  final data = snapshot.data!;
                  return _buildProfileContent(
                    profilePictureURL: data['profilePictureURL'] ?? '',
                    fullName: data['fullName'] ?? 'No Name',
                    email: data['email'] ?? 'No Email',
                    isLoading: false,
                  );
                }
              },
            ),
          ],
        ));
  }

  Widget _buildProfileContent({
    required String profilePictureURL,
    required String fullName,
    required String email,
    required bool isLoading,
  }) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: profilePictureURL.isNotEmpty
                    ? NetworkImage(profilePictureURL)
                    : AssetImage('assets/relaxation-7282116_1280.jpg'),
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 10),
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        ListTile(
          leading: Icon(Icons.history, color: Colors.blue),
          title: Text('History'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHistoryPage(
                  therapistThreadId: 'therapist_thread_id',
                  companionThreadId: 'companion_thread_id',
                ),
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings, color: Colors.blue),
          title: Text('Settings'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: Colors.blue),
          title: Text('Privacy and Policy'),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()),
            );
          },
        ),
        Divider(),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: _logout,
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
