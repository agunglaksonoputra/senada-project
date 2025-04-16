import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2A55D),
        title: const Text(
          'Daftar SENADA',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Lengkap
            _buildLabel('Nama Lengkap', 'Masukkan nama lengkap dengan benar'),
            _buildInputField(
              icon: Icons.abc,
              hintText: 'Masukkan nama lengkap',
            ),

            const SizedBox(height: 20),

            // No Handphone
            _buildLabel('No Handphone', 'Masukkan no handphone yang aktif'),
            _buildInputField(
              icon: Icons.phone,
              hintText: 'Masukkan no handphone',
            ),

            const SizedBox(height: 20),

            // Email
            _buildLabel('Email', 'Masukkan alamat email yang terdaftar'),
            _buildInputField(icon: Icons.email, hintText: 'Masukkan email'),

            const SizedBox(height: 20),

            // Password
            _buildLabel('Password', 'Masukkan password yang sesuai'),
            _buildInputField(
              icon: Icons.password,
              hintText: 'Masukkan password',
              isPassword: true,
            ),

            const SizedBox(height: 20),

            // Konfirmasi Password
            _buildLabel('Masukkan Kembali Password', ''),
            _buildInputField(
              icon: Icons.password,
              hintText: 'Masukkan kembali password',
              isPassword: true,
            ),

            const SizedBox(height: 30),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3663),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Proses pendaftaran
                },
                child: const Text(
                  'Kirim',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SENADA',
              style: TextStyle(
                color: Color(0xFFB2A55D),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Version Beta',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
