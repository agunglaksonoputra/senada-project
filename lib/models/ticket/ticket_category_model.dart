class TicketCategory {
  final String id;
  final String eventId;
  final String name;
  final int price;
  final String description;
  final String note;

  TicketCategory({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    required this.description,
    required this.note
  });

  factory TicketCategory.fromMap(Map<String, dynamic> map) {
    return TicketCategory (
      id: map['id'],
      eventId: map['event_id'],
      name: map['name'],
      price: map['price'],
      description: map['description'] ?? '',
      note: map['note'] ?? ''
    );
  }
}