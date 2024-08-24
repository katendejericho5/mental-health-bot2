import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/screens/groups/create_group_screen.dart';
import 'package:WellCareBot/screens/groups/group_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class GroupListScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Groups',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold), // Apply Poppins
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
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
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: StreamBuilder<List<Group>>(
              stream: _firestoreService.getUserGroups(currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState(context);
                }

                final groups = snapshot.data!;

                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _buildGroupCard(context, group);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, Group group) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            group.name[0].toUpperCase(),
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          group.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          'Tap to join the conversation',
          style: GoogleFonts.poppins(),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
          // Decorative SVG for empty state
          SvgPicture.asset(
            'assets/empty_state.svg', // Replace with your SVG asset path
            width: 100,
            height: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No groups yet',
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Create a group or join one to start connecting with others.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Create New Group'),
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
