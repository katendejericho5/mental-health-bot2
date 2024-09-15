import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatHistoryPage extends StatefulWidget {
  final String therapistThreadId;
  final String companion_thread_id;

  ChatHistoryPage({
    required this.therapistThreadId,
    required this.companion_thread_id,
  });

  @override
  _ChatHistoryPageState createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  late Future<List<ChatMessageHistory>> _therapistMessagesFuture;
  late Future<List<ChatMessageHistory>> _companionMessagesFuture;
  bool _isDescending = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _therapistMessagesFuture = _fetchMessages(widget.therapistThreadId);
      _companionMessagesFuture = _fetchMessages(widget.companion_thread_id);
    });
  }

  Future<List<ChatMessageHistory>> _fetchMessages(String threadId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
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
      return 'You';
    } else if (author == 'bot123') {
      return 'WellcareBot';
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
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          elevation: 0,
          title: Text(
            'AI Chat History',
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w700),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                color: Colors.white,
              ),
              onPressed: _toggleSortOrder,
            ),
          ],
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.blue, Color.fromRGBO(4, 190, 207, 1)]),
            ),
            unselectedLabelStyle: GoogleFonts.nunito(
                color: Colors.white.withOpacity(0.7),
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.w700),
            labelStyle: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.w700),
            tabs: [
              Tab(
                text: 'Therapist',
              ),
              Tab(text: 'Companion'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMessageList(
                _therapistMessagesFuture, widget.therapistThreadId),
            _buildMessageList(
                _companionMessagesFuture, widget.companion_thread_id),
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
          return Center(
              child: CircularProgressIndicator(
            color: Color.fromRGBO(3, 226, 246, 1),
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No messages found.',
                  style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w700)));
        } else {
          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Card(
                  color: _getSenderLabel(
                            message.author,
                          ) ==
                          'WellcareBot'
                      ? Color.fromRGBO(108, 104, 250, 1)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(message.text,
                          style: GoogleFonts.nunito(
                              color: _getSenderLabel(
                                        message.author,
                                      ) ==
                                      'WellcareBot'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _getSenderLabel(
                          message.author,
                        ),
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _formatDate(message.createdAt),
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: Icon(FontAwesomeIcons.trashCan, color: Colors.red),
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
