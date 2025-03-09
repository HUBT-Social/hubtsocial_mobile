import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/models/class_schedule.dart';
import 'package:hubtsocial_mobile/src/features/user/data/models/user_model.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

// part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<UserToken>(),
  AdapterSpec<UserTokenModel>(),
  AdapterSpec<User>(),
  AdapterSpec<UserModel>(),
  AdapterSpec<NotificationModel>(),
  AdapterSpec<ClassSchedule>(),
])
// This is for code generation
// ignore: unused_element
void _() {}
