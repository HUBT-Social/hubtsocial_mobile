import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

part 'user_token_model.g.dart';

@HiveType(typeId: 1)
class UserTokenModel extends UserToken {
  UserTokenModel({
    required super.tokenType,
    required super.accessToken,
    required super.expiresIn,
    required super.refreshToken,
  });

  UserTokenModel copyWith({
    String? tokenType,
    String? accessToken,
    int? expiresIn,
    String? refreshToken,
  }) {
    return UserTokenModel(
      tokenType: tokenType ?? this.tokenType,
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokenType': tokenType,
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
    };
  }

  factory UserTokenModel.fromMap(Map<String, dynamic> map) {
    return UserTokenModel(
      tokenType: map['tokenType'] as String,
      accessToken: map['accessToken'] as String,
      expiresIn: map['expiresIn'] as int,
      refreshToken: map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTokenModel.fromJson(String source) =>
      UserTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
