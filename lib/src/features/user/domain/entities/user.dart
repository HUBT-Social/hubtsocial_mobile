import 'package:hive_ce_flutter/adapters.dart';

import '../../data/gender.dart';

class User extends HiveObject {
  final String userName;
  final String firstName;
  final String lastName;
  final Gender gender;
  final String avatarUrl;
  final DateTime? birthDay;
  final String? phoneNumber;
  final String? email;

  String get fullname => "$lastName $firstName";

  User({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.avatarUrl,
    required this.birthDay,
    required this.phoneNumber,
    required this.email,
  });

  @override
  String toString() {
    return "user model[firstName: $firstName, lastName: $lastName, gender: $gender, avatarUrl: $avatarUrl,birthDay: $birthDay,phoneNumber: $phoneNumber,]";
  }
}
