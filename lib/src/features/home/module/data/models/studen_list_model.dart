import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';

class StudentListModel extends Equatable {
  StudentListModel({
    required this.gender,
    required this.birthDay,
    required this.avatarUrl,
    required this.userName,
    required this.fullName,
  });

  final Gender? gender;
  final DateTime? birthDay;
  final String avatarUrl;
  final String userName;
  final String fullName;

  StudentListModel copyWith({
    Gender? gender,
    DateTime? birthDay,
    String? avatarUrl,
    String? userName,
    String? fullName,
  }) {
    return StudentListModel(
      gender: gender ?? this.gender,
      birthDay: birthDay ?? this.birthDay,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
    );
  }

  factory StudentListModel.fromJson(Map<String, dynamic> json) {
    return StudentListModel(
      gender: Gender.values[json["gender"]],
      birthDay: DateTime.tryParse(json["birthDay"] ?? ""),
      avatarUrl: json["avatarUrl"],
      userName: json["userName"],
      fullName: json["fullName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "gender": gender,
        "birthDay": birthDay?.toIso8601String(),
        "avatarUrl": avatarUrl,
        "userName": userName,
        "fullName": fullName,
      };

  @override
  String toString() {
    return "$gender, $birthDay, $avatarUrl, $userName, $fullName, ";
  }

  @override
  List<Object?> get props => [
        gender,
        birthDay,
        avatarUrl,
        userName,
        fullName,
      ];
}
