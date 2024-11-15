import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';

class SignInResponse extends Equatable {
  const SignInResponse({
    required this.userToken,
    required this.message,
    required this.requiresTwoFactor,
  });

  final UserTokenModel? userToken;
  final String? message;
  final bool? requiresTwoFactor;

  SignInResponse copyWith({
    UserTokenModel? userToken,
    String? message,
    bool? requiresTwoFactor,
  }) {
    return SignInResponse(
      userToken: userToken ?? this.userToken,
      message: message ?? this.message,
      requiresTwoFactor: requiresTwoFactor,
    );
  }

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      userToken: json["userToken"] == null
          ? null
          : UserTokenModel.fromJson(json["userToken"]),
      message: json["message"],
      requiresTwoFactor: json["requiresTwoFactor"],
    );
  }

  @override
  String toString() {
    return "$userToken, $message, $requiresTwoFactor, ";
  }

  @override
  List<Object?> get props => [
        userToken,
        message,
        requiresTwoFactor,
      ];
}
