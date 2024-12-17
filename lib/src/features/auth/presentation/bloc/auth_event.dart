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

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({
    required this.usernameOrEmail,
  });

  final String usernameOrEmail;

  @override
  List<String> get props => [usernameOrEmail];
}

// class UpdateEmailEvent extends AuthEvent {
//   final String email;

//   UpdateEmailEvent(this.email);

//   @override
//   List<Object?> get props => [email];
// }

class VerifyEmailEvent extends AuthEvent {
  const VerifyEmailEvent({
    required this.postcode,
  });

  final String postcode;

  @override
  List<String> get props => [postcode];
}

class SetNewPasswordEvent extends AuthEvent {
  const SetNewPasswordEvent({
    required this.newPassword,
    required this.confirmNewPassword,
  });
  final String newPassword;
  final String confirmNewPassword;

  @override
  List<Object?> get props => [newPassword, confirmNewPassword];
}

class VerifyPasswordEvent extends AuthEvent {
  const VerifyPasswordEvent({
    required this.postcode,
  });
  final String postcode;

  @override
  List<Object?> get props => [postcode];
}

class SignUpInformationEvent extends AuthEvent {
  const SignUpInformationEvent({
    required this.firstName,
    required this.lastName,
    required this.birthOfDate,
    required this.gender,
    required this.phoneNumber,
  });
  final String firstName;
  final String lastName;
  final DateTime birthOfDate;
  final Gender gender;
  final String phoneNumber;
  @override
  List<String> get props => [
        firstName,
        lastName,
        birthOfDate.toIso8601String(),
        gender.toString(),
        phoneNumber
      ];
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
