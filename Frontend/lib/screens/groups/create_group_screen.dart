import 'package:WellCareBot/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firestoreService = FirestoreService();

  void _createGroup() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final newGroup = Group(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        creatorId: currentUser!.uid,
        memberIds: [currentUser.uid],
        createdAt: DateTime.now(),
      );

      await _firestoreService.createGroup(newGroup);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Group',
          style:
              GoogleFonts.poppins(), // Apply Google Fonts to the AppBar title
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  labelStyle:
                      GoogleFonts.poppins(), // Apply Google Fonts to the label
                ),
                style: GoogleFonts
                    .poppins(), // Apply Google Fonts to the text input
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createGroup,
                child: Text(
                  'Create Group',
                  style: GoogleFonts
                      .poppins(), // Apply Google Fonts to the button text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
