part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthFailure extends AuthState {
  const AuthFailure();
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}

class Verifying extends AuthState {
  const Verifying();
}

class SignedIn extends AuthState {
  const SignedIn(this.token);

  final UserToken token;

  @override
  List<Object> get props => [token];
}

class SignedUp extends AuthState {
  const SignedUp();
}

class VerifiedPhoneNumber extends AuthState {
  const VerifiedPhoneNumber(this.tempToken);

  final String tempToken;

  @override
  List<Object> get props => [tempToken];
}

class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class VerifyError extends AuthState {
  const VerifyError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class ExpiredToken extends AuthState {
  const ExpiredToken(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class PasswordReset extends AuthState {
  const PasswordReset();
}

class SignedOut extends AuthState {
  const SignedOut();
}
