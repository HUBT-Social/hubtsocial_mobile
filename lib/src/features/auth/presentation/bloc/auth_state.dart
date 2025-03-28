part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends AuthState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

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

class VerifySignUp extends AuthState {
  const VerifySignUp();
}

class VerifyTwoFactor extends AuthState {
  const VerifyTwoFactor(this.maskEmail);

  final String maskEmail;

  @override
  List<String> get props => [maskEmail];
}

class VerifyTwoFactorSuccess extends AuthState {
  const VerifyTwoFactorSuccess();
}

class VerifyForgotPassword extends AuthState {
  const VerifyForgotPassword(this.maskEmail);

  final String maskEmail;

  @override
  List<String> get props => [maskEmail];
}

class InformationUserSuccess extends AuthState {
  const InformationUserSuccess();
}

class VerifyForgotPasswordSuccess extends AuthState {
  const VerifyForgotPasswordSuccess();
}

class SignedIn extends AuthState {
  const SignedIn();
}

class SignUpSuccess extends AuthState {
  const SignUpSuccess();
}

class SetNewPasswordSuccess extends AuthState {
  const SetNewPasswordSuccess();
}

class VerifyEmail extends AuthState {
  const VerifyEmail();
}

class VerifyEmailSuccess extends AuthState {
  const VerifyEmailSuccess();
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
