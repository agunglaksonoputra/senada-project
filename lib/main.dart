import 'package:flutter/material.dart';
import 'package:senada/screens/HomePage/homepage_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      initialRoute: '/', // rute awal aplikasi
      routes: {
        '/': (context) => const HomePage(),
        // Tambahkan rute lainnya di sini jika perlu
      },
    );
  }
}
