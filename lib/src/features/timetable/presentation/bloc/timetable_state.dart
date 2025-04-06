part of 'timetable_bloc.dart';

abstract class TimetableState extends Equatable {
  const TimetableState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends TimetableState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

class TimetableInitial extends TimetableState {
  const TimetableInitial();
}

class TimetableLoading extends TimetableState {
  const TimetableLoading();
}

class TimetableFailure extends TimetableState {
  const TimetableFailure();
}

class TimetableSuccess extends TimetableState {
  const TimetableSuccess();
}

class TimetableError extends TimetableState {
  const TimetableError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class InitTimetable extends TimetableState {
  const InitTimetable(this.page);

  final int page;

  @override
  List<String> get props => [page.toString()];
}

class InitTimetableSuccess extends TimetableState {
  const InitTimetableSuccess(this.timetableModel);

  final TimetableResponseModel timetableModel;

  @override
  List<String> get props => [timetableModel.toString()];
}
