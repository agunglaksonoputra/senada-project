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

class AppAuthLoading extends AppAuthState {}

class Authenticated extends AppAuthState {
  final User user;
  final Profile profile;

  Authenticated(this.user, this.profile);
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
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AppAuthState> emit) async {
    emit(AppAuthLoading());
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        final uid = user.uid;
        final profile = await userService.getUserById(uid);
        if (profile == null) {
          emit(AuthError('Profil pengguna tidak ditemukan.'));
          return;
        }
        emit(Authenticated(user, profile));
      } catch (e) {
        emit(AuthError('Gagal memuat data profil: $e'));
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AppAuthState> emit) async {
    emit(AppAuthLoading());
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      add(CheckAuthStatus());
    } catch (e) {
      emit(AuthError('Login gagal: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AppAuthState> emit) async {
    try {
      await firebaseAuth.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Gagal logout: ${e.toString()}"));
    }
  }
}