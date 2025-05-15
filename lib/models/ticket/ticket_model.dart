class Ticket {
  final int id;
  final int eventId;
  final String name;
  final String sessionStartTime;
  final String sessionEndTime;
  final DateTime sessionStartDate;
  final DateTime sessionEndDate;
  final bool isActive;
  final bool isSold;

  Ticket({
    required this.id,
    required this.eventId,
    required this.name,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.sessionStartDate,
    required this.sessionEndDate,
    required this.isActive,
    required this.isSold,
  });

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      eventId: map['event_id'],
      name: map['name'],
      sessionStartTime: map['session_start_time'],
      sessionEndTime: map['session_end_time'],
      sessionStartDate: DateTime.parse(map['session_start_date']),
      sessionEndDate: DateTime.parse(map['session_end_date']),
      isActive: map['is_active'],
      isSold: map['is_sold'],
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
      'is_active': isActive,
      'is_sold': isSold,
    };
  }
}