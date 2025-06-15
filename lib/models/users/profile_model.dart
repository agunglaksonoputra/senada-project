class Profile {
  final String uid;
  final String email;
  final String fullName;
  final String? phoneNumber;

  Profile({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }

  // Membuat Profile dari Map
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      uid: map['uid'] ?? '', // Menangani null dengan nilai default
      email: map['email'] ?? '', // Menangani null dengan nilai default
      fullName: map['fullName'] ?? '', // Menangani null dengan nilai default
      phoneNumber: map['phone_number'], // phoneNumber bisa null
    );
  }
}