import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl =
      'https://54eb4eab-858c-4c1f-8835-a2ede0bc0de1-00-91p2lrp6g0ce.kirk.replit.dev';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get thread ID from Shared Preferences or generate a new one
  Future<String> getThreadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? threadId = prefs.getString('thread_id');

    if (threadId == null) {
      // Generate a new thread ID and store it in Shared Preferences
      threadId = await _generateThreadId();
      await prefs.setString('thread_id', threadId);
    }

    return threadId;
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
    String threadId = await getThreadId(); // Get or generate thread ID
    return _getChatbotResponse(message, threadId, '/chat/therapist',
        email: email);
  }

  // Get chatbot response for Companion mode
  Future<String> getChatbotResponseCompanion(String message) async {
    String threadId = await getThreadId(); // Get or generate thread ID
    return _getChatbotResponse(message, threadId, '/chat/companion');
  }

  // Generic method to make a POST request for chatbot response
  Future<String> _getChatbotResponse(
      String message, String threadId, String endpoint,
      {String? email}) async {
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

  // Renew rate limit if exceeded
  Future<void> renewRateLimit() async {
    final url = Uri.parse('$_baseUrl/renew-rate-limit');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to renew rate limit');
    }
  }

  // Clear thread ID from Shared Preferences (if needed, e.g., for testing)
  Future<void> clearThreadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('thread_id');
  }
}
