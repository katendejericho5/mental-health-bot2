// import 'package:flutter/material.dart';
// import 'package:mentalhealth/pages/AUTHENTICATION/OTHERS/OTHER/OTHERS/Drawer.dart';

// class Profile extends StatelessWidget {
//   const Profile({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'USER PROFILE',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color.fromARGB(148, 12, 50, 70),
//       ),
//       drawer: CustomDrawer(),
//       backgroundColor: Color.fromARGB(255, 205, 223, 238),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: AssetImage('lib/images/marvin.jpeg'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Rusoke Marvin',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'rusokemarvin@gmail.com',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               elevation: 3,
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Additional Information',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     ListTile(
//                       leading: Icon(Icons.person),
//                       title: Text('Age: 22'),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.person_outline),
//                       title: Text('Gender: Male'),
//                     ),
//                     ListTile(
//                       leading: Icon(Icons.location_on),
//                       title: Text('Location: Uganda'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
