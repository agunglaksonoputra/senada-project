class Profile {
  final String id;
  final String fullName;

  Profile({required this.id, required this.fullName});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      fullName: map['full_name'],
    );
  }
}
