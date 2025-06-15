import 'package:equatable/equatable.dart';

abstract class AcademicResultEvent extends Equatable {
  const AcademicResultEvent();

  @override
  List<Object> get props => [];
}

class GetAcademicResultEvent extends AcademicResultEvent {
  const GetAcademicResultEvent();
}
