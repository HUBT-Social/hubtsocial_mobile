import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/domain/usercases/init_timetable_usercase.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/timetable_response_model.dart';

part 'timetable_event.dart';
part 'timetable_state.dart';

@Injectable()
class TimetableBloc extends Bloc<TimetableEvent, TimetableState> {
  TimetableBloc({
    required InitTimetableUserCase fetchTimetable,
  })  : _fetchTimetable = fetchTimetable,
        super(const TimetableInitial()) {
    on<TimetableEvent>((event, emit) {
      emit(const TimetableLoading());
    });
    on<InitTimetableEvent>(_fetchTimetableHandler);
  }
  final InitTimetableUserCase _fetchTimetable;

  Future<void> _fetchTimetableHandler(
    InitTimetableEvent event,
    Emitter<TimetableState> emit,
  ) async {
    final result = await _fetchTimetable(
      InitTimetableParams(),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(TimetableError(failure.message));
            break;
          default:
            emit(TimetableError(failure.message));
            break;
        }
      },
      (response) {
        emit(InitTimetableSuccess(response));
      },
    );
  }
}
