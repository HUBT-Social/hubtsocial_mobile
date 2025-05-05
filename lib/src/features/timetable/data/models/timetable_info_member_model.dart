import 'package:equatable/equatable.dart';

class TimetableInfoMemberModel extends Equatable {
  const TimetableInfoMemberModel({
    required this.avatarUrl,
    required this.userName,
    required this.fullName,
  });

  final String? avatarUrl;
  final String? userName;
  final String? fullName;

  TimetableInfoMemberModel copyWith({
    String? avatarUrl,
    String? userName,
    String? fullName,
  }) {
    return TimetableInfoMemberModel(
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
    );
  }

  factory TimetableInfoMemberModel.fromJson(Map<String, dynamic> json) {
    return TimetableInfoMemberModel(
      avatarUrl: json["avatarUrl"],
      userName: json["userName"],
      fullName: json["fullName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "avatarUrl": avatarUrl,
        "userName": userName,
        "fullName": fullName,
      };

  @override
  String toString() {
    return "$avatarUrl, $userName, $fullName, ";
  }

  @override
  List<Object?> get props => [
        avatarUrl,
        userName,
        fullName,
      ];
}
