import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;
  final String name;
  final String creatorId;
  final List<String> memberIds;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.creatorId,
    required this.memberIds,
    required this.createdAt,
  });

  factory Group.fromMap(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      creatorId: data['creator_id'],
      memberIds: List<String>.from(data['member_ids']),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creator_id': creatorId,
      'member_ids': memberIds,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}