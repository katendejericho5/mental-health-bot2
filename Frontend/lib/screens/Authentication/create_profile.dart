import 'dart:io';
import 'package:WellCareBot/screens/Home/introduction.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateProfileScreen extends StatefulWidget {
  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String? _selectedGender;
  String _phoneNumber = '';
  XFile? _profileImage;

  // Gender options
  final List<String> _genders = ['Male', 'Female', 'Other'];

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  Future<String> _uploadProfilePicture(File profilePicture) async {
    try {
      final User user = _auth.currentUser!;
      final String filePath =
          'userProfilePictures/${user.uid}/profilePicture.jpg';
      final Reference storageRef = _storage.ref().child(filePath);

      // Start the upload task
      UploadTask uploadTask = storageRef.putFile(profilePicture);

      // Wait for the upload to complete
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      print('Upload complete, URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return '';
    }
  }

  Future<void> _saveUserProfile() async {
    final User user = _auth.currentUser!;
    String profilePictureURL = '';

    if (_profileImage != null) {
      profilePictureURL =
          await _uploadProfilePicture(File(_profileImage!.path));
    }

    await _firestore.collection('users').doc(user.uid).set({
      'fullName': _fullName,
      'gender': _selectedGender,
      'phoneNumber': _phoneNumber,
      'profilePictureURL': profilePictureURL,
      'email': user.email,
      'createdOn': DateTime.now(),
    });

    print('Profile saved to Firestore');
  }

  void _continue() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await _saveUserProfile();
      // Handle profile creation logic here
      print('Full Name: $_fullName');
      print('Gender: $_selectedGender');
      print('Profile Image: ${_profileImage?.path}');

      // navigate to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              IntroductionPage(), // Replace with your target screen
        ),
      );
    }
  }

  void _skip() {
    // Handle skip logic here
    print('Skipped profile creation');
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => HomePage2(), // Replace with your target screen
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Create Your Profile',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Please enter your details to complete your profile, don't worry your details are private",
                        maxLines: 3,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ), // Set black border
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value!;
                },
              ),
              SizedBox(height: 16.0),
              IntlPhoneField(
                flagsButtonPadding: const EdgeInsets.all(8),
                dropdownIconPosition: IconPosition.trailing,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ), // Set black border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    // Set black border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                  print(phone.completeNumber);
                },
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ), // Set black border
                  ),
                ),
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: _genders.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: _skip,
                        child: Text('Skip'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          textStyle: TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: _continue,
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
