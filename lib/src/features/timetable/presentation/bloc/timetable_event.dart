part of 'timetable_bloc.dart';

abstract class TimetableEvent extends Equatable {
  const TimetableEvent();
}

class InitTimetableEvent extends TimetableEvent {
  const InitTimetableEvent();

  @override
  List<Object?> get props => [];
}
