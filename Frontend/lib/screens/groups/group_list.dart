import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/create_group_screen.dart';
import 'package:WellCareBot/screens/groups/group_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/services/cloud_service.dart';

class GroupListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('My Groups')),
      body: StreamBuilder<List<Group>>(
        stream: _firestoreService.getUserGroups(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No groups found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final group = snapshot.data![index];
              return ListTile(
                title: Text(group.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatScreen(group: group),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupScreen()),
          );
        },
      ),
    );
  }
}