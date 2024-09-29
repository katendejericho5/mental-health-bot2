import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "New Group Name",
                hintStyle: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w600),
                prefixIcon: Icon(
                  Icons.group_add,
                  color: Colors.white,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.blueAccent.withOpacity(0.5),
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(62, 82, 213, 1), width: 2)),
              ),
              style: TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            // TextFormField(
            //   controller: _nameController,
            //   decoration: InputDecoration(labelText: 'Group Name'),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter a group name';
            //     }
            //     return null;
            //   },
            // ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: getProportionateScreenWidth(250),
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: _createGroup,
                  child: Text(
                    'Add Group',
                    style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: _createGroup,
            //   child: Text('Create Group',
            //       style: GoogleFonts.poppins(
            //         textStyle: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}
