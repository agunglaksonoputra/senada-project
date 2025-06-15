import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/models/ticket/ticket_model.dart';

class OrderTicket {
  final String id;
  final String event;
  final String name;
  final String sessionStartTime;
  final DateTime sessionStartDate;
  final int quantity;

  OrderTicket({
    required this.id,
    required this.event,
    required this.name,
    required this.sessionStartTime,
    required this.sessionStartDate,
    required this.quantity,
  });

  // Bisa dari Ticket juga:
  factory OrderTicket.fromMap(Map<String, dynamic> map) {
    return OrderTicket(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      sessionStartDate: map['session_start_date'] is Timestamp
          ? (map['session_start_date'] as Timestamp).toDate()
          : DateTime.parse(map['session_start_date']),
      sessionStartTime: map['session_start_time'] ?? '',
      event: map['event'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event': event,
      'name': name,
      'session_start_time': sessionStartTime,
      'session_start_date': sessionStartDate.toIso8601String(),
      'quantity': quantity,
    };
  }
}
