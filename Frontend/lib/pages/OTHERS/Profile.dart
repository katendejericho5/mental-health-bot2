import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 37, 150, 190),
      ),
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(179, 37, 149, 190),
            height: 80,
            child: Center(
              child: Container(
                child: Center(
                  child: Text(
                    'User Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Color.fromARGB(146, 0, 0, 0),
                    ),
                  ),
                ),
                height: 50,
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(84, 152, 216, 240),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('lib/images/marvin.jpeg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Rusoke Marvin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'rusokemarvin@gmail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Age: 22'),
                        ),
                        ListTile(
                          leading: Icon(Icons.person_outline),
                          title: Text('Gender: Male'),
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text('Location: Uganda'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
