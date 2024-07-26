import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mentalhealth/main.dart';
import 'package:mentalhealth/screens/Home/companion_chatbot.dart';
import 'package:mentalhealth/screens/Home/therapist_chatbot.dart';
import 'package:mentalhealth/screens/history.dart';
import 'package:mentalhealth/screens/privacy_and_policy.dart';
import 'package:mentalhealth/screens/settings.dart';
import 'package:mentalhealth/services/api_service.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatefulWidget {
  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  String? _threadId;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _darkMode = Provider.of<ThemeNotifier>(context, listen: false).themeMode ==
        ThemeMode.dark;
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
              Scaffold.of(context).openDrawer();
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
      drawer: Drawer(
        width: 260,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(),
              accountName: Text(
                "Katende Jericho",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              accountEmail: Text(
                "katendejericho5@gmail.com",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    AssetImage('assets/relaxation-7282116_1280.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                // Handle history tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatHistoryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy and Policy'),
              onTap: () {
                // Handle privacy and policy tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              onTap: () {
                // Handle language tap
              },
            ),
            Divider(),
            SizedBox(
              height: 80,
            ),
            // ListTile(
            //   leading: Icon(Icons.brightness_6),
            //   title: Text('Dark Theme'),
            //   trailing: Switch(
            //     value: _darkMode, // Change to your current theme state
            //     onChanged: (bool value) {
            //       setState(() {
            //         _darkMode = value;
            //         Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(
            //           _darkMode ? ThemeMode.dark : ThemeMode.light,
            //         );
            //       });
            //     },
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Logout',
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
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                        onPressed: _handleCompanionMode,
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
                        onPressed: _handleTherapistMode,
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
