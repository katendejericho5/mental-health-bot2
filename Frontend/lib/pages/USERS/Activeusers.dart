import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentalhealth/pages/OTHERS/Drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Users());
}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ACTIVE PLAYERS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(148, 12, 50, 70),
      ),
      drawer: CustomDrawer(),
      backgroundColor: Color.fromARGB(255, 205, 223, 238),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('client').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> clients =
              snapshot.data!.docs.reversed.toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
              ],
              rows: clients
                  .map(
                    (client) => DataRow(cells: [
                      DataCell(Text(client['id'].toString())),
                      DataCell(Text(client['name'].toString())),
                    ]),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
