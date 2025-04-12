import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/reform_timetable_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/timetable_type.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';
import 'package:hubtsocial_mobile/src/features/user/data/models/user_model.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<UserToken>(),
  AdapterSpec<UserTokenModel>(),
  AdapterSpec<User>(),
  AdapterSpec<UserModel>(),
  AdapterSpec<NotificationModel>(),
  AdapterSpec<ReformTimetable>(),
  AdapterSpec<TimetableResponseModel>(),
  AdapterSpec<TimetableType>(),
])
// This is for code generation
// ignore: unused_element
void _() {}
