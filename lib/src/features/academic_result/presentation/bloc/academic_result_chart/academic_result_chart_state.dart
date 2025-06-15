part of 'academic_result_chart_bloc.dart';

abstract class AcademicResultChartState extends Equatable {
  const AcademicResultChartState();

  @override
  List<Object> get props => [];
}

class AcademicResultChartInitial extends AcademicResultChartState {
  const AcademicResultChartInitial();
}

class AcademicResultChartLoading extends AcademicResultChartState {
  const AcademicResultChartLoading();
}

class AcademicResultChartFailure extends AcademicResultChartState {
  const AcademicResultChartFailure();
}

class AcademicResultChartError extends AcademicResultChartState {
  const AcademicResultChartError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class GetAcademicResultChartSuccess extends AcademicResultChartState {
  const GetAcademicResultChartSuccess(this.model);

  final ScoreDistributionModel model;

  @override
  List<String> get props => [model.toString()];
}
