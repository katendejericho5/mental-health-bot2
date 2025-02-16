import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/Authentication/create_profile.dart';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WellCareBot/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper {
  static Future<AppUser?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
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

      // Send email verification
      await sendEmailVerification(context: context);

      return AppUser(
        uid: firebaseUser!.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops! An error occurred. Please try again.',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }

    return null;
  }

  static Future<AppUser?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? firebaseUser;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = userCredential.user;

      // Check if email is verified
      if (!firebaseUser!.emailVerified) {
        await sendEmailVerification(context: context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email before signing in.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
        return null;
      }

      return AppUser(
        uid: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No user found for that email.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wrong password provided.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops! An error occurred. Please try again.',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }

    return null;
  }

  static Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully logged out.',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(3, 226, 246, 1),
            ),
          );
        },
      );

      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) {
        Navigator.of(context).pop(); // Close loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The user cancelled the sign-in process.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        Navigator.of(context).pop(); // Close loading indicator

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'uid': firebaseUser.uid,
            'fullName': firebaseUser.displayName,
            'email': firebaseUser.email,
            'profilePictureURL': firebaseUser.photoURL,
            'phoneNumber': firebaseUser.phoneNumber,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateProfileScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: $e',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }
  }

  Future<void> signInWithMicrosoft(BuildContext context) async {
    final OAuthProvider provider = OAuthProvider('microsoft.com');
    provider.setCustomParameters(
        {"tenant": "39e1b070-39da-4546-bd43-fd0d9ed2cefc"});

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(3, 226, 246, 1),
            ),
          );
        },
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithProvider(provider);
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();

        Navigator.of(context).pop(); // Close loading indicator

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'uid': firebaseUser.uid,
            'fullName': firebaseUser.displayName,
            'email': firebaseUser.email,
            'profilePictureURL': firebaseUser.photoURL,
            'phoneNumber': firebaseUser.phoneNumber,
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateProfileScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Microsoft: $e',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }
  }

  // Forgot Password Method
  static Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent! Check your inbox.',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(15),
                  fontWeight: FontWeight.normal)),
          backgroundColor: Color.fromRGBO(3, 226, 246, 1),
        ),
      );
    }
  }

  // Send Email Verification Method
  static Future<void> sendEmailVerification({
    required BuildContext context,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent! Check your inbox.',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.normal)),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      } catch (e) {
        print('An error occurred while sending email verification: $e');
      }
    }
  }
}
