import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/models/chat_model.dart';
import 'package:WellCareBot/models/group_model.dart';
import 'package:WellCareBot/models/history_model.dart';
import 'package:WellCareBot/models/therapist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser!.uid;

  Future<void> addMessage(ChatMessageHistory message) {
    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('threads')
        .doc(message.threadId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  Stream<List<ChatMessageHistory>> getMessages(String threadId) {
    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageHistory.fromMap(doc.data()))
            .toList());
  }

  Future<void> deleteMessage(String threadId, String messageId) {
    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    DocumentSnapshot userDoc =
        await _db.collection('users').doc(currentUserId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromFirestore(doc.data()))
            .toList());
  }

  Stream<Therapist> getTherapistDetails(String therapistId) {
    print(therapistId);
    return _db
        .collection('therapists')
        .doc(therapistId)
        .snapshots()
        .map((snapshot) => Therapist.fromFirestore(snapshot.data()!));
  }

  // Create a new group
  Future<void> createGroup(Group group) {
    return _db.collection('groups').doc(group.id).set(group.toMap());
  }

  // Get all groups for a user
  Stream<List<Group>> getUserGroups(String userId) {
    return _db
        .collection('groups')
        .where('member_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Group.fromMap(doc.data())).toList());
  }

  // Add a member to a group
  Future<void> addGroupMember(String groupId, String userId) {
    return _db.collection('groups').doc(groupId).update({
      'member_ids': FieldValue.arrayUnion([userId])
    });
  }

  // Remove a member from a group
  Future<void> removeGroupMember(String groupId, String userId) {
    return _db.collection('groups').doc(groupId).update({
      'member_ids': FieldValue.arrayRemove([userId])
    });
  }

  // Get group messages
  Stream<List<ChatMessage>> getGroupMessages(String groupId) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  // Add a message to a group
  Future<void> addGroupMessage(String groupId, ChatMessage message) {
    return _db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(message.toMap());
  }

  Future<bool> deleteGroupMessage(String groupId, String messageId) async {
    print("Attempting to delete message: $messageId from group: $groupId");
    try {
      // Delete the message document
      await _db
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .delete();

      // Update the lastMessage field if the deleted message was the last one
      final querySnapshot = await _db
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastMessage = querySnapshot.docs.first;
        await _db.collection('groups').doc(groupId).update({
          'lastMessage': {
            'content': lastMessage['content'],
            'senderId': lastMessage['senderId'],
            'timestamp': lastMessage['createdAt'],
          }
        });
      } else {
        // If there are no messages left, clear the lastMessage field
        await _db.collection('groups').doc(groupId).update({
          'lastMessage': FieldValue.delete(),
        });
      }

      print("Message deleted successfully");
      return true;
    } catch (e) {
      print("Error deleting message: $e");
      return false;
    }
  }
}
