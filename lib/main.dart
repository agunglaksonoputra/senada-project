import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senada/screens/DetailPage/DetailPage.dart';
import 'package:senada/screens/home/home_screen.dart';
import 'package:senada/screens/auth/Login.dart';
import 'package:senada/screens/auth/Register.dart';
import 'package:senada/screens/auth/resetpassword.dart';
import 'package:senada/screens/main_screen.dart';
import 'package:senada/screens/menuPage/menuPage.dart';
import 'package:senada/Screens/reservation/reservation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
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
        '/': (context) => MainScreen(),
        '/home': (context) => const HomePage(),
        '/Login': (context) => const Login(),
        '/Register': (context) => Register(),
        '/ResetPassword': (context) => const ResetPassword(),
        '/MenuPage': (context) => CulturalShowPage(),
        '/DetailPage': (context) => MyApp(),
        '/Reservation': (context) => const ReservationPage(eventName: '',),

        // Tambahkan rute lainnya di sini jika perlu
      },
    );
  }
}
