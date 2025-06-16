part of 'student_list_bloc.dart';

abstract class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object> get props => [];
}

class StudentListInitial extends StudentListState {}

class StudentListLoading extends StudentListState {}

class StudentListLoaded extends StudentListState {
  final List<StudentListModel> students;

  const StudentListLoaded(this.students);

  @override
  List<Object> get props => [students];
}

class StudentListError extends StudentListState {
  final String message;

  const StudentListError(this.message);

  @override
  List<Object> get props => [message];
}
