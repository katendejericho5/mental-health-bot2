import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/add_members.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WellCareBot/models/chat_model.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_svg/flutter_svg.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;

  GroupChatScreen({required this.group});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<types.Message> _messages = [];
  late String _userId = '';
  Map<String, dynamic> _typingUsers = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await _fetchUserData();
      _loadMessages();
      _listenToTypingStatus();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;
        _userId = userData['uid'] ?? user.uid;
      } else {
        _userId = user.uid;
      }
    } else {
      throw Exception('User not logged in');
    }
  }

  void _loadMessages() {
    _firestoreService.getGroupMessages(widget.group.id).listen(
      (messages) {
        setState(
          () {
            _messages.clear();
            _messages.addAll(messages.map((message) => types.TextMessage(
                  author: types.User(id: message.senderId),
                  createdAt: message.createdAt.millisecondsSinceEpoch,
                  id: message.id,
                  text: message.content,
                )));
          },
        );
      },
    );
  }

  void _listenToTypingStatus() {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection('typing')
        .snapshots()
        .listen((snapshot) {
      Map<String, dynamic> typingUsers = {};
      for (var doc in snapshot.docs) {
        typingUsers[doc.id] = doc.data()['isTyping'] ?? false;
      }
      setState(() {
        _typingUsers = typingUsers;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _userId,
      content: message.text,
      createdAt: DateTime.now(),
    );

    await _firestoreService.addGroupMessage(widget.group.id, newMessage);
    await _updateTypingStatus(false);
  }

  Future<void> _updateTypingStatus(bool isTyping) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection('typing')
        .doc(_userId)
        .set({'isTyping': isTyping}, SetOptions(merge: true));
  }

  void _handleMessageLongPress(BuildContext context, types.Message message) {
    if (message.author.id == _userId) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Message'),
          content: Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first
                bool success = await _firestoreService.deleteGroupMessage(
                    widget.group.id, message.id);
                if (success) {
                  print("Message deletion successful");
                  // No need to manually update _messages, the stream will handle it
                } else {
                  print("Message deletion failed");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete message')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor =
        theme.brightness == Brightness.light ? Colors.white : Colors.grey[900]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () => _showMembersList(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background SVG
          // Background SVG
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
          Column(
            children: [
              SizedBox(height: 10),
              Expanded(
                child: Chat(
                  messages: _messages,
                  onSendPressed: _handleSendPressed,
                  user: types.User(id: _userId),
                  showUserAvatars: true,
                  showUserNames: true,
                  scrollPhysics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  onMessageLongPress: _handleMessageLongPress,
                  theme: DefaultChatTheme(
                    backgroundColor: backgroundColor,
                    inputTextCursorColor: theme.colorScheme.primary,
                    inputSurfaceTintColor: theme.colorScheme.surfaceTint,
                    inputBackgroundColor: theme.colorScheme.surface,
                    inputTextColor: theme.colorScheme.onSurface,
                    sendButtonIcon:
                        Icon(Icons.send, color: theme.colorScheme.primary),
                    inputMargin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    inputTextStyle:
                        TextStyle(color: theme.colorScheme.onSurface),
                    inputBorderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10),
                      right: Radius.circular(10),
                    ),
                    inputContainerDecoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border.all(
                          color: theme.colorScheme.outline, width: 1.0),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(30),
                        right: Radius.circular(30),
                      ),
                    ),
                    primaryColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (_typingUsers.values.any((isTyping) => isTyping))
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '${_typingUsers.entries.where((entry) => entry.value).map((entry) => entry.key).join(", ")} is typing...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
            ],
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
            widget.group.memberIds.map((id) =>
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
                          builder: (context) =>
                              AddMembersScreen(group: widget.group),
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
