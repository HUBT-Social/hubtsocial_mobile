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

abstract class TimetableRemoteDataSource {
  const TimetableRemoteDataSource();

  Future<TimetableResponseModel> initTimetable();

  Future<TimetableInfoResponseModel> getTimetableInfo(String timetableId);

  Future<void> scheduleNotificationsFromHive();
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
      // await _notificationService.scheduleNotificationsFromHive();

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

        oldDataTimetableResponseModel.delete();

        final timetableResponseModel =
            TimetableResponseModel.fromMap(response.data!);

        final sortReformTimetables = timetableResponseModel.reformTimetables
            .where((element) => element.startTime != null)
            .toList()
          ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

        final sortedTimetableResponseModel = timetableResponseModel.copyWith(
          versionKey: timetableResponseModel.versionKey,
          starttime: timetableResponseModel.starttime,
          endtime: timetableResponseModel.endtime,
          reformTimetables: sortReformTimetables,
        );

        await timetableBox.put(
            LocalStorageKey.timeTable, sortedTimetableResponseModel);

        // Schedule notifications with new data
        await _notificationService.scheduleNotificationsFromHive();
        logger.i('Successfully updated timetable and scheduled notifications');

        return sortedTimetableResponseModel;
      } else {
        logger.i('No cached timetable found. Fetching new data');
        final response = await _dioClient.get<Map<String, dynamic>>(
          EndPoint.timetable,
        );

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

        final sortReformTimetables = timetableResponseModel.reformTimetables
            .where((element) => element.startTime != null)
            .toList()
          ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

        final sortedTimetableResponseModel = timetableResponseModel.copyWith(
          versionKey: timetableResponseModel.versionKey,
          starttime: timetableResponseModel.starttime,
          endtime: timetableResponseModel.endtime,
          reformTimetables: sortReformTimetables,
        );

        await timetableBox.put(
            LocalStorageKey.timeTable, sortedTimetableResponseModel);

        // Schedule notifications with new data
        await _notificationService.scheduleNotificationsFromHive();
        logger.i('Successfully fetched timetable and scheduled notifications');

        return sortedTimetableResponseModel;
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while initializing timetable: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
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
      throw const ServerException(
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
}
