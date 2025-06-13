import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_result_chart_event.freezed.dart';

@freezed
class AcademicResultChartEvent with _$AcademicResultChartEvent {
  const factory AcademicResultChartEvent.load() = LoadAcademicResultChart;
}
