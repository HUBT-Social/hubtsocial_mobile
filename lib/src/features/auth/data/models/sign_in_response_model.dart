import 'dart:convert';

import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/sign_in_response.dart';

class SignInResponseModel extends SignInResponse {
  const SignInResponseModel({
    required super.userToken,
    required super.message,
    required super.requiresTwoFactor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userToken': userToken,
      'message': message,
      'requiresTwoFactor': requiresTwoFactor,
    };
  }

  factory SignInResponseModel.fromMap(Map<String, dynamic> json) {
    return SignInResponseModel(
      userToken: json["userToken"] == null
          ? null
          : UserTokenModel.fromMap(json["userToken"]),
      message: json["message"],
      requiresTwoFactor: json["requiresTwoFactor"],
    );
  }

  String toJson() => json.encode(toMap());

  factory SignInResponseModel.fromJson(String source) =>
      SignInResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
