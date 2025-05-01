import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senada/models/users/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

abstract class AppAuthState {}  // Renamed from AuthState

class AuthInitial extends AppAuthState {}

class Authenticated extends AppAuthState {
  final User user;
  final Profile profile;
  final String email;
  Authenticated(this.user, this.profile, this.email);
}

class Unauthenticated extends AppAuthState {}

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {  // Updated to AppAuthState
  final SupabaseClient supabase;

  AuthBloc({required this.supabase}) : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final user = supabase.auth.currentUser;

      if (user != null) {
        final profileResponse = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        final email = user.email!;
        final profile = Profile.fromMap(profileResponse);
        emit(Authenticated(user, profile, email));
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
