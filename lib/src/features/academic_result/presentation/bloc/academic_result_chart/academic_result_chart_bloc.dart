import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/get_academic_result_chart_usecase.dart';

part 'academic_result_chart_event.dart';
part 'academic_result_chart_state.dart';

@Injectable()
class AcademicResultChartBloc
    extends Bloc<AcademicResultChartEvent, AcademicResultChartState> {
  AcademicResultChartBloc({
    required GetAcademicResultChartUseCase getAcademicResultChart,
  })  : _getAcademicResultChart = getAcademicResultChart,
        super(const AcademicResultChartInitial()) {
    on<AcademicResultChartEvent>((event, emit) {
      emit(const AcademicResultChartLoading());
    });
    on<GetAcademicResultChartEvent>(_getAcademicResultChartHandler);
  }
  final GetAcademicResultChartUseCase _getAcademicResultChart;

  Future<void> _getAcademicResultChartHandler(
    GetAcademicResultChartEvent event,
    Emitter<AcademicResultChartState> emit,
  ) async {
    final result = await _getAcademicResultChart(
      GetAcademicResultChartParams(),
    );
    result.fold(
      (failure) {
        switch (failure.statusCode) {
          case '401':
            emit(AcademicResultChartError(failure.message));
            break;
          default:
            emit(AcademicResultChartError(failure.message));
            break;
        }
      },
      (response) {
        emit(GetAcademicResultChartSuccess(response));
      },
    );
  }
}
