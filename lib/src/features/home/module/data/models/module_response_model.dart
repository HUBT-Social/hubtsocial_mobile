import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/course_model.dart';

class ModuleResponseModel extends Equatable {
  ModuleResponseModel({
    required this.courses,
    required this.year,
  });

  final List<CourseModel> courses;
  final String? year;

  ModuleResponseModel copyWith({
    List<CourseModel>? courses,
    String? year,
  }) {
    return ModuleResponseModel(
      courses: courses ?? this.courses,
      year: year ?? this.year,
    );
  }

  factory ModuleResponseModel.fromJson(Map<String, dynamic> json) {
    return ModuleResponseModel(
      courses: json["courses"] == null
          ? []
          : List<CourseModel>.from(
              json["courses"]!.map((x) => CourseModel.fromJson(x))),
      year: json["year"],
    );
  }

  Map<String, dynamic> toJson() => {
        "courses": courses.map((x) => x?.toJson()).toList(),
        "year": year,
      };

  @override
  String toString() {
    return "$courses, $year, ";
  }

  @override
  List<Object?> get props => [
        courses,
        year,
      ];
}
