import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mental Health',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.teal[900]),
        actions: [
          Icon(Icons.settings, color: Colors.teal[900]),
        ],
      ),
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20.0),
            const CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage(
                  'homescreen.png'), // Add your logo image to the assets folder
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Set the minimum size to 40
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.heart_broken,
                      size: 18.0, color: Color.fromARGB(255, 39, 75, 71)),
                  SizedBox(width: 10.0),
                  Text(
                    'Therapist Mode',
                    style: TextStyle(
                        fontSize: 22.0, color: Color.fromARGB(255, 39, 75, 71)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.heart_broken,
                      size: 22.0, color: Color.fromARGB(255, 52, 87, 83)),
                  SizedBox(width: 10.0),
                  Text(
                    'Companion',
                    style: TextStyle(
                        fontSize: 18.0, color: Color.fromARGB(255, 39, 75, 71)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.local_hospital, color: Colors.teal[700], size: 40.0),
                Icon(Icons.healing, color: Colors.teal[700], size: 40.0),
                Icon(Icons.local_pharmacy, color: Colors.teal[700], size: 40.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
