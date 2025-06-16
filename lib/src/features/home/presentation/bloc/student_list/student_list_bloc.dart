import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/studen_list_model.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/repos/student_list_repository.dart';
import 'package:injectable/injectable.dart';

part 'student_list_event.dart';
part 'student_list_state.dart';

@injectable
class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final StudentListRepository _repository;

  StudentListBloc(this._repository) : super(StudentListInitial()) {
    on<GetStudentListEvent>(_onGetStudentListEvent);
  }

  void _onGetStudentListEvent(
      GetStudentListEvent event, Emitter<StudentListState> emit) async {
    emit(StudentListLoading());
    final result = await _repository.getStudentList(event.className);
    result.fold(
      (failure) => emit(StudentListError(failure.message)),
      (students) => emit(StudentListLoaded(students)),
    );
  }
}
