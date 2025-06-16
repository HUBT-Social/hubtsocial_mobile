import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String? avatarUrl;
  final String userName;
  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? email;
  final String? birthDay;
  final String? phoneNumber;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  const UserProfileModel({
    this.avatarUrl,
    required this.userName,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.birthDay,
    this.phoneNumber,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      avatarUrl: json['avatarUrl'] as String?,
      userName: json['userName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as int?,
      email: json['email'] as String?,
      birthDay: json['birthDay'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        avatarUrl,
        userName,
        firstName,
        lastName,
        gender,
        email,
        birthDay,
        phoneNumber,
      ];
}
