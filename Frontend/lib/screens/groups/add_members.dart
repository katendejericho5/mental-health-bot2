import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          elevation: 0,
          title: Text(
            'Add Members',
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
              icon: Icon(Icons.check,
                  color: Colors.white, size: getProportionateScreenHeight(35)),
              onPressed: _addSelectedMembers,
            ),
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(getProportionateScreenHeight(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Divider(
                  color: Colors.white,
                ),
              ))),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Color.fromRGBO(3, 226, 246, 1)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No users found', style: GoogleFonts.poppins()));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final user = snapshot.data!.docs[index];
              final userId = user.id;
              final userName = user['fullName'] ?? 'Unknown';
              final imageUrl = user['profilePictureURL'] ?? '';
              final isSelected = selectedUsers.contains(userId);
              final isAlreadyMember = widget.group.memberIds.contains(userId);

              if (isAlreadyMember) {
                return SizedBox.shrink(); // Don't show already added members
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white.withOpacity(0.7),
                  child: CheckboxListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: getProportionateScreenWidth(18),
                                    fontWeight: FontWeight.w600)),
                            SizedBox(
                              width: getProportionateScreenWidth(190),
                              child: Text(user['email'] ?? '',
                                  style: GoogleFonts.nunito(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(12),
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                  ),
                ),
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
