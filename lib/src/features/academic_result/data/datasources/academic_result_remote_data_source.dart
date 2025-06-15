import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/score_distribution_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/logger/logger.dart';

abstract class AcademicResultRemoteDataSource {
  const AcademicResultRemoteDataSource();

  Future<List<SubjectScoreModel>> getAcademicResult();

  Future<ScoreDistributionModel> getAcademicResultChart();
}

@LazySingleton(
  as: AcademicResultRemoteDataSource,
)
class AcademicResultRemoteDataSourceImpl
    implements AcademicResultRemoteDataSource {
  const AcademicResultRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<SubjectScoreModel>> getAcademicResult() async {
    try {
      //   final response = await _dioClient.get(EndPoint.getScore);

      //   if (response.data is List) {
      //     return (response.data as List)academic_result_remote_data_source
      //         .map((e) => SubjectScoreModel.fromJson(e))
      //         .toList();
      //   } else if (response.data is Map<String, dynamic>) {
      //     // If API returns a Map, check for specific error keys or a 'data' key
      //     if (response.data.containsKey('message')) {
      //       throw ServerException(
      //           message: response.data['message'] as String,
      //           statusCode: 'API_ERROR');
      //     } else {
      //       throw ServerException(
      //           message:
      //               'Unexpected API response format (Map without data key): ${response.data}',
      //           statusCode: '500');
      //     }
      //   } else {
      //     throw ServerException(
      //         message:
      //             'Unexpected API response format: ${response.data.runtimeType}',
      //         statusCode: '500');
      //   }
      // } on DioException catch (e) {
      //   throw ServerException.fromDioException(e);
      // }

      final response = await _dioClient.get(EndPoint.getScore);

      final statusCode = response.statusCode ?? 400;

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch getAcademicResult details. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to fetch getAcademicResult details. Please try again.',
          statusCode: statusCode.toString(),
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for getAcademicResult details');
        throw const ServerException(
          message:
              'Failed to fetch getAcademicResult details. No data received.',
          statusCode: '404',
        );
      }

      final subjectScores = response.data!
          .map<SubjectScoreModel>((item) => SubjectScoreModel.fromJson(item))
          .toList();

      logger.i('Successfully fetched getAcademicResult details');
      return subjectScores;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to get academic results. Please try again later.',
        statusCode: '505',
      );
    }
  }

  @override
  Future<ScoreDistributionModel> getAcademicResultChart() async {
    try {
      final response = await _dioClient.get(EndPoint.getClassInfoScore);

      final statusCode = response.statusCode ?? 400;

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch getAcademicResultChart details . Statu: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to fetch getAcademicResultChart details. Please try again.',
          statusCode: statusCode.toString(),
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for getAcademicResultChart details');
        throw const ServerException(
          message:
              'Failed to fetch getAcademicResultChart details. No data received.',
          statusCode: '404',
        );
      }

      final responseData = ScoreDistributionModel.fromJson(response.data!);
      logger.i('Successfully fetched getAcademicResultChart details');
      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message:
            'Failed to get getAcademicResultChart. Please try again later.',
        statusCode: '505',
      );
    }
  }
}
