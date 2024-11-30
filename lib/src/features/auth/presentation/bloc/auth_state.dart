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

class VerifyTwoFactor extends AuthState {
  const VerifyTwoFactor();
}

class VerifyForgotPassword extends AuthState {
  const VerifyForgotPassword();
}

class VerifyForgotPasswordSuccess extends AuthState {
  const VerifyForgotPasswordSuccess();
}

class SignedIn extends AuthState {
  const SignedIn();
}

class VerifyEmail extends AuthState {
  const VerifyEmail();
}

class AuthError extends AuthState {
  const AuthError(this.message);

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

class SignedOut extends AuthState {
  const SignedOut();
}
