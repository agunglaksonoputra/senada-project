import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:senada/models/events/event_model.dart';
import 'package:senada/models/order/ticket_order_model.dart';
import 'package:senada/models/ticket/ticket_model.dart';

class TicketOrder {
  final String orderId;
  final String userId;
  final String ticketId;
  final Map<String, dynamic> event;
  final List<OrderTicket> tickets;
  final int totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final DateTime createdAt;

  TicketOrder({
    required this.orderId,
    required this.userId,
    required this.ticketId,
    required this.event,
    required this.tickets,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
  });

  String get formattedCreatedAt {
    // Contoh format: Senin, 10 Juni 2025 14:30
    return DateFormat("EEEE, d MMMM yyyy HH:mm", 'id_ID').format(createdAt);
  }

  int get totalQuantity {
    return tickets.fold(0, (sum, ticket) => sum + ticket.quantity);
  }

  factory TicketOrder.fromMap(Map<String, dynamic> map) {
    return TicketOrder(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      ticketId: map['ticketId'] ?? '',
      event: Map<String, dynamic>.from(map['event'] ?? {}),
      tickets: (map['tickets'] as List<dynamic>? ?? [])
          .map((x) => OrderTicket.fromMap(x as Map<String, dynamic>))
          .toList(),
      totalPrice: map['totalPrice'] ?? 0,
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'ticketId': ticketId,
      'event': event,
      'tickets': tickets.map((t) => t.toMap()).toList(),
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
