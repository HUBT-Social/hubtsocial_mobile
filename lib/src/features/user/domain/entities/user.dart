import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../../../core/local_storage/local_storage_type_id.dart';
import '../../data/gender.dart';

part 'user.g.dart';

@HiveType(typeId: LocalStorageTypeId.user)
class User extends Equatable {
  @HiveField(0)
  final String firstName;
  @HiveField(1)
  final String lastName;
  @HiveField(2)
  final Gender gender;
  @HiveField(3)
  final String avatarUrl;
  @HiveField(4)
  final DateTime? birthDay;
  @HiveField(5)
  final String? phoneNumber;
  @HiveField(6)
  final String? email;

  String get fullname => "$firstName $lastName";

  const User({
    // required this.idUser,
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

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        gender,
        avatarUrl,
        birthDay,
        phoneNumber,
      ];
}
