import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senada/services/Auth/auth_service.dart';
import 'package:senada/widgets/input_field.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Pengecekan password
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      String? errorMessage = await authService.signUp(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
        toolbarHeight: 80,
        title: const Text(
          'Daftar SENADA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputContainer(
              label: 'Nama Lengkap',
              description: 'Masukkan nama lengkap dengan benar',
              inputField: InputField(
                icon: FontAwesomeIcons.font,
                hintText: 'Masukkan nama lengkap',
                controller: _fullNameController,
              ),
            ),
            const SizedBox(height: 20),
            buildInputContainer(
              label: 'No Handphone',
              description: 'Masukkan no handphone yang aktif',
              inputField: InputField(
                icon: FontAwesomeIcons.phone,
                hintText: 'Masukkan no handphone',
                controller: _phoneController,
              ),
            ),
            const SizedBox(height: 20),
            buildInputContainer(
              label: 'Email',
              description: 'Masukkan alamat email yang terdaftar',
              inputField: InputField(
                icon: FontAwesomeIcons.solidEnvelope,
                hintText: 'Masukkan email',
                controller: _emailController,
              ),
            ),
            const SizedBox(height: 20),
            buildInputContainer(
              label: 'Password',
              description: 'Masukkan password yang sesuai',
              inputField: InputField(
                icon: Icons.password,
                hintText: 'Masukkan password',
                controller: _passwordController,
                isPasswordField: true,
              ),
            ),
            const SizedBox(height: 20),
            buildInputContainer(
              label: 'Masukkan Kembali Password',
              inputField: InputField(
                icon: Icons.password,
                hintText: 'Masukkan kembali password',
                controller: _confirmPasswordController,
                isPasswordField: true,
              ),
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
}
