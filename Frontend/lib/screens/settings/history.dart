import 'package:WellCareBot/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
  late Future<List<ChatMessageHistory>> _therapistMessagesFuture;
  late Future<List<ChatMessageHistory>> _companionshipMessagesFuture;
  bool _isDescending = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _therapistMessagesFuture = _fetchMessages(widget.therapistThreadId);
      _companionshipMessagesFuture =
          _fetchMessages(widget.companionshipThreadId);
    });
  }

  Future<List<ChatMessageHistory>> _fetchMessages(String threadId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('threads')
          .doc(threadId)
          .collection('messages')
          .orderBy('created_at', descending: _isDescending)
          .get();

      return messagesSnapshot.docs
          .map((doc) => ChatMessageHistory.fromMap(doc.data()))
          .toList();
    } else {
      throw Exception('User not logged in');
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isDescending = !_isDescending;
      _loadMessages();
    });
  }

  void _deleteMessage(String threadId, String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('threads')
          .doc(threadId)
          .collection('messages')
          .doc(messageId)
          .delete();
      _loadMessages(); // Reload messages after deletion
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete message: $error')),
      );
    }
  }

  String _getSenderLabel(String author) {
    if (author == 'user') {
      return 'From You';
    } else if (author == 'bot123') {
      return 'From WellcareBot';
    } else {
      return 'From You'; // Fallback for any unexpected values
    }
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formatter = DateFormat('yyyy-MM-dd – HH:mm');
    return formatter.format(date);
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
              icon: Icon(
                _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
              ),
              onPressed: _toggleSortOrder,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Therapist'),
              Tab(text: 'Companion'),
            ],
          ),
        ),
        body: Stack(
        children: [
          // First full-screen SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/undraw_chat_re_re1u.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          // Second SVG as a design element or additional background
          Positioned(
            top: 20,
            left: 20,
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/undraw_mindfulness_8gqa.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
            TabBarView(
              children: [
                _buildMessageList(
                    _therapistMessagesFuture, widget.therapistThreadId),
                _buildMessageList(
                    _companionshipMessagesFuture, widget.companionshipThreadId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(
      Future<List<ChatMessageHistory>> messagesFuture, String threadId) {
    return FutureBuilder<List<ChatMessageHistory>>(
      future: messagesFuture,
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
                title: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(message.text),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSenderLabel(message.author),
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      _formatDate(message.createdAt),
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteMessage(threadId, message.id);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
