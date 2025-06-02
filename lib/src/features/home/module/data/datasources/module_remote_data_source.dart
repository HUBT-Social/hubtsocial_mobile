import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class ModuleRemoteDataSource {
  const ModuleRemoteDataSource();

  Future<List<ModuleResponseModel>> getModule();
}

@LazySingleton(
  as: ModuleRemoteDataSource,
)
class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  const ModuleRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<ModuleResponseModel>> getModule() async {
    try {
      final response = await _dioClient.get<List<dynamic>>(
        EndPoint.module,
      );

      final statusCode = response.statusCode ?? 400;
      final statusCodeStr = statusCode.toString();

      if (statusCode == 401) {
        logger.w('Unauthorized access to module list');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch module list. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?[0]?.toString() ??
              'Failed to fetch module list. Please try again.',
          statusCode: statusCodeStr,
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for module list');
        return [];
      }

      final items = response.data!
          .map<ModuleResponseModel>(
              (item) => ModuleResponseModel.fromJson(item))
          .toList();

      logger.i('Successfully fetched ${items.length} module items');
      return items;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching module list: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to fetch module list. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
