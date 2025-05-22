import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/local_storage/local_storage_key.dart';
import '../../../../core/logger/logger.dart';
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
    required DioClient dioClient,
  }) : _dioClient = dioClient {
    _notificationService = TimetableNotificationService();
  }

  final DioClient _dioClient;
  late final TimetableNotificationService _notificationService;

  @override
  Future<TimetableResponseModel> initTimetable() async {
    try {
      logger.i('Initializing timetable');

      // Initialize local notifications
      await _notificationService.scheduleNotificationsFromHive();

      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }

      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      final oldDataTimetableResponseModel =
          timetableBox.get(LocalStorageKey.timeTable);

      if (oldDataTimetableResponseModel != null) {
        logger.i(
            'Checking timetable version with key: ${oldDataTimetableResponseModel.versionKey}');

        final responseCheckVersion = await _dioClient.get<dynamic>(
          EndPoint.checkVersion,
          queryParameters: {
            "Key": oldDataTimetableResponseModel.versionKey,
          },
        );

        if (responseCheckVersion.statusCode == 401) {
          logger.w('Unauthorized access while checking timetable version');
          throw const ServerException(
            message: 'Your session has expired. Please login again.',
            statusCode: '401',
          );
        }

        if (responseCheckVersion.statusCode != 200) {
          logger.w(
            'Failed to check timetable version. Using cached data. Status: ${responseCheckVersion.statusCode}',
          );
          return oldDataTimetableResponseModel;
        }

        if (responseCheckVersion.data == true) {
          logger.i('Timetable is up to date');
          return oldDataTimetableResponseModel;
        }

        logger.i('Fetching new timetable data');
        final response = await _dioClient.get<Map<String, dynamic>>(
          EndPoint.timetable,
        );

        if (response.statusCode == 401) {
          logger.w('Unauthorized access while fetching timetable');
          throw const ServerException(
            message: 'Your session has expired. Please login again.',
            statusCode: '401',
          );
        }

        if (response.statusCode != 200) {
          logger.e(
            'Failed to fetch timetable. Status: ${response.statusCode}, Response: ${response.data}',
          );
          throw ServerException(
            message: response.data?['message']?.toString() ??
                'Failed to fetch timetable. Please try again.',
            statusCode: response.statusCode?.toString() ?? '400',
          );
        }

        if (response.data == null) {
          logger.e('Empty response received for timetable');
          throw const ServerException(
            message: 'Invalid timetable data received from server.',
            statusCode: '400',
          );
        }

        final timetableResponseModel =
            TimetableResponseModel.fromMap(response.data!);
        oldDataTimetableResponseModel.delete();
        await timetableBox.put(
            LocalStorageKey.timeTable, timetableResponseModel);

        // Schedule notifications with new data
        await _notificationService.scheduleNotificationsFromHive();
        logger.i('Successfully updated timetable and scheduled notifications');

        return timetableResponseModel;
      } else {
        logger.i('No cached timetable found. Fetching new data');
        final response = await _dioClient.get<Map<String, dynamic>>(
          EndPoint.timetable,
        );

        if (response.statusCode == 401) {
          logger.w('Unauthorized access while fetching timetable');
          throw const ServerException(
            message: 'Your session has expired. Please login again.',
            statusCode: '401',
          );
        }

        if (response.statusCode != 200) {
          logger.e(
            'Failed to fetch timetable. Status: ${response.statusCode}, Response: ${response.data}',
          );
          throw ServerException(
            message: response.data?['message']?.toString() ??
                'Failed to fetch timetable. Please try again.',
            statusCode: response.statusCode?.toString() ?? '400',
          );
        }

        if (response.data == null) {
          logger.e('Empty response received for timetable');
          throw const ServerException(
            message: 'Invalid timetable data received from server.',
            statusCode: '400',
          );
        }

        final timetableResponseModel =
            TimetableResponseModel.fromMap(response.data!);
        await timetableBox.put(
            LocalStorageKey.timeTable, timetableResponseModel);

        // Schedule notifications with new data
        await _notificationService.scheduleNotificationsFromHive();
        logger.i('Successfully fetched timetable and scheduled notifications');

        return timetableResponseModel;
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while initializing timetable: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to initialize timetable. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<TimetableInfoResponseModel> getTimetableInfo(
      String timetableId) async {
    try {
      logger.i('Fetching timetable info for id: $timetableId');

      final response = await _dioClient.get<Map<String, dynamic>>(
        EndPoint.timetableInfo,
        queryParameters: {"timetableId": timetableId},
      );

      if (response.statusCode == 401) {
        logger.w('Unauthorized access while fetching timetable info');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (response.statusCode == 404) {
        logger.w('Timetable not found. Id: $timetableId');
        throw const ServerException(
          message:
              'Timetable not found. It may have been deleted or you no longer have access.',
          statusCode: '404',
        );
      }

      if (response.statusCode != 200) {
        logger.e(
          'Failed to get timetable info. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to get timetable information. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      if (response.data == null) {
        logger.e('Empty response received for timetable info');
        throw const ServerException(
          message: 'Invalid timetable information received from server.',
          statusCode: '400',
        );
      }

      final timetableInfo = TimetableInfoResponseModel.fromJson(response.data!);
      logger.i('Successfully fetched timetable info');
      return timetableInfo;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while getting timetable info: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to get timetable information. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> scheduleNotificationsFromHive() async {
    try {
      logger.i('Scheduling notifications from Hive');
      await _notificationService.scheduleNotificationsFromHive();
      logger.i('Successfully scheduled notifications');
    } catch (e, s) {
      logger.e('Failed to schedule notifications: $e');
      logger.d('Stack trace: $s');
      // Don't throw here as this is a background operation
    }
  }

  @override
  Future<void> testNotification() async {
    try {
      logger.i('Sending test notification');

      final now = DateTime.now();
      final testTimetable = ReformTimetable(
        id: 'test_${now.millisecondsSinceEpoch}',
        className: 'GO HOME',
        startTime: now,
        endTime: now.add(const Duration(minutes: 1)),
        subject: 'NGUYỄN THẾ TRƯỜNG DZ',
        room: 'ĐẠI HỌC KINH DOANH CÔNG NGHỆ',
        zoomId: '0949101573',
        type: TimetableType.Study,
      );

      await _notificationService.showInstantNotification(testTimetable);
      logger.i('Successfully sent test notification');
    } catch (e, s) {
      logger.e('Failed to send test notification: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to send test notification. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
