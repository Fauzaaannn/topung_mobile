part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

class RegisterSubmitted extends AuthEvent {
  RegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.usia,
    required this.jenisKelamin,
  });

  final String username;
  final String email;
  final String password;
  final int usia;
  final String jenisKelamin;
}

class LogoutRequested extends AuthEvent {}