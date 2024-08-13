import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/models/history_model.dart';
import 'package:WellCareBot/models/therapist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMessage(ChatMessage message) {
    return _db
        .collection('threads')
        .doc(message.threadId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  Stream<List<ChatMessage>> getMessages(String threadId) {
    return _db
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> deleteMessage(String threadId, String messageId) {
    return _db
        .collection('threads')
        .doc(threadId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User user = _auth.currentUser!;
    DocumentSnapshot userDoc =
        await _db.collection('users').doc(user.uid).get();

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
    return _db
        .collection('therapists')
        .doc(therapistId)
        .snapshots()
        .map((snapshot) => Therapist.fromFirestore(snapshot.data()!));
  }
}
