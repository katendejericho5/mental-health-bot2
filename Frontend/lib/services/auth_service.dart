import 'package:WellCareBot/screens/Authentication/create_profile.dart';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper {
  static Future<AppUser?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? firebaseUser;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      firebaseUser = userCredential.user;
      await firebaseUser!.updateProfile(displayName: name);
      await firebaseUser.reload();
      firebaseUser = auth.currentUser;

      return AppUser(
        uid: firebaseUser!.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<AppUser?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? firebaseUser;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = userCredential.user;

      return AppUser(
        uid: firebaseUser!.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return null;
  }

  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
   final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   // Sign in with Google
   Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Request permissions
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // Check if the user cancelled the sign-in process
      if (gUser == null) {
        throw PlatformException(
          code: 'sign_in_failed',
          message: 'The user cancelled the sign-in process',
        );
      }

      // Obtain auth details from the request
      final GoogleSignInAuthentication? gAuth = await gUser.authentication;

      // Create a new credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken,
        idToken: gAuth?.idToken,
      );

      // Use the new credential to sign in
        UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;
       // Check if the user's profile exists in Firestore
      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (!userDoc.exists) {
          // Navigate to the profile creation screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateProfileScreen()),
          );
        } else {
          // Navigate to the homepage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e) {
      throw PlatformException(
        code: 'sign_in_failed',
        message: e.toString(),
      );
    }
    
  }
}
