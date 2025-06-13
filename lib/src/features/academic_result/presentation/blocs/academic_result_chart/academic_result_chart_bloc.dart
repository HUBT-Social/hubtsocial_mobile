import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/models/score_distribution_data.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/repos/academic_result_repo.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/blocs/academic_result_chart/academic_result_chart_event.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/presentation/blocs/academic_result_chart/academic_result_chart_state.dart';

@injectable
class AcademicResultChartBloc
    extends Bloc<AcademicResultChartEvent, AcademicResultChartState> {
  final AcademicResultRepo _repo;

  AcademicResultChartBloc(this._repo)
      : super(const AcademicResultChartState.initial()) {
    on<LoadAcademicResultChart>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAcademicResultChart event,
    Emitter<AcademicResultChartState> emit,
  ) async {
    try {
      emit(const AcademicResultChartState.loading());
      final result = await _repo.getAcademicResultChart();
      emit(AcademicResultChartState.loaded(result));
    } catch (e) {
      emit(AcademicResultChartState.error(e.toString()));
    }
  }
}
