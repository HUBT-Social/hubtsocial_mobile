import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';

class UserResponse extends Equatable {
  const UserResponse({
    required this.userToken,
    required this.message,
    required this.requiresTwoFactor,
  });

  final UserTokenModel? userToken;
  final String? message;
  final bool? requiresTwoFactor;

  UserResponse copyWith({
    UserTokenModel? userToken,
    String? message,
    bool? requiresTwoFactor,
  }) {
    return UserResponse(
      userToken: userToken ?? this.userToken,
      message: message ?? this.message,
      requiresTwoFactor: requiresTwoFactor,
    );
  }

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
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
