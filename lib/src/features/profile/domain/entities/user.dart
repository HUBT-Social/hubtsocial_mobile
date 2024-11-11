import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class LocalUser extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String fullName;
  @HiveField(4)
  final String avatarUrl;
  @HiveField(5)
  final String email;
  const LocalUser({
    required this.id,
    required this.userName,
    required this.phoneNumber,
    required this.fullName,
    required this.avatarUrl,
    required this.email,
  });

  @override
  List<Object> get props => [id, phoneNumber];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'User{id: $id, phoneNumber: $phoneNumber, fullName: $fullName, avatarUrl: $avatarUrl, email: $email}';
  }
}
