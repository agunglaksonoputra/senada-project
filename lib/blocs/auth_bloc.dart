import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:senada/models/users/profile_model.dart';
import 'package:senada/services/Auth/user_service.dart';


// EVENTS
abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}


// STATES
abstract class AppAuthState {}

class AuthInitial extends AppAuthState {}

class Authenticated extends AppAuthState {
  final User user;
  final Profile profile;
  final String email;

  Authenticated(this.user, this.profile, this.email);
}

class Unauthenticated extends AppAuthState {}

class AuthError extends AppAuthState {
  final String message;
  AuthError(this.message);
}


// BLOC
class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
  final FirebaseAuth firebaseAuth;
  final UserService userService;

  AuthBloc({
    required this.firebaseAuth,
    required this.userService,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        try {
          final uid = user.uid;
          final profile = await userService.fetchProfile(uid);

          // Pastikan profile tidak null dan lengkap
          if (profile == null || profile.fullName == null) {
            emit(AuthError('Profil pengguna tidak lengkap.'));
            return;
          }

          final userEmail = user.email;

          if (userEmail != null && userEmail.isNotEmpty) {
            emit(Authenticated(user, profile, userEmail));
          } else {
            emit(AuthError('Email pengguna tidak valid.'));
          }
        } catch (e) {
          emit(AuthError('Gagal memuat data profil: $e'));
        }
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthInitial());
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        add(CheckAuthStatus());
      } catch (e) {
        emit(AuthError('Login gagal: ${e.toString()}'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await firebaseAuth.signOut();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthError("Gagal logout: ${e.toString()}"));
      }
    });
  }
}
