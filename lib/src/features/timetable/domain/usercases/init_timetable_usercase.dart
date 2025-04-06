import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';
import '../../data/models/timetable_response_model.dart';
import '../repos/timetable_repo.dart';

@LazySingleton()
class InitTimetableUserCase
    extends UseCaseWithParams<void, InitTimetableParams> {
  const InitTimetableUserCase(this._repo);
  final TimetableRepo _repo;
  @override
  ResultFuture<TimetableResponseModel> call(InitTimetableParams param) =>
      _repo.initTimetable();
}

class InitTimetableParams extends Equatable {
  const InitTimetableParams();

  @override
  List<String> get props => [];
}
