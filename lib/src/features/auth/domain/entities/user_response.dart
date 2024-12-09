import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';

class UserResponse extends Equatable {
  const UserResponse({
    required this.userToken,
    required this.message,
    required this.maskEmail,
    required this.requiresTwoFactor,
  });

  final UserTokenModel? userToken;
  final String? maskEmail;
  final String? message;
  final bool? requiresTwoFactor;

  UserResponse copyWith({
    UserTokenModel? userToken,
    String? maskEmail,
    String? message,
    bool? requiresTwoFactor,
  }) {
    return UserResponse(
      userToken: userToken ?? this.userToken,
      maskEmail: maskEmail ?? this.maskEmail,
      message: message ?? this.message,
      requiresTwoFactor: requiresTwoFactor,
    );
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userToken: json["userToken"] == null
          ? null
          : UserTokenModel.fromJson(json["userToken"]),
      maskEmail: json["maskEmail"],
      message: json["message"],
      requiresTwoFactor: json["requiresTwoFactor"],
    );
  }

  @override
  String toString() {
    return "$userToken, $maskEmail, $message, $requiresTwoFactor, ";
  }

  @override
  List<Object?> get props => [
        userToken,
        maskEmail,
        message,
        requiresTwoFactor,
      ];
}
