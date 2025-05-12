import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/notification/LocalMessage.dart';
import 'dart:convert';

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

  Future<void> testNotification();
}

@LazySingleton(
  as: TimetableRemoteDataSource,
)
class TimetableRemoteDataSourceImpl implements TimetableRemoteDataSource {
  TimetableRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;
  final LocalMessage _localMessage = LocalMessage();

  Future<void> _scheduleTimetableNotifications(
      TimetableResponseModel timetable) async {
    // Cancel all existing notifications before scheduling new ones
    await _localMessage.cancelAllNotifications();

    for (var reformTimetable in timetable.reformTimetables) {
      if (reformTimetable.startTime != null &&
          reformTimetable.endTime != null) {
        // Schedule notification 10 minutes before class starts
        final notificationStartTime =
            reformTimetable.startTime!.subtract(const Duration(minutes: 10));
        if (notificationStartTime.isAfter(DateTime.now())) {
          await _localMessage.scheduleNotification(
            id: int.parse(
                '${reformTimetable.id}1'), // Unique ID for start notification
            title: 'Sắp đến giờ học',
            body:
                'Lớp ${reformTimetable.className} - ${reformTimetable.subject} sẽ bắt đầu trong 10 phút nữa\nPhòng: ${reformTimetable.room ?? "Chưa cập nhật"}\nZoom ID: ${reformTimetable.zoomId ?? "Chưa cập nhật"}',
            scheduledDate: notificationStartTime,
            payload: jsonEncode({
              'timetableId': reformTimetable.id,
              'type': 'start_notification',
              'className': reformTimetable.className,
              'subject': reformTimetable.subject,
              'room': reformTimetable.room,
              'zoomId': reformTimetable.zoomId
            }),
          );
        }

        // Schedule notification when class ends
        if (reformTimetable.endTime!.isAfter(DateTime.now())) {
          await _localMessage.scheduleNotification(
            id: int.parse(
                '${reformTimetable.id}2'), // Unique ID for end notification
            title: 'Kết thúc buổi học',
            body:
                'Lớp ${reformTimetable.className} - ${reformTimetable.subject} đã kết thúc',
            scheduledDate: reformTimetable.endTime!,
            payload: jsonEncode({
              'timetableId': reformTimetable.id,
              'type': 'end_notification',
              'className': reformTimetable.className,
              'subject': reformTimetable.subject
            }),
          );
        }
      }
    }
  }

  @override
  Future<TimetableResponseModel> initTimetable() async {
    try {
      // Initialize local notifications
      await _localMessage.initLocalNotifications();

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

        // Sau khi lấy được dữ liệu mới, tự động lên lịch thông báo
        await _scheduleTimetableNotifications(timetableResponseModel);

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

        // Sau khi lấy được dữ liệu mới, tự động lên lịch thông báo
        await _scheduleTimetableNotifications(timetableResponseModel);

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

  Future<void> testNotification() async {
    try {
      // Khởi tạo local notifications
      await _localMessage.initLocalNotifications();

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

      // Lên lịch thông báo cho môn học test
      await _scheduleTimetableNotifications(testTimetableResponse);

      logger.i('Đã tạo thông báo test. Thông báo sẽ hiển thị sau 1 phút.');
    } catch (e, s) {
      logger.e('Lỗi khi tạo thông báo test: $e');
      logger.d(s.toString());
    }
  }
}
