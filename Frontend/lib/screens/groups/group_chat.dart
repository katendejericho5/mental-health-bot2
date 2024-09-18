import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/add_members.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WellCareBot/models/chat_model.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final spinkit = SpinKitThreeBounce(
    color: Colors.blueAccent,
  );

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
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.trashCan,
                    color: Colors.red, size: getProportionateScreenWidth(25)),
              ),
              Text(
                'Delete Message',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this message?',
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(17),
                fontWeight: FontWeight.w700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.nunito(
                      color: Colors.red,
                      fontSize: getProportionateScreenWidth(16),
                      fontWeight: FontWeight.w700)),
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
                    SnackBar(
                      content: Text('Failed to delete message',
                          style: GoogleFonts.poppins(fontSize: 16)),
                      backgroundColor: Color.fromRGBO(3, 226, 246, 1),
                    ),
                  );
                }
              },
              child: Text('Delete',
                  style: GoogleFonts.nunito(
                      color: Colors.green,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
    }
  }

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) =>
      Bubble(
        child: child,
        color: _userId != message.author.id ||
                message.type == types.MessageType.image
            ? Color.fromRGBO(108, 104, 250, 1)
            : Colors.white,
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : null,
        nip: nextMessageInGroup
            ? BubbleNip.no
            : _userId != message.author.id
                ? BubbleNip.leftBottom
                : BubbleNip.rightBottom,
      );

  Future<void> _showMessageLoader() async {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: spinkit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          widget.group.name,
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
              FontAwesomeIcons.userGroup,
              color: Colors.white,
              size: getProportionateScreenHeight(25),
            ),
            onPressed: () => _showMembersList(context),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(getProportionateScreenHeight(15)),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Divider(
                color: Colors.white,
              ),
            )),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: types.User(id: _userId),
              showUserAvatars: false,
              showUserNames: false,
              bubbleBuilder: _bubbleBuilder,
              scrollPhysics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onMessageLongPress: _handleMessageLongPress,
              emptyState: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(85)),
                    Image.asset(
                      'assets/images/bots/nomessages.png',
                      height: getProportionateScreenHeight(300),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No messages yet',
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              theme: DefaultChatTheme(
                backgroundColor: Color.fromRGBO(17, 6, 60, 1),
                messageBorderRadius: 15,
                dateDividerTextStyle: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w600),
                inputTextCursorColor: theme.colorScheme.primary,
                inputSurfaceTintColor: theme.colorScheme.surfaceTint,
                inputBackgroundColor: theme.colorScheme.surface,
                inputTextColor: theme.colorScheme.onSurface,
                sendButtonIcon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(2, 106, 111, 1),
                          Color.fromRGBO(3, 226, 246, 1)
                        ]),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Icon(FontAwesomeIcons.solidPaperPlane,
                          color: Colors.white,
                          size: getProportionateScreenWidth(15)),
                    ),
                  ),
                ),
                inputMargin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                inputTextStyle: GoogleFonts.nunito(
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal),
                sentMessageBodyTextStyle: GoogleFonts.poppins(
                  textStyle: GoogleFonts.nunito(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.normal),
                ),
                receivedMessageBodyTextStyle: GoogleFonts.poppins(
                    textStyle: GoogleFonts.nunito(
                        fontSize: getProportionateScreenWidth(15),
                        color: Colors.white,
                        fontWeight: FontWeight.normal)),
                inputBorderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(30),
                  right: Radius.circular(30),
                ),
                inputContainerDecoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  border:
                      Border.all(color: theme.colorScheme.outline, width: 1.0),
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
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showMembersList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(62, 82, 213, 1),
      builder: (BuildContext context) {
        return FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait(
            widget.group.memberIds.map((id) =>
                FirebaseFirestore.instance.collection('users').doc(id).get()),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                      color: Color.fromRGBO(3, 226, 246, 1)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No members found'));
            }
            return Column(
              children: [
                ListTile(
                  title: Text(
                    'Group Members',
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: getProportionateScreenWidth(20),
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add,
                        color: Colors.white,
                        size: getProportionateScreenWidth(25)),
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
                      final imageUrl = user['profilePictureURL'] ?? '';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Color.fromRGBO(17, 6, 60, 1),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl)),
                            title: Text(
                              userName,
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              user['email'] ?? '',
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(16),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
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
