class Event {
  final int id;
  final String title;
  final String description;
  final String phoneNumber;
  final String location;
  final String experience;
  final String thumbnail;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.location,
    required this.experience,
    required this.thumbnail,
    required this.createdAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      phoneNumber: map['phone_number'],
      location: map['location'],
      experience: map['experience'],
      thumbnail: map['thumbnail'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'phone_number': phoneNumber,
      'location': location,
      'experience': experience,
      'thumbnail': thumbnail,
      'created_at': createdAt.toIso8601String(),
    };
  }
}