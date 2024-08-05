class Therapist {
  final String id;
  final String name;
  final String city;
  final String hospital;
  final List<String> availability;

  Therapist({
    required this.id,
    required this.name,
    required this.city,
    required this.hospital,
    required this.availability,
  });

  factory Therapist.fromFirestore(Map<String, dynamic> firestoreData) {
    return Therapist(
      id: firestoreData['id'] ?? '',
      name: firestoreData['name'] ?? '',
      city: firestoreData['city'] ?? '',
      hospital: firestoreData['hospital'] ?? '',
      availability: List<String>.from(firestoreData['availability'] ?? []),
    );
  }
}
