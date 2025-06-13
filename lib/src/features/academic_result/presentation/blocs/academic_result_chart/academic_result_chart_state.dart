import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/models/score_distribution_data.dart';

part 'academic_result_chart_state.freezed.dart';

@freezed
class AcademicResultChartState with _$AcademicResultChartState {
  const factory AcademicResultChartState.initial() = _Initial;
  const factory AcademicResultChartState.loading() = _Loading;
  const factory AcademicResultChartState.loaded(ScoreDistributionData data) =
      _Loaded;
  const factory AcademicResultChartState.error(String message) = _Error;
}
