import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

abstract class AppAuthState {}  // Renamed from AuthState

class AuthInitial extends AppAuthState {}

class Authenticated extends AppAuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AppAuthState {}

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {  // Updated to AppAuthState
  final SupabaseClient supabase;

  AuthBloc({required this.supabase}) : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) {
      final user = supabase.auth.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await supabase.auth.signOut();
        emit(Unauthenticated());
      } catch (e) {
        print("Error signing out: $e");
      }
    });
  }
}
