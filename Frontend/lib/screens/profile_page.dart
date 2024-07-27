import 'package:WellCareBot/screens/history.dart';
import 'package:WellCareBot/screens/privacy_and_policy.dart';
import 'package:WellCareBot/screens/settings.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/relaxation-7282116_1280.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  "Katende Jericho",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "katendejericho5@gmail.com",
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
                MaterialPageRoute(builder: (context) => ChatHistoryPage()),
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
            onPressed: () {
              // Add logout functionality here
            },
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
      ),
    );
  }
}
