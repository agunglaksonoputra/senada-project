import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/ticket/ticket_model.dart';

class TicketService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Ticket>> getTicketEvent(int eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/tickets/$eventId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<Ticket> tickets = (data as List)
          .map((item) => Ticket.fromMap(item))
          .toList();
      tickets = tickets.where((ticket) {
        return ticket.sessionStartDate.isAfter(DateTime.now().subtract(Duration(days: 1)));
      }).toList();

      tickets.sort((a, b) => a.sessionStartDate.compareTo(b.sessionStartDate));

      return tickets;
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}