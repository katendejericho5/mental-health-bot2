import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.43.219:5000'; // Update with your Flask server URL
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _threadId = 'your_predefined_thread_id'; // Set your predefined thread_id here

  Future<String> getChatbotResponseTherapist(String message) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    String email = user.email!;
    return _getChatbotResponse(message, _threadId, '/chat/therapist', email: email);
  }

  Future<String> getChatbotResponseCompanion(String message) async {
    return _getChatbotResponse(message, _threadId, '/chat/companion');
  }

  Future<String> _getChatbotResponse(String message, String threadId, String endpoint, {String? email}) async {
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
}
