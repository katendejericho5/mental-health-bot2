import 'package:WellCareBot/screens/groups/group_list.dart';
import 'package:WellCareBot/screens/modes/companion_chatbot.dart';
import 'package:WellCareBot/screens/modes/therapist_chatbot.dart';
import 'package:WellCareBot/screens/booking/booking_chat.dart';
import 'package:WellCareBot/screens/settings/profile_page.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // Full-screen SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/undraw_connection_re_lcud.svg',
              fit: BoxFit.cover,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          // Second SVG Background positioned at the bottom right
          Positioned(
            bottom: 20,
            right: 20,
            width: 100,
            height: 100,
            child: SvgPicture.asset(
              'assets/undraw_connection_re_lcud.svg',
              fit: BoxFit.contain,
              // color: isDarkMode
              //     ? Colors.white.withOpacity(0.2)
              //     : Colors.black.withOpacity(0.2),
            ),
          ),
          IndexedStack(
            index: _currentIndex,
            children: _pages(),
          ),
        ],
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
                  label: 'Bookings',
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
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
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
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
          Hero(
            tag: 'settings',
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full-screen SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/undraw_chat_re_re1u.svg',
              fit: BoxFit.contain,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          // Second SVG Background positioned at the top left
          Positioned(
            top: 20,
            left: 20,
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/undraw_mindfulness_8gqa.svg',
              fit: BoxFit.contain,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<String>(
                    future: _fetchUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildWelcomeSection('Hello there');
                      } else if (snapshot.hasError) {
                        return _buildWelcomeSection('Hello there');
                      } else {
                        return _buildWelcomeSection('Hello, ${snapshot.data}');
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
                        _buildModeButton(
                          tag: 'companion',
                          color: Colors.green,
                          text: 'Companion Mode',
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
                        ),
                        const SizedBox(height: 20),
                        _buildModeButton(
                          tag: 'therapist',
                          color: Colors.blue,
                          text: 'Therapist Mode',
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(String greeting) {
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
              greeting,
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

  Widget _buildModeButton({
    required String tag,
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Hero(
      tag: tag,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
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
