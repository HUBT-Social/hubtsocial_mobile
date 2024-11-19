part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.usernameOrEmail,
    required this.password,
  });

  final String usernameOrEmail;
  final String password;

  @override
  List<String> get props => [usernameOrEmail, password];
}

class TwoFactorEvent extends AuthEvent {
  const TwoFactorEvent({
    required this.postcode,
  });

  final String postcode;

  @override
  List<String> get props => [postcode];
}

class VerifyEmailEvent extends AuthEvent {
  const VerifyEmailEvent({
    required this.postcode,
  });

  final String postcode;

  @override
  List<String> get props => [postcode];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<String> get props => [userName, email, password, confirmPassword];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();

  @override
  List<String> get props => [];
}