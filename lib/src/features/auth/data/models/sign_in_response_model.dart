import 'dart:convert';

import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_response.dart';

class SignInResponseModel extends UserResponse {
  const SignInResponseModel({
    required super.userToken,
    required super.maskEmail,
    required super.message,
    required super.requiresTwoFactor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userToken': userToken,
      'maskEmail': maskEmail,
      'message': message,
      'requiresTwoFactor': requiresTwoFactor,
    };
  }

  factory SignInResponseModel.fromMap(Map<String, dynamic> json) {
    return SignInResponseModel(
      userToken: json["userToken"] == null
          ? null
          : UserTokenModel.fromMap(json["userToken"]),
      maskEmail: json["maskEmail"],
      message: json["message"],
      requiresTwoFactor: json["requiresTwoFactor"],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignInResponseModel.fromJson(String source) =>
      SignInResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
