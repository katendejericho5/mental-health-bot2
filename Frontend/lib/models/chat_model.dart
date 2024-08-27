import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'],
      senderId: data['sender_id'],
      content: data['content'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'content': content,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}