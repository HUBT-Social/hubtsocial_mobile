import 'dart:convert';

import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

import '../gender.dart';

class UserModel extends User {
  UserModel({
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.email,
    required super.avatarUrl,
    required super.birthDay,
    required super.phoneNumber,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    Gender? gender,
    String? avatarUrl,
    DateTime? birthDay,
    String? phoneNumber,
    String? email,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthDay: birthDay ?? this.birthDay,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() => {
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "avatarUrl": avatarUrl,
        "birthDay": birthDay?.toIso8601String(),
        "phoneNumber": phoneNumber,
      };

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      gender: Gender.values[json["gender"]],
      avatarUrl: json["avatarUrl"],
      birthDay: DateTime.tryParse(json["birthDay"] ?? ""),
      phoneNumber: json["phoneNumber"],
      email: json["email"],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
