part of 'student_list_bloc.dart';

abstract class StudentListEvent extends Equatable {
  const StudentListEvent();

  @override
  List<Object> get props => [];
}

class GetStudentListEvent extends StudentListEvent {
  final String className;

  const GetStudentListEvent(this.className);

  @override
  List<Object> get props => [className];
}
