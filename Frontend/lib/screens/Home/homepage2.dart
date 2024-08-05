import 'package:WellCareBot/screens/modes.dart/companion_chatbot.dart';
import 'package:WellCareBot/screens/modes.dart/therapist_chatbot.dart';
import 'package:WellCareBot/screens/booking/booking.dart';
import 'package:WellCareBot/screens/settings/profile_page.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage2 extends StatefulWidget {
  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int _currentIndex = 0;

  List<Widget> _pages() => [
        HomeScreen(),
        BookingsPage(),
        SettingsPage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
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

  @override
  void initState() {
    super.initState();
    _darkMode = Provider.of<ThemeNotifier>(context, listen: false).themeMode ==
        ThemeMode.dark;
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

  Future<String> _fetchUserName() async {
    final User user = _auth.currentUser!;
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
        leading: FutureBuilder<String>(
          future: _fetchProfilePictureURL(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return CircleAvatar(
                backgroundImage:
                    AssetImage('assets/relaxation-7282116_1280.jpg'),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: snapshot.data != ''
                        ? NetworkImage(snapshot.data!)
                        : AssetImage('assets/relaxation-7282116_1280.jpg'),
                  ),
                ),
              );
            }
          },
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
                    return SizedBox.shrink(); // Placeholder while loading
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        Text(
                          'WellCareBot',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            'WellCareBot',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
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
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
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
                                threadId: 'companionship_thread_id',
                              ),
                            ),
                          );
                        },
                        child: const Text('Companion Mode'),
                      ),
                    ),
                    const SizedBox(height: 20), // Spacer between buttons
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
