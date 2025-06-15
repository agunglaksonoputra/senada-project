import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senada/models/users/profile_model.dart';

class UserService {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Profile> fetchProfile(String uid) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$uid'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Profile.fromMap(data);
    } else {
      throw Exception('Gagal mengambil profil');
    }
  }

  Future<Profile> getUserById(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        return Profile.fromMap(data);
      } else {
        throw Exception('Profil pengguna tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mengambil profil: $e');
    }
  }
}
