class ChatMessageHistory {
  final String id;
  final String threadId;
  final String userId;
  final String author;
  final int createdAt;
  final String text;

  ChatMessageHistory({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.author,
    required this.createdAt,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thread_id': threadId,
      'user_id': userId,
      'author': author,
      'created_at': createdAt,
      'text': text,
    };
  }

  static ChatMessageHistory fromMap(Map<String, dynamic> map) {
    return ChatMessageHistory(
      id: map['id'],
      threadId: map['thread_id'],
      userId: map['user_id'],
      author: map['author'],
      createdAt: map['created_at'],
      text: map['text'],
    );
  }
}
