import 'package:WellCareBot/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WellCareBot/services/cloud_service.dart';

class AddMembersScreen extends StatefulWidget {
  final Group group;

  AddMembersScreen({required this.group});

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<String> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _addSelectedMembers,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final user = snapshot.data!.docs[index];
              final userId = user.id;
              final userName = user['fullName'] ?? 'Unknown';
              final isSelected = selectedUsers.contains(userId);
              final isAlreadyMember = widget.group.memberIds.contains(userId);

              if (isAlreadyMember) {
                return SizedBox.shrink(); // Don't show already added members
              }

              return CheckboxListTile(
                title: Text(userName),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedUsers.add(userId);
                    } else {
                      selectedUsers.remove(userId);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }

  void _addSelectedMembers() async {
    for (String userId in selectedUsers) {
      await _firestoreService.addGroupMember(widget.group.id, userId);
    }
    Navigator.pop(context);
  }
}