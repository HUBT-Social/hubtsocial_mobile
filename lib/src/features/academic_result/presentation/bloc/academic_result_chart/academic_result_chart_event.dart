part of 'academic_result_chart_bloc.dart';

abstract class AcademicResultChartEvent extends Equatable {
  const AcademicResultChartEvent();
}

class GetAcademicResultChartEvent extends AcademicResultChartEvent {
  const GetAcademicResultChartEvent();

  @override
  List<Object> get props => [];
}
