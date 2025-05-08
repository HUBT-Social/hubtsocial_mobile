part of 'timetable_info_bloc.dart';

abstract class TimetableInfoState extends Equatable {
  const TimetableInfoState();

  @override
  List<Object> get props => [];
}

// class EmailUpdatedState extends TimetableInfoState {
//   final String email;

//   const EmailUpdatedState(this.email);
// }

class TimetableInfoInitial extends TimetableInfoState {
  const TimetableInfoInitial();
}

class TimetableInfoLoading extends TimetableInfoState {
  const TimetableInfoLoading();
}

class TimetableInfoFailure extends TimetableInfoState {
  const TimetableInfoFailure();
}

class TimetableInfoSuccess extends TimetableInfoState {
  const TimetableInfoSuccess();
}

class TimetableInfoError extends TimetableInfoState {
  const TimetableInfoError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}

class InitTimetableInfo extends TimetableInfoState {
  const InitTimetableInfo(this.page);

  final int page;

  @override
  List<String> get props => [page.toString()];
}

class InitTimetableInfoSuccess extends TimetableInfoState {
  const InitTimetableInfoSuccess(this.timetableInfoModel);

  final TimetableInfoResponseModel timetableInfoModel;

  @override
  List<String> get props => [timetableInfoModel.toString()];
}
