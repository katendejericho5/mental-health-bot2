import 'package:WellCareBot/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHistoryPage extends StatefulWidget {
  final String therapistThreadId;
  final String companionshipThreadId;

  ChatHistoryPage({
    required this.therapistThreadId,
    required this.companionshipThreadId,
  });

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  late Future<List<ChatMessage>> _therapistMessagesFuture;
  late Future<List<ChatMessage>> _companionshipMessagesFuture;
  bool _isDescending = true; // Default sorting order

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _therapistMessagesFuture = _fetchMessages(widget.therapistThreadId);
    _companionshipMessagesFuture = _fetchMessages(widget.companionshipThreadId);
  }

  Future<List<ChatMessage>> _fetchMessages(String threadId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('threads')
          .doc(threadId)
          .collection('messages')
          .orderBy('created_at', descending: _isDescending)
          .get();

      return messagesSnapshot.docs.map((doc) => ChatMessage.fromMap(doc.data())).toList();
    } else {
      throw Exception('User not logged in');
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isDescending = !_isDescending;
      _loadMessages(); // Reload messages with new sort order
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat History'),
          actions: [
            IconButton(
              icon: Icon(_isDescending ? Icons.arrow_downward : Icons.arrow_upward),
              onPressed: _toggleSortOrder,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Therapist'),
              Tab(text: 'Companionship'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<ChatMessage>>(
              future: _therapistMessagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages found.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text('From: ${message.author}'),
                        trailing: Text(
                          DateTime.fromMillisecondsSinceEpoch(message.createdAt)
                              .toLocal()
                              .toString(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            FutureBuilder<List<ChatMessage>>(
              future: _companionshipMessagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages found.'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text('From: ${message.author}'),
                        trailing: Text(
                          DateTime.fromMillisecondsSinceEpoch(message.createdAt)
                              .toLocal()
                              .toString(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
