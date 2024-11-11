part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.phoneNumber,
    required this.password,
  });

  final String phoneNumber;
  final String password;

  @override
  List<String> get props => [phoneNumber, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.phoneNumber,
    required this.password,
    required this.name,
    required this.token,
  });

  final String phoneNumber;
  final String password;
  final String name;
  final String token;

  @override
  List<String> get props => [phoneNumber, password, name, token];
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent(this.phoneNumber);

  final String phoneNumber;

  @override
  List<String> get props => [phoneNumber];
}

class VerifyPhoneNumberEvent extends AuthEvent {
  const VerifyPhoneNumberEvent({required this.phoneNumber});

  final String phoneNumber;

  @override
  List<String> get props => [phoneNumber];
}

class SentOTPVerificationEvent extends AuthEvent {
  const SentOTPVerificationEvent(
      {required this.phoneNumber, required this.otp});

  final String phoneNumber;
  final String otp;

  @override
  List<String> get props => [phoneNumber, otp];
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent({
    required this.newPassword,
    required this.token,
  });

  final String newPassword;
  final String token;

  @override
  List<String> get props => [newPassword, token];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();

  @override
  List<String> get props => [];
}
