import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/events/event_model.dart';

class EventService {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvent() async {
    try {
      print('🔄 Mengambil data event dari Firebase...');

      QuerySnapshot snapshot =
      await firestore.collection('events').get();

      print('✅ Jumlah dokumen yang ditemukan: ${snapshot.docs.length}');

      // Ambil doc.data dan inject doc.id ke dalam map sebelum dikirim ke Event.fromMap
      List<Event> events = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        print('📄 Dokumen: ${doc.id}, Data: $data'); // Tambahan log per dokumen
        return Event.fromMap(data);
      }).toList();

      print('✅ Data event berhasil diproses: $events');

      return events;
    } catch (e) {
      print('❌ Gagal mengambil event: $e');
      return [];
    }
  }

  Future<List<Event>> getEventByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('events')
          .where('category', arrayContains: categoryId)
          .get();

      print('Jumlah event dengan kategori "$categoryId": ${snapshot.docs.length}');

      List<Event> events = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Event.fromMap(data);
      }).toList();

      return events;
    } catch (e) {
      print('❌ Gagal mengambil event dengan category "$categoryId": $e');
      return [];
    }
  }

  Future<Event?> getEventById(String id) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection('events')
          .doc(id)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // inject ID
        return Event.fromMap(data);
      } else {
        print('❌ Event dengan ID $id tidak ditemukan.');
        return null;
      }
    } catch (e) {
      print('❌ Gagal mengambil event dengan ID $id: $e');
      return null;
    }
  }



  Future<List<Event>> getTopEvent() async {
    final response = await http.get(Uri.parse('$baseUrl/events/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((item) => Event.fromMap(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  Future<Event> getById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/events/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Event.fromMap(data);
    } else {
      throw Exception('Gagal mengambil event');
    }
  }

  Future<List<Event>> getByCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/events/category/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((item) => Event.fromMap(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

}