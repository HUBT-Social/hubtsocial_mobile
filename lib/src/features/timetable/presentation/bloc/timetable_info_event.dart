part of 'timetable_info_bloc.dart';

abstract class TimetableInfoEvent extends Equatable {
  const TimetableInfoEvent({required this.timetableId});
  final String timetableId;
}

class InitTimetableInfoEvent extends TimetableInfoEvent {
  const InitTimetableInfoEvent({required super.timetableId});

  @override
  List<Object?> get props => [timetableId];
}
