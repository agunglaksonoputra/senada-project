import 'package:flutter/material.dart';
import 'package:senada/services/Auth/auth_service.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService =
      AuthService(); // instance dari AuthService (pastikan kamu sudah punya class-nya)

  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Pengecekan password
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      String? errorMessage = await authService.signUp(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (errorMessage != null) {
        // Registrasi gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal register: $errorMessage')),
        );
      } else {
        // Registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan verifikasi email.'),
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal register: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
            _buildLabel('Nama Lengkap', 'Masukkan nama lengkap dengan benar'),
            _buildInputField(
              icon: Icons.abc,
              hintText: 'Masukkan nama lengkap',
              controller: fullNameController,
            ),
            const SizedBox(height: 20),
            _buildLabel('No Handphone', 'Masukkan no handphone yang aktif'),
            _buildInputField(
              icon: Icons.phone,
              hintText: 'Masukkan no handphone',
              controller: phoneController,
            ),
            const SizedBox(height: 20),
            _buildLabel('Email', 'Masukkan alamat email yang terdaftar'),
            _buildInputField(
              icon: Icons.email,
              hintText: 'Masukkan email',
              controller: emailController,
            ),
            const SizedBox(height: 20),
            _buildLabel('Password', 'Masukkan password yang sesuai'),
            _buildInputField(
              icon: Icons.password,
              hintText: 'Masukkan password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            _buildLabel('Masukkan Kembali Password', ''),
            _buildInputField(
              icon: Icons.password,
              hintText: 'Masukkan kembali password',
              controller: confirmPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 30),
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
                onPressed: isLoading ? null : _handleRegister,
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
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
