import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senada/models/users/profile_model.dart';

class UserService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<Profile> fetchProfile(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$uid'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Profile.fromMap(data);
    } else {
      throw Exception('Gagal mengambil profil');
    }
  }
}
