import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/create_group_screen.dart';
import 'package:WellCareBot/screens/groups/group_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          'My Groups',
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<Group>>(
        stream: _firestoreService.getUserGroups(currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Color.fromRGBO(3, 226, 246, 1)));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context);
          }

          final groups = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildGroupCard(context, group);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
            child: Icon(FontAwesomeIcons.peopleGroup, color: Colors.white)),
        onPressed: () {
          _createNewGroupDilague(context);
        },
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<void> _createNewGroupDilague(context) async {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 200.0, top: 100),
            child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Create New Group',
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(22),
                            fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.cancel, color: Colors.white),
                      ),
                    )
                  ],
                ),
                content: CreateGroupScreen(),
                backgroundColor: Color.fromRGBO(17, 6, 60, 1)),
          );
        });
  }

  Widget _buildGroupCard(BuildContext context, Group group) {
    return Card(
      elevation: 2,
      color: Color.fromRGBO(62, 82, 213, 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Text(
            group.name[0].toUpperCase(),
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          group.name,
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tap to join the conversation',
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.normal)),
        trailing: Icon(Icons.arrow_forward_ios,
            color: Colors.white, size: getProportionateScreenWidth(15)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupChatScreen(group: group),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 100, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No groups yet',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Create a group or join one to start connecting with others.',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Create New Group',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateGroupScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
