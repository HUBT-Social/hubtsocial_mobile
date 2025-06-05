import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  const CourseModel({
    required this.major,
    required this.subjectName,
    required this.subjectCredit,
  });

  final String? major;
  final String? subjectName;
  final int? subjectCredit;

  CourseModel copyWith({
    String? major,
    String? subjectName,
    int? subjectCredit,
  }) {
    return CourseModel(
      major: major ?? this.major,
      subjectName: subjectName ?? this.subjectName,
      subjectCredit: subjectCredit ?? this.subjectCredit,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      major: json["major"],
      subjectName: json["subjectName"],
      subjectCredit: json["subjectCredit"],
    );
  }

  Map<String, dynamic> toJson() => {
        "major": major,
        "subjectName": subjectName,
        "subjectCredit": subjectCredit,
      };

  @override
  String toString() {
    return "$major, $subjectName, $subjectCredit, ";
  }

  @override
  List<Object?> get props => [
        major,
        subjectName,
        subjectCredit,
      ];
}
