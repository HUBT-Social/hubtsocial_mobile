import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/timetable_info_response_model.dart';
import '../../domain/usercases/init_timetable_info_usercase.dart';

part 'timetable_info_event.dart';
part 'timetable_info_state.dart';

@Injectable()
class TimetableInfoBloc extends Bloc<TimetableInfoEvent, TimetableInfoState> {
  TimetableInfoBloc({
    required InitTimetableInfoUserCase fetchTimetableInfo,
  })  : _fetchTimetableInfo = fetchTimetableInfo,
        super(const TimetableInfoInitial()) {
    on<TimetableInfoEvent>((event, emit) {
      emit(const TimetableInfoLoading());
    });
    on<InitTimetableInfoEvent>(_fetchTimetableInfoHandler);
  }
  final InitTimetableInfoUserCase _fetchTimetableInfo;

  Future<void> _fetchTimetableInfoHandler(
    InitTimetableInfoEvent event,
    Emitter<TimetableInfoState> emit,
  ) async {
    final result = await _fetchTimetableInfo(
      InitTimetableInfoParams(timetableId: event.timetableId),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(TimetableInfoError(failure.message));
            break;
          default:
            emit(TimetableInfoError(failure.message));
            break;
        }
      },
      (response) {
        emit(InitTimetableInfoSuccess(response));
      },
    );
  }
}
