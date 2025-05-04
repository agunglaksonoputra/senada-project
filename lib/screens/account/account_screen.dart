import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senada/blocs/auth_bloc.dart';
import 'package:senada/services/Auth/user_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        firebaseAuth: FirebaseAuth.instance,
        userService: UserService(),
      )..add(CheckAuthStatus()),
      child: const _AccountPageBody(),
    );
  }
}

class _AccountPageBody extends StatelessWidget {
  const _AccountPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2A55D),
        toolbarHeight: 60,
        title: const Text(
          'SENADA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<AuthBloc, AppAuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  final profile = state.profile;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=3',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            profile.email,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state is Unauthenticated) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Jelajahi Kesenian Daerah',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Silahkan Login untuk mengakses fitur',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/Login');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF2A3663),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 12.0,
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else if (state is AuthError) {
                  return Text("Terjadi kesalahan: ${state.message}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthBloc, AppAuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return _buildOptionCard('Detail Akun', Icons.person);
                    }
                    return const SizedBox();
                  },
                ),
                _buildOptionCard('Tentang SENADA', Icons.info_outline),
              ],
            ),
          ),
          BlocBuilder<AuthBloc, AppAuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Tambahkan navigasi sesuai kebutuhan
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFF748D7B),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
