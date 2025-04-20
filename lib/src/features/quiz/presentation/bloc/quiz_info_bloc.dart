import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/quiz_info_response_model.dart';
import '../../domain/usercases/get_quiz_info_usercase.dart';

part 'quiz_info_event.dart';
part 'quiz_info_state.dart';

@Injectable()
class QuizInfoBloc extends Bloc<QuizInfoEvent, QuizInfoState> {
  QuizInfoBloc({
    required GetQuizInfoUserCase getQuizInfo,
  })  : _getQuizInfo = getQuizInfo,
        super(const QuizInfoInitial()) {
    on<QuizInfoEvent>((event, emit) {
      emit(const QuizInfoLoading());
    });
    on<GetQuizInfoEvent>(_getQuizInfoHandler);
  }
  final GetQuizInfoUserCase _getQuizInfo;

  Future<void> _getQuizInfoHandler(
    GetQuizInfoEvent event,
    Emitter<QuizInfoState> emit,
  ) async {
    final result = await _getQuizInfo(
      GetQuizInfoParams(
        id: event.id,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(QuizInfoError(failure.message));
            break;
          default:
            emit(QuizInfoError(failure.message));
            break;
        }
      },
      (response) {
        emit(GetQuizInfoSuccess.getQuizInfoSuccess(response));
      },
    );
  }
}
