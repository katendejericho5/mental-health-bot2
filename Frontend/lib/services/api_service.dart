import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.43.219:5000'; // Update with your Flask server URL

  Future<String> getChatbotResponse(String message, String threadId) async {
    final url = Uri.parse('$_baseUrl/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message, 'thread_id': threadId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['response'] ?? 'No response';
    } else {
      throw Exception('Failed to get response from API');
    }
  }

  Future<String> createThread() async {
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