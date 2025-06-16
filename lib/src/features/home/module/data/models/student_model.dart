import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String userName;
  final String fullName;
  final int gender;
  final DateTime birthDay;
  final String avatarUrl;

  const Student({
    required this.userName,
    required this.fullName,
    required this.gender,
    required this.birthDay,
    required this.avatarUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      userName: json['userName'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as int,
      birthDay: DateTime.parse(json['birthDay'] as String),
      avatarUrl: json['avatarUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [userName, fullName, gender, birthDay, avatarUrl];
}
