import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final String appVersion = '1.0.0'; // Versi ditulis manual

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tentang SENADA', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB2A55D),
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/tari_kecak.jpg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'SENADA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Solusi Event Nusantara Anda',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi SENADA memudahkan Anda dalam menemukan dan melakukan reservasi berbagai event budaya, seni, dan hiburan di seluruh Indonesia.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Versi Aplikasi: ',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text(appVersion),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Dikembangkan oleh Tim SENADA',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Untuk pertanyaan atau masukan:\nsupport@senada.id',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey),
            ),
            const Spacer(),
            const Text(
              '© 2025 SENADA. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
