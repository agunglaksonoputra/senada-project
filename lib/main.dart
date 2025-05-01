import 'package:flutter/material.dart';
import 'package:senada/screens/DetailPage/DetailPage.dart';
import 'package:senada/screens/HomePage/homepage_screen.dart';
import 'package:senada/screens/auth/Login.dart';
import 'package:senada/screens/auth/Register.dart';
import 'package:senada/screens/auth/resetpassword.dart';
import 'package:senada/screens/menuPage/menuPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senada App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      initialRoute: '/', // rute awal aplikasi
      routes: {
        '/': (context) => const HomePage(),
        '/Login': (context) => const Login(),
        '/Register': (context) => Register(),
        '/ResetPassword': (context) => const ResetPassword(),
        '/MenuPage': (context) => CulturalShowPage(),
        '/DetailPage': (context) => MyApp(),


        // Tambahkan rute lainnya di sini jika perlu
      },
    );
  }
}
