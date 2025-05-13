import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';

@module
abstract class TimetableModule {
  @singleton
  TimetableNotificationService get timetableNotificationService =>
      TimetableNotificationService();
}
