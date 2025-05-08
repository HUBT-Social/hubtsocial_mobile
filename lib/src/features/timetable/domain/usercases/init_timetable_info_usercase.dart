import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';
import '../../data/models/timetable_info_response_model.dart';
import '../repos/timetable_repo.dart';

@LazySingleton()
class InitTimetableInfoUserCase
    extends UseCaseWithParams<void, InitTimetableInfoParams> {
  const InitTimetableInfoUserCase(this._repo);
  final TimetableRepo _repo;
  @override
  ResultFuture<TimetableInfoResponseModel> call(
          InitTimetableInfoParams param) =>
      _repo.getTimetableInfo(param.timetableId);
}

class InitTimetableInfoParams extends Equatable {
  const InitTimetableInfoParams({required this.timetableId});
  final String timetableId;

  @override
  List<String> get props => [timetableId];
}
