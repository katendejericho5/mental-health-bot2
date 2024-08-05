class Booking {
  final String id;
  final String appointmentDate;
  final int day;
  final int month;
  final String notes;
  final String status;
  final String therapistId;
  final String time;
  final String userEmail;
  final String userId;
  final String userName;
  final String userPhone;
  final String userProfilePictureUrl;
  final int year;

  Booking({
    required this.id,
    required this.appointmentDate,
    required this.day,
    required this.month,
    required this.notes,
    required this.status,
    required this.therapistId,
    required this.time,
    required this.userEmail,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userProfilePictureUrl,
    required this.year,
  });

  factory Booking.fromFirestore(Map<String, dynamic> firestoreData) {
    return Booking(
      id: firestoreData['id'] ?? '',
      appointmentDate: firestoreData['appointment_date'] ?? '',
      day: firestoreData['day'] ?? 0,
      month: firestoreData['month'] ?? 0,
      notes: firestoreData['notes'] ?? '',
      status: firestoreData['status'] ?? '',
      therapistId: firestoreData['therapist_id'] ?? '',
      time: firestoreData['time'] ?? '',
      userEmail: firestoreData['user_email'] ?? '',
      userId: firestoreData['user_id'] ?? '',
      userName: firestoreData['user_name'] ?? '',
      userPhone: firestoreData['user_phone'] ?? '',
      userProfilePictureUrl: firestoreData['user_profile_picture_url'] ?? '',
      year: firestoreData['year'] ?? 0,
    );
  }
}