import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'https://backend-750j.onrender.com';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getChatbotResponseTherapist(String message) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    String email = user.email!;
    String threadId = await _getOrCreateThreadId('therapist');
    return _getChatbotResponse(message, threadId, '/chat/therapist',
        email: email);
  }

  Future<String> getChatbotResponseCompanion(String message) async {
    String threadId = await _getOrCreateThreadId('companion');
    return _getChatbotResponse(message, threadId, '/chat/companion');
  }

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

  Future<void> renewRateLimit() async {
    final url = Uri.parse('$_baseUrl/renew-rate-limit');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to renew rate limit');
    }
  }

  Future<String> _getOrCreateThreadId(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    String? threadId = prefs.getString('thread_id_$mode');

    if (threadId == null) {
      threadId = await _createThread();
      await prefs.setString('thread_id_$mode', threadId);
    }

    return threadId;
  }

  Future<String> _createThread() async {
    final url = Uri.parse('$_baseUrl/thread');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['thread_id'];
    } else {
      throw Exception('Failed to create thread');
    }
  }
}
