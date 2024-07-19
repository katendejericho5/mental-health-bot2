import 'package:flutter/material.dart';

void main() {
  runApp(SettingsPage());
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLocationEnabled = false;
  bool _isNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(148, 12, 50, 70),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Location Services'),
              value: _isLocationEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isLocationEnabled = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: _isNotificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isNotificationsEnabled = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _isDarkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  // You can apply dark mode theme here
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
