import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:senada/firebase_options.dart';
import 'package:senada/screens/about.dart';
import 'package:senada/screens/home/home_screen.dart';
import 'package:senada/screens/auth/Login.dart';
import 'package:senada/screens/auth/Register.dart';
import 'package:senada/screens/auth/resetpassword.dart';
import 'package:senada/screens/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await dotenv.load();
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
        '/about': (context) => const AboutPage(),

        // Tambahkan rute lainnya di sini jika perlu
      },
    );
  }
}
