import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senada/services/Auth/auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:senada/widgets/input_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final authService = AuthService();
  bool isLoading = false;

  void _handleResetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email yang valid')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authService.resetPassword(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim ke email'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal reset password: $e')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2A55D),
        toolbarHeight: 60,
        title: const Text(
          'Reset Password',
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
              label: 'Email',
              description: 'Masukkan alamat email yang terdaftar',
              inputField: InputField(
                  icon: FontAwesomeIcons.solidEnvelope,
                  hintText: 'Masukkan email',
                  controller: _emailController,
              ),
            ),
            const SizedBox(height: 20),
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
                onPressed: isLoading ? null : _handleResetPassword,
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

  Widget _buildInputField({
    required IconData icon,
    required String hintText,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}
