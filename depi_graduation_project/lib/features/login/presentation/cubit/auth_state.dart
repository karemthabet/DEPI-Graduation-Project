import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class AuthEmailVerificationRequired extends AuthState {
  final String message;
  final String email; 
  
  AuthEmailVerificationRequired(this.message, this.email);
  
  @override
  List<Object> get props => [message, email];
}