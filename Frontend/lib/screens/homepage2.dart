import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentalhealth/main.dart';
import 'package:mentalhealth/screens/Home/companion_chatbot.dart';
import 'package:mentalhealth/screens/Home/therapist_chatbot.dart';
import 'package:mentalhealth/screens/booking.dart';
import 'package:mentalhealth/screens/profile_page.dart';
import 'package:mentalhealth/screens/settings.dart';
import 'package:mentalhealth/services/api_service.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatefulWidget {
  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String? _threadId;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleTherapistMode() async {
    final apiService = ApiService();

    try {
      _threadId ??= await apiService.createThread();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TherapistChatBot(threadId: _threadId!),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> _handleCompanionMode() async {
    final apiService = ApiService();

    try {
      _threadId ??= await apiService.createThread();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanionChatBot(threadId: _threadId!),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  List<Widget> _pages() => [
        HomeScreen(
          onCompanionModePressed: _handleCompanionMode,
          onTherapistModePressed: _handleTherapistMode,
        ),
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
  final Function onCompanionModePressed;
  final Function onTherapistModePressed;

  HomeScreen({
    required this.onCompanionModePressed,
    required this.onTherapistModePressed,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _darkMode = Provider.of<ThemeNotifier>(context, listen: false).themeMode ==
        ThemeMode.dark;
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
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              // navigate

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/relaxation-7282116_1280.jpg'),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(
              _darkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
              color: _darkMode ? Colors.white : Colors.black,
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'WellCareBot',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
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
                  'Hello, Jericho',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 50),
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
                        onPressed: () => widget.onCompanionModePressed(),
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
                        onPressed: () => widget.onTherapistModePressed(),
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
