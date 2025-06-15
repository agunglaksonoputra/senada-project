import 'package:intl/intl.dart';

class Ticket {
  final String id;
  final String eventId;
  final String name;
  final String sessionStartTime;
  final String sessionEndTime;
  final DateTime sessionStartDate;
  final DateTime sessionEndDate;
  final int quota;
  final bool isActive;
  final bool isSold;
  final List<String> subcategoryIds;

  Ticket({
    required this.id,
    required this.eventId,
    required this.name,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.sessionStartDate,
    required this.sessionEndDate,
    required this.quota,
    required this.isActive,
    required this.isSold,
    required this.subcategoryIds,
  });

  String get formattedStartDate =>
      DateFormat('d MMMM yyyy', 'id_ID').format(sessionStartDate);

  String get formattedEndDate =>
      DateFormat('d MMMM yyyy', 'id_ID').format(sessionEndDate);

  Ticket.order({
    required this.id,
    required this.eventId,
    this.name = '',
    this.sessionStartTime = '',
    this.sessionEndTime = '',
    DateTime? sessionStartDate,
    DateTime? sessionEndDate,
    this.quota = 0,
    this.isActive = false,
    this.isSold = false,
    List<String>? subcategoryIds,
  })  : sessionStartDate = sessionStartDate ?? DateTime.now(),
        sessionEndDate = sessionEndDate ?? DateTime.now(),
        subcategoryIds = subcategoryIds ?? [];

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'] ?? '',
      eventId: map['event_id'] ?? '',
      name: map['name'] ?? '',
      sessionStartTime: map['session_start_time'] ?? '',
      sessionEndTime: map['session_end_time'] ?? '',
      sessionStartDate: map['session_start_date'] != null
          ? DateTime.parse(map['session_start_date'])
          : DateTime.now(),
      sessionEndDate: map['session_end_date'] != null
          ? DateTime.parse(map['session_end_date'])
          : DateTime.now(),
      quota: map['quota'] ?? 0,
      isActive: map['is_active'] ?? false,
      isSold: map['is_sold'] ?? false,
      subcategoryIds: List<String>.from(map['category'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'name': name,
      'session_start_time': sessionStartTime,
      'session_end_time': sessionEndTime,
      'session_start_date': sessionStartDate.toIso8601String(),
      'session_end_date': sessionEndDate.toIso8601String(),
      'quota': quota,
      'is_active': isActive,
      'is_sold': isSold,
      'category': subcategoryIds,
    };
  }
}