import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:senada/models/users/profile_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

      if (user != null) {
        // Simpan data ke Firestore
        try {
          await firestore
              .collection('users')
              .doc(user.uid)
              .set({
            'email': email,
            'fullName': fullName,
            'phoneNumber': phoneNumber,
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          });
        } catch (firestoreError) {
          return "Gagal simpan ke Firestore: $firestoreError";
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
      // Login ke Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Ambil data dari Firestore
      if (user != null) {
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          return 'Data user tidak ditemukan di Firestore';
        }

        // Jika perlu, bisa simpan data ke local storage / provider
        // final data = userDoc.data() as Map<String, dynamic>;
        // print('User data: $data');
      }

      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
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

  Future<User?> checkUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
