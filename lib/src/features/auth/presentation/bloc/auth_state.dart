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

class VerifyingTwoFactor extends AuthState {
  const VerifyingTwoFactor();
}

class SignedIn extends AuthState {
  const SignedIn(this.response);

  final SignInResponse response;

  @override
  List<Object> get props => [response];
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

class VerifyTwoFactorError extends AuthState {
  const VerifyTwoFactorError(this.message);

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
