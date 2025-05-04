import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/events/event_model.dart';

class EventService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<List<Event>> getTopEvent() async {
    final response = await http.get(Uri.parse('$baseUrl/events/top5'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data as List)
          .map((item) => Event.fromMap(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  Future<List<Event>> getByCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/events/$id'));

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