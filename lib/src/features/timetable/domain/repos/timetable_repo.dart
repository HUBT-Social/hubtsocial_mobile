import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';

import '../../data/models/timetable_response_model.dart';

abstract class TimetableRepo {
  const TimetableRepo();
  ResultFuture<TimetableResponseModel> initTimetable();
}
