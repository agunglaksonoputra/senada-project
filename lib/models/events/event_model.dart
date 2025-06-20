import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String phoneNumber;
  final String location;
  final String? experience;
  final String thumbnail;
  final DateTime createdAt;
  final DateTime updateAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.phoneNumber,
    required this.location,
    required this.experience,
    required this.thumbnail,
    required this.createdAt,
    required this.updateAt
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is String) {
        return DateTime.parse(timestamp);
      } else {
        // fallback jika null atau tipe lain
        return DateTime.now();
      }
    }

    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      phoneNumber: map['phone_number'],
      location: map['location'],
      experience: map['experience'] ?? '',
      thumbnail: map['thumbnail'],
      createdAt: parseTimestamp(map['createdAt']),
      updateAt: parseTimestamp(map['updatedAt']),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updateAt.toIso8601String(),
    };
  }
}
