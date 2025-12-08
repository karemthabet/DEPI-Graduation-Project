import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:get_storage/get_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final supabase = Supabase.instance.client;

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        emit(AuthFailure('Invalid credentials'));
        return;
      }

      if (user.emailConfirmedAt == null) {
        emit(AuthFailure('Please verify your email address before signing in'));
        return;
      }

      // Clear guest status on successful login
      GetStorage().write('isGuest', false);

      emit(AuthSuccess());
    } on AuthException catch (e) {
      _handleAuthException(e);
    } on SocketException {
      emit(AuthFailure('No internet connection. Please check your network.'));
    } catch (e) {
      _handleGenericException(e);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
        emailRedirectTo: 'com.example.depi_graduation_project://login-callback',
      );

      final user = response.user;

      if (user != null) {
        emit(
          AuthEmailVerificationRequired(
            'A confirmation email has been sent to your email address. Please check your inbox.',
            email,
          ),
        );
      } else {
        emit(AuthFailure('Failed to create account'));
      }
    } on AuthException catch (e) {
      _handleAuthException(e);
    } on SocketException {
      emit(AuthFailure('No internet connection. Please check your network.'));
    } catch (e) {
      _handleGenericException(e);
    }
  }

  Future<void> resendVerificationEmail({required String email}) async {
    emit(AuthLoading());
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: 'com.example.depi_graduation_project://login-callback',
      );

      emit(
        AuthEmailVerificationRequired(
          'A confirmation email has been sent to your email address. Please check your inbox.',
          email,
        ),
      );
    } on AuthException catch (e) {
      _handleAuthException(e);
    } catch (e) {
      emit(AuthFailure('حدث خطأ أثناء إعادة الإرسال: $e'));
    }
  }

  void _handleAuthException(AuthException e) {
    if (e.message.toLowerCase().contains('network') ||
        e.message.toLowerCase().contains('connection') ||
        e.message.toLowerCase().contains('socket')) {
      emit(AuthFailure('No internet connection. Please check your network.'));
    } else if (e.message.contains('User already registered')) {
      emit(
        AuthFailure(
          'This email is already registered. Please login instead.',
        ),
      );
    } else if (e.message.contains('Invalid login credentials')) {
      emit(AuthFailure('Invalid email or password.'));
    } else {
      emit(AuthFailure(e.message));
    }
  }

  void _handleGenericException(Object e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('Network is unreachable')) {
      emit(AuthFailure('No internet connection. Please check your network.'));
    } else {
      emit(AuthFailure('Unexpected error: $e'));
    }
  }
}
