import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/users/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP
  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Buat akun di Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Kirim data ke API
      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          fullName: fullName,
          phoneNumber: phoneNumber,
        );

        try {
          final response = await http.post(
            Uri.parse('http://10.0.2.2:3000/api/user/add-user'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(userModel.toJson()),
          );

          if (response.statusCode != 201) {
            return 'Gagal kirim data user ke API: ${response.statusCode}';
          }
        } catch (apiError) {
          return "Error saat mengirim ke API: $apiError";
        }
      } else {
        return 'User tidak ditemukan';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // SIGN IN
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // GET CURRENT USER
  User? get currentUser => _auth.currentUser;

  // RESET PASSWORD
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
