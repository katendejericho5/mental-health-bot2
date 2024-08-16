import 'package:WellCareBot/screens/settings/about.dart';
import 'package:WellCareBot/screens/settings/feedback.dart';
import 'package:WellCareBot/screens/settings/privacy_and_policy.dart';
import 'package:WellCareBot/screens/settings/profile_page.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mentalhealth/main.dart'; // Import ThemeNotifier

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool _darkMode = false;
  // bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildSwitchListTile(
            //   title: 'Enable Dark Mode',
            //   value: _darkMode,
            //   onChanged: (bool value) {
            //     setState(() {
            //       _darkMode = value;
            //       Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(
            //         _darkMode ? ThemeMode.dark : ThemeMode.light,
            //       );
            //     });
            //   },
            // ),
            // _buildSwitchListTile(
            //   title: 'Enable Notifications',
            //   value: _notificationsEnabled,
            //   onChanged: (bool value) {
            //     setState(() {
            //       _notificationsEnabled = value;
            //       // Handle notifications settings
            //     });
            //   },
            // ),
            _buildListTile(
              title: 'Feedback',
              onTap: () {
                // Navigate to Privacy Settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
            ),
            SizedBox(height: 20),
                 _buildListTile(
              title: 'Profile',
              onTap: () {
                // Navigate to Privacy Settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildListTile(
              title: 'Privacy and Policy',
              onTap: () {
                // Navigate to Privacy Settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                );
              },
            ),
            _buildListTile(
              title: 'About',
              onTap: () {
                // Navigate to About page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
