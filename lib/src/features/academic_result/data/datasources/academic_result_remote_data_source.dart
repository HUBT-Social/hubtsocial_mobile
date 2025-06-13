import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/data/models/subject_score_model.dart';
import 'package:hubtsocial_mobile/src/features/academic_result/domain/models/score_distribution_data.dart';

abstract class AcademicResultRemoteDataSource {
  const AcademicResultRemoteDataSource();

  Future<List<SubjectScoreModel>> getAcademicResult();

  Future<ScoreDistributionData> getAcademicResultChart();
}

class AcademicResultRemoteDataSourceImpl
    implements AcademicResultRemoteDataSource {
  const AcademicResultRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<SubjectScoreModel>> getAcademicResult() async {
    try {
      final response = await _dioClient.get(EndPoint.getscore);
      print(
          'Debug: AcademicResultResponse - Type: ${response.data.runtimeType}');
      print('Debug: AcademicResultResponse - Data: ${response.data}');

      if (response.data is List) {
        return (response.data as List)
            .map((e) => SubjectScoreModel.fromJson(e))
            .toList();
      } else if (response.data is Map<String, dynamic>) {
        // If API returns a Map, check for specific error keys or a 'data' key
        if (response.data.containsKey('message')) {
          throw ServerException(
              message: response.data['message'] as String,
              statusCode: 'API_ERROR');
        } else {
          throw ServerException(
              message:
                  'Unexpected API response format (Map without data key): ${response.data}',
              statusCode: '500');
        }
      } else {
        throw ServerException(
            message:
                'Unexpected API response format: ${response.data.runtimeType}',
            statusCode: '500');
      }
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    }
  }

  @override
  Future<ScoreDistributionData> getAcademicResultChart() async {
    try {
      final response = await _dioClient.get(EndPoint.getclassinfoscore);
      print(
          'Debug: AcademicResultChartResponse - Type: ${response.data.runtimeType}');
      print('Debug: AcademicResultChartResponse - Data: ${response.data}');
      return ScoreDistributionData.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException.fromDioException(e);
    }
  }
}
