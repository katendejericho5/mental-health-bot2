import 'package:WellCareBot/screens/Authentication/login.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // void _logout() async {
  //   await FirebaseAuthHelper.logout(context);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginScreen()),
  //   );
  // }
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
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _getOrSetThreadIdTherapist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _therapistThreadId = prefs.getString('therapist_thread_id');

    if (_therapistThreadId == null) {
      _therapistThreadId =
          await _apiService.getThreadId(
              'therapist'
          ); // Fetch a new thread ID
      await prefs.setString('therapist_thread_id', _therapistThreadId!);
    }
  }

  Future<void> _getOrSetThreadIdCompanion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _companionThreadId = prefs.getString('companion_thread_id');

    if (_companionThreadId == null) {
      _companionThreadId =
          await _apiService.getThreadId(
              'companion'
          ); // Fetch a new thread ID
      await prefs.setString('companion_thread_id', _companionThreadId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
    );
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
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                email,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        ListTile(
          leading: Icon(Icons.history, color: Colors.blue),
          title: Text('History', style: GoogleFonts.poppins()),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHistoryPage(
                  therapistThreadId: _therapistThreadId!,
                  companion_thread_id: _companionThreadId!,
                ),
              ),
            );
          },
        ),
        Divider(),
        // ListTile(
        //   leading: Icon(Icons.settings, color: Colors.blue),
        //   title: Text('Settings', style: GoogleFonts.poppins()),
        //   trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => SettingsPage()),
        //     );
        //   },
        // ),
        // Divider(),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: Colors.blue),
          title: Text('Privacy and Policy', style: GoogleFonts.poppins()),
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
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
            textStyle: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
