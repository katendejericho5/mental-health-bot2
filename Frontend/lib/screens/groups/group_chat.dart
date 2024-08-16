import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/add_members.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WellCareBot/models/chat_model.dart';
import 'package:WellCareBot/services/cloud_service.dart';

class GroupChatScreen extends StatelessWidget {
  final Group group;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _messageController = TextEditingController();

  GroupChatScreen({required this.group});

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUser!.uid,
        content: _messageController.text,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addGroupMessage(group.id, newMessage);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () => _showMembersList(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _firestoreService.getGroupMessages(group.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(message.senderId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(title: Text(message.content));
                        }
                        final userName =
                            userSnapshot.data?['fullName'] ?? 'Unknown';
                        return ListTile(
                          title: Text(message.content),
                          subtitle: Text(userName),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMembersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait(
            group.memberIds.map((id) =>
                FirebaseFirestore.instance.collection('users').doc(id).get()),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No members found'));
            }
            return Column(
              children: [
                ListTile(
                  title: Text('Group Members',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMembersScreen(group: group),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data![index];
                      final userName = user['fullName'] ?? 'Unknown';
                      return ListTile(
                        title: Text(userName),
                        subtitle: Text(user['email'] ?? ''),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
