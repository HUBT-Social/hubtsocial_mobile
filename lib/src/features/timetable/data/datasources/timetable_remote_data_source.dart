import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';

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

      // Get cached timetable data
      final cachedData = await _getCachedTimetable();
      if (cachedData != null) {
        // Check if cached data is up to date
        final isUpToDate = await _checkTimetableVersion(cachedData.versionKey);
        if (isUpToDate) {
          logger.i('Using cached timetable data');
          return cachedData;
        }
      }

      // If no cache or cache is outdated, fetch from network
      return await _fetchTimetableFromNetwork();
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while initializing timetable: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedTimetable();
      if (cachedData != null) {
        logger.i('Using cached timetable data after error');
        return cachedData;
      }

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

      // Try to get data from cache first
      final cachedData = await _getCachedTimetableInfo(timetableId);
      if (cachedData != null) return cachedData;

      // If no cache, try network request
      return await _fetchTimetableInfoFromNetwork(timetableId);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching timetable info: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedTimetableInfo(timetableId);
      if (cachedData != null) return cachedData;

      throw ServerException(
        message: 'Failed to fetch timetable info. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> scheduleNotificationsFromHive() async {
    try {
      await _notificationService.scheduleNotificationsFromHive();
    } catch (e, s) {
      logger.e('Error scheduling notifications: $e');
      logger.d('Stack trace: $s');
      // Don't throw here as this is a background operation
    }
  }

  @override
  Future<void> testNotification() async {
    try {
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
    } catch (e, s) {
      logger.e('Error testing notification: $e');
      logger.d('Stack trace: $s');
      // Don't throw here as this is a test operation
    }
  }

  /// Attempts to get timetable data from cache
  Future<TimetableResponseModel?> _getCachedTimetable() async {
    try {
      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }

      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      final cachedData = timetableBox.get(LocalStorageKey.timeTable);

      if (cachedData != null) {
        logger.i('Successfully retrieved cached timetable data');
        return cachedData;
      }
    } catch (e) {
      logger.w('No cached timetable data available: $e');
    }
    return null;
  }

  /// Checks if the cached timetable version is up to date
  Future<bool> _checkTimetableVersion(String versionKey) async {
    try {
      // First try cached version check
      final cachedVersionResponse = await _dioClient.getWithCache<dynamic>(
        EndPoint.checkVersion,
        queryParameters: {"Key": versionKey},
        policy: CachePolicy.forceCache,
      );

      if (cachedVersionResponse.data != null) {
        logger.i('Successfully retrieved cached version check data');
        return cachedVersionResponse.data == true;
      }

      // If no cache, try network request
      final response = await _dioClient.getWithCache<dynamic>(
        EndPoint.checkVersion,
        queryParameters: {"Key": versionKey},
        maxStale: const Duration(hours: 12),
        policy: CachePolicy.refreshForceCache,
      );

      _validateResponse(response);
      return response.data == true;
    } catch (e) {
      logger.w('Error checking timetable version: $e');
      return false;
    }
  }

  /// Fetches timetable data from network
  Future<TimetableResponseModel> _fetchTimetableFromNetwork() async {
    final response = await _dioClient.getWithCache<Map<String, dynamic>>(
      EndPoint.timetable,
      maxStale: const Duration(hours: 12),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    final timetableData = TimetableResponseModel.fromMap(response.data!);

    // Store in cache
    try {
      if (!Hive.isBoxOpen(LocalStorageKey.timeTable)) {
        await Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable);
      }
      final timetableBox =
          Hive.box<TimetableResponseModel>(LocalStorageKey.timeTable);
      await timetableBox.put(LocalStorageKey.timeTable, timetableData);
      logger.i('Successfully cached timetable data');
    } catch (e) {
      logger.w('Failed to cache timetable data: $e');
    }

    return timetableData;
  }

  /// Attempts to get timetable info from cache
  Future<TimetableInfoResponseModel?> _getCachedTimetableInfo(
      String timetableId) async {
    try {
      final response = await _dioClient.getWithCache<Map<String, dynamic>>(
        '${EndPoint.timetable}/$timetableId',
        policy: CachePolicy.forceCache,
      );

      if (response.data != null) {
        logger.i('Successfully retrieved cached timetable info');
        return TimetableInfoResponseModel.fromJson(response.data!);
      }
    } catch (e) {
      logger.w('No cached timetable info available: $e');
    }
    return null;
  }

  /// Fetches timetable info from network
  Future<TimetableInfoResponseModel> _fetchTimetableInfoFromNetwork(
      String timetableId) async {
    final response = await _dioClient.getWithCache<Map<String, dynamic>>(
      '${EndPoint.timetable}/$timetableId',
      maxStale: const Duration(hours: 12),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    return TimetableInfoResponseModel.fromJson(response.data!);
  }

  /// Validates the response and throws appropriate exceptions
  void _validateResponse(Response response) {
    final statusCode = response.statusCode ?? 400;

    if (statusCode == 401) {
      logger.w('Unauthorized access');
      throw const ServerException(
        message: 'Your session has expired. Please login again.',
        statusCode: '401',
      );
    }

    if (statusCode != 200) {
      logger
          .e('Request failed. Status: $statusCode, Response: ${response.data}');
      throw ServerException(
        message: response.data?['message']?.toString() ??
            'Request failed. Please try again.',
        statusCode: statusCode.toString(),
      );
    }
  }
}
