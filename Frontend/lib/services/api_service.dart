import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  static const String _baseUrl =
      "http://wellcarebot.eastus2.cloudapp.azure.com:5000";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get thread ID from Firestore or generate a new one for the specified mode
  Future<String> getThreadId(String mode) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    DocumentSnapshot threadDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('threads')
        .doc(mode)
        .get();

    if (threadDoc.exists) {
      return threadDoc.get('thread_id') as String;
    } else {
      // Generate a new thread ID and store it in Firestore
      String threadId = await _generateThreadId();
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('threads')
          .doc(mode)
          .set({'thread_id': threadId});
      return threadId;
    }
  }

  // Generate a new thread ID by making a GET request to the backend
  Future<String> _generateThreadId() async {
    final url = Uri.parse('$_baseUrl/thread');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['thread_id'];
    } else {
      throw Exception('Failed to generate thread ID');
    }
  }

  // Get chatbot response for Therapist mode, include user email if logged in
  Future<String> getChatbotResponseTherapist(String message) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    String email = user.email!;
    String threadId = await getThreadId('therapist');
    return _getChatbotResponse(message, threadId, '/chat/therapist',
        email: email);
  }

  Future<String> getChatbotResponseCompanion(String message) async {
    String threadId = await getThreadId('companion');
    return _getChatbotResponse(message, threadId, '/chat/companion');
  }

  // Generic method to make a POST request for chatbot response
  Future<String> _getChatbotResponse(
    String message,
    String threadId,
    String endpoint, {
    String? email,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final body = {
      'message': message,
      'thread_id': threadId,
    };
    if (email != null) {
      body['email'] = email;
    }
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['response'] ?? 'No response';
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded. Please try again later.');
    } else {
      throw Exception('Failed to get response from API');
    }
  }

  Future<void> renewRateLimit() async {
    final url = Uri.parse('$_baseUrl/renew-rate-limit');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to renew rate limit');
    }
  }

  // Clear thread ID from Firestore (if needed, e.g., for testing)
  Future<void> clearThreadId(String mode) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('threads')
        .doc(mode)
        .delete();
  }
}
