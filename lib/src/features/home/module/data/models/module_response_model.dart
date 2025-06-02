import 'package:equatable/equatable.dart';

class ModuleResponseModel extends Equatable {
  ModuleResponseModel({
    required this.major,
    required this.subjectName,
    required this.subjectCredit,
    required this.subjectYear,
  });

  final String? major;
  final String? subjectName;
  final int? subjectCredit;
  final int? subjectYear;

  ModuleResponseModel copyWith({
    String? major,
    String? subjectName,
    int? subjectCredit,
    int? subjectYear,
  }) {
    return ModuleResponseModel(
      major: major ?? this.major,
      subjectName: subjectName ?? this.subjectName,
      subjectCredit: subjectCredit ?? this.subjectCredit,
      subjectYear: subjectYear ?? this.subjectYear,
    );
  }

  factory ModuleResponseModel.fromJson(Map<String, dynamic> json) {
    return ModuleResponseModel(
      major: json["major"],
      subjectName: json["subjectName"],
      subjectCredit: json["subjectCredit"],
      subjectYear: json["subjectYear"],
    );
  }

  Map<String, dynamic> toJson() => {
        "major": major,
        "subjectName": subjectName,
        "subjectCredit": subjectCredit,
        "subjectYear": subjectYear,
      };

  @override
  String toString() {
    return "$major, $subjectName, $subjectCredit, $subjectYear, ";
  }

  @override
  List<Object?> get props => [
        major,
        subjectName,
        subjectCredit,
        subjectYear,
      ];
}
