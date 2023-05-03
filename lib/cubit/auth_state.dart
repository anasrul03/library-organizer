import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { initial, logging, success, error }

class AuthState extends Equatable {
  final User? user;
  final bool loading;
  final String email;
  final String password;
  final AuthStatus status;

  const AuthState(
      {required this.email,
      required this.password,
      required this.status,
      this.user,
      this.loading = false});
  factory AuthState.initial() {
    return AuthState(email: "", password: "", status: AuthStatus.initial);
  }

  AuthState copyWith(
      {User? user,
      bool? loading,
      String? email,
      String? password,
      AuthStatus? status}) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  bool get isValid => email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object?> get props => [user, loading, email, password, status];
}

// class AuthFailed extends AuthState {}