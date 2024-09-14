import 'package:WellCareBot/screens/groups/group_list.dart';
import 'package:WellCareBot/screens/modes/companion_chatbot.dart';
import 'package:WellCareBot/screens/modes/therapist_chatbot.dart';
import 'package:WellCareBot/screens/booking/booking_page.dart';
import 'package:WellCareBot/screens/settings/profile_page.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _pages() => [
        HomeScreen(),
        BookingsPage(),
        GroupListScreen(),
        SettingsPage(),
      ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 6, left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              items: [
                _buildBottomNavigationBarItem(
                  icon: FontAwesomeIcons.house,
                  label: 'Home',
                  index: 0,
                ),
                _buildBottomNavigationBarItem(
                  icon: FontAwesomeIcons.book,
                  label: 'Appointments',
                  index: 1,
                ),
                _buildBottomNavigationBarItem(
                  icon: FontAwesomeIcons.peopleGroup,
                  label: 'Groups',
                  index: 2,
                ),
                _buildBottomNavigationBarItem(
                  icon: FontAwesomeIcons.cog,
                  label: 'Settings',
                  index: 3,
                ),
              ],
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF3498DB),
              unselectedItemColor: Colors.grey[600],
              selectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Colors.lightGreenAccent.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: FaIcon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF27AE60) : Colors.grey[600],
        ),
      ),
      label: label,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _darkMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  String? therapistThreadId;
  String? companionThreadId;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _darkMode = Provider.of<ThemeNotifier>(context, listen: false).themeMode ==
        ThemeMode.dark;
  }

  Future<void> _initializeData() async {
    try {
      await _getOrSetThreadIdTherapist();
      await _getOrSetThreadIdCompanion();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _getOrSetThreadIdTherapist() async {
    therapistThreadId = await _apiService.getThreadId('therapist');
  }

  Future<void> _getOrSetThreadIdCompanion() async {
    companionThreadId = await _apiService.getThreadId('companion');
  }

  Future<String> _fetchProfilePictureURL() async {
    final User user = _auth.currentUser!;
    final storageRef = _storage
        .ref()
        .child('userProfilePictures/${user.uid}/profilePicture.jpg');

    try {
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return '';
    }
  }

  // Future<String> _fetchUserName() async {
  //   final User user = _auth.currentUser!;
  //   DocumentSnapshot userDoc =
  //       await _firestore.collection('users').doc(user.uid).get();

  //   return userDoc['fullName'] ?? 'User';
  // }
  Future<String> _fetchUserName() async {
    final User user = _auth.currentUser!;
    // Check if the user has a displayName (Google Sign-In)
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

    // Fallback to Firestore data for email/password sign-in
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    return userDoc['fullName'] ?? 'User';
  }

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
      Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(
        _darkMode ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfilePicture(
                profilePictureUrlFuture: _fetchProfilePictureURL()),
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              _darkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.cloudMoon,
              color: _darkMode ? Colors.lightBlue : Colors.blue.shade700,
            ),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: _fetchUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        Text(
                          'WellCareBot',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'assets/relaxation-7282116_1280.jpg',
                              height: 150,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Hello there',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ); // Placeholder while loading
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        Text(
                          'WellCareBot',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            color: Colors.blueGrey[800],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'assets/relaxation-7282116_1280.jpg',
                              height: 150,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Hello there',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                            'WellCareBot',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              color: Colors.blueGrey[800],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'assets/relaxation-7282116_1280.jpg',
                                height: 150,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Hello, ${snapshot.data}',
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Center(
                child: Text(
                  'Start a conversation with WellCareBot right now!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Companion Mode Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanionChatBot(
                                threadId: 'companion_thread_id',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Companion Mode',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Spacer between buttons
                    // Therapist Mode Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TherapistChatBot(
                                threadId: 'therapist_thread_id',
                              ),
                            ),
                          );
                        },
                        child: const Text('Therapist Mode'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final Future<String> profilePictureUrlFuture;

  ProfilePicture({required this.profilePictureUrlFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: profilePictureUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/relaxation-7282116_1280.jpg'),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/relaxation-7282116_1280.jpg'),
          );
        } else {
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        }
      },
    );
  }
}
