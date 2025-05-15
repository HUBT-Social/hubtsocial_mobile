import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/local_storage/local_storage_key.dart';
import '../../../../core/logger/logger.dart';
import '../../../auth/domain/entities/user_token.dart';
import '../models/timetable_info_response_model.dart';
import '../models/timetable_response_model.dart';
import '../models/reform_timetable_model.dart';
import '../timetable_type.dart';

abstract class TimetableRemoteDataSource {
  const TimetableRemoteDataSource();

  Future<TimetableResponseModel> initTimetable();

  Future<TimetableInfoResponseModel> getTimetableInfo(String timetableId);

  Future<void> scheduleNotificationsFromHive();

  Future<void> testNotification();
}

@LazySingleton(
  as: TimetableRemoteDataSource,
)
class TimetableRemoteDataSourceImpl implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth {
    _notificationService = TimetableNotificationService();
  }

  final HiveInterface _hiveAuth;
  late final TimetableNotificationService _notificationService;

  @override
  Future<TimetableResponseModel> initTimetable() async {
    try {
      // Initialize local notifications
      await _notificationService.scheduleNotificationsFromHive();

      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }

      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);

      final oldDataTimetableResponseModel =
          timetableBox.get(LocalStorageKey.timeTable);

      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);
      if (oldDataTimetableResponseModel != null) {
        final responseCheckVersion = await APIRequest.get(
          url: EndPoint.checkVersion,
          queryParameters: {
            "Key": oldDataTimetableResponseModel.versionKey,
          },
          token: userToken.accessToken,
        );

        if (responseCheckVersion.statusCode != 200) {
          return oldDataTimetableResponseModel;
        }

        if (responseCheckVersion.body.toString() == "true") {
          return oldDataTimetableResponseModel;
        }

        final response = await APIRequest.get(
          url: EndPoint.timetable,
          token: userToken.accessToken,
        );

        if (response.statusCode != 200) {
          logger.e(
              'Failed to Fetch Timetable: statusCode: ${response.statusCode}: ${response.body.toString()}');
          throw ServerException(
            message: response.body.toString(),
            statusCode: response.statusCode.toString(),
          );
        }

        final timetableResponseModel =
            TimetableResponseModel.fromJson(response.body);
        oldDataTimetableResponseModel.delete();
        await timetableBox.put(
            LocalStorageKey.timeTable, timetableResponseModel);

        // Lên lịch thông báo ngay khi có dữ liệu mới
        await _notificationService.scheduleNotificationsFromHive();

        return timetableResponseModel;
      } else {
        final response = await APIRequest.get(
          url: EndPoint.timetable,
          token: userToken.accessToken,
        );

        if (response.statusCode != 200) {
          logger.e(
              'Failed to Fetch Timetable: statusCode: ${response.statusCode}: ${response.body.toString()}');
          throw ServerException(
            message: response.body.toString(),
            statusCode: response.statusCode.toString(),
          );
        }

        final timetableResponseModel =
            TimetableResponseModel.fromJson(response.body);

        await timetableBox.put(
            LocalStorageKey.timeTable, timetableResponseModel);

        // Lên lịch thông báo ngay khi có dữ liệu mới
        await _notificationService.scheduleNotificationsFromHive();

        return timetableResponseModel;
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to init timetable. Please try again later.',
        statusCode: '505',
      );
    }
  }

  @override
  Future<TimetableInfoResponseModel> getTimetableInfo(
      String timetableId) async {
    try {
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.get(
        url: EndPoint.timetableInfo,
        token: userToken.accessToken,
        queryParameters: {"timetableId": timetableId},
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to Get Timetable Info: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      var responseData = TimetableInfoResponseModel.fromMap(response.body);

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to get timetable info. Please try again later.',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> scheduleNotificationsFromHive() async {
    await _notificationService.scheduleNotificationsFromHive();
  }

  @override
  Future<void> testNotification() async {
    try {
      // Tạo một môn học test với thời gian bắt đầu sau 1 phút và kết thúc sau 2 phút
      final now = DateTime.now();
      final testTimetable = ReformTimetable(
        id: 'test_${now.millisecondsSinceEpoch}',
        className: 'Lớp Test',
        startTime: now.add(const Duration(minutes: 1)),
        endTime: now.add(const Duration(minutes: 2)),
        subject: 'Môn Test',
        room: 'Phòng Test',
        zoomId: '123456789',
        type: TimetableType.Study,
      );

      // Tạo TimetableResponseModel test
      final testTimetableResponse = TimetableResponseModel(
        versionKey: 'test_version',
        starttime: now,
        endtime: now.add(const Duration(days: 1)),
        reformTimetables: [testTimetable],
      );

      // Lưu vào Hive
      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }
      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      await timetableBox.put(LocalStorageKey.timeTable, testTimetableResponse);

      // Lên lịch thông báo
      await _notificationService.scheduleNotificationsFromHive();

      logger.i('Đã tạo thông báo test. Thông báo sẽ hiển thị sau 1 phút.');
    } catch (e, s) {
      logger.e('Lỗi khi tạo thông báo test: $e');
      logger.d(s.toString());
    }
  }
}
