import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/ticket/ticket_category_model.dart';
import 'package:senada/models/ticket/ticket_model.dart';

class TicketService {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Ticket>> getTicketsByEventId(String eventId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('tickets')
          .where('event_id', isEqualTo: eventId)
          .get();

      print('Jumlah tiket ditemukan: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Ticket.fromMap(data);
      }).toList();
    } catch (e) {
      print('❌ Gagal mengambil tiket: $e');
      return [];
    }
  }

  Future<List<TicketCategory>> fetchSubcategories(List<String> ids) async {
    final subcategories = <TicketCategory>[];

    for (String id in ids) {
      if (id.trim().isEmpty) continue;

      try {
        final doc = await firestore.collection('tickets_categories').doc(id).get();
        if (doc.exists) {
          final data = doc.data()!;
          data['id'] = doc.id;

          subcategories.add(TicketCategory.fromMap(data));
        } else {
          print('⚠️ Dokumen kategori tidak ditemukan untuk ID: $id');
        }
      } catch (e) {
        print('❌ Error mengambil kategori tiket dengan ID $id: $e');
      }
    }

    return subcategories;
  }

  Future<List<Ticket>?> getTicketEvent(String eventId) async {
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
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}