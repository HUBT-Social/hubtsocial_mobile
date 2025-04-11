import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/local_storage/local_storage_key.dart';
import '../../../../core/logger/logger.dart';
import '../../../auth/domain/entities/user_token.dart';
import '../models/timetable_response_model.dart';

abstract class TimetableRemoteDataSource {
  const TimetableRemoteDataSource();

  Future<TimetableResponseModel> initTimetable();
}

@LazySingleton(
  as: TimetableRemoteDataSource,
)
class TimetableRemoteDataSourceImpl implements TimetableRemoteDataSource {
  const TimetableRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

  @override
  Future<TimetableResponseModel> initTimetable() async {
    try {
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
        return timetableResponseModel;
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to init time table. Please try again later.',
        statusCode: '505',
      );
    }
  }
}
