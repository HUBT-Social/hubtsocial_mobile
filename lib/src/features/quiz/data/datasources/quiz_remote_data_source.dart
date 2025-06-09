import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../models/quiz_info_response_model.dart';
import '../models/quiz_response_model.dart';

abstract class QuizRemoteDataSource {
  const QuizRemoteDataSource();

  Future<List<QuizResponseModel>> fetchQuiz({
    required int page,
  });

  Future<QuizInfoResponseModel> getQuiz({
    required String id,
  });
}

@LazySingleton(
  as: QuizRemoteDataSource,
)
class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  const QuizRemoteDataSourceImpl({
    required FirebaseMessaging messaging,
    required DioClient dioClient,
  }) : _dioClient = dioClient;
  final DioClient _dioClient;

  @override
  Future<List<QuizResponseModel>> fetchQuiz({required int page}) async {
    const int limit = 6;
    try {
      logger.i('Fetching Quiz list for page: $page, limit: $limit');

      final response = await _dioClient.get(
        EndPoint.questions,
        queryParameters: {
          "page": page.toString(),
          "limit": limit.toString(),
        },
      );

      final statusCode = response.statusCode ?? 400;
      final statusCodeStr = statusCode.toString();

      if (statusCode == 401) {
        logger.w('Unauthorized access to Quiz list');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch Quiz list. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?[0]?.toString() ??
              'Failed to fetch Quiz list. Please try again.',
          statusCode: statusCodeStr,
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for chat list');
        return [];
      }

      final items = response.data!
          .map<QuizResponseModel>((item) => QuizResponseModel.fromJson(item))
          .toList();

      logger.i('Successfully fetched ${items.length} Quiz items');
      return items;
    } catch (e, s) {
      logger.e('Error reading paginated local JSON: $e');
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to read paginated local quiz data.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<QuizInfoResponseModel> getQuiz({required String id}) async {
    try {
      logger.i('Fetching Quiz details for id: $id');
      final response = await _dioClient.get<Map<String, dynamic>>(
        EndPoint.questionsDetail,
        queryParameters: {
          "id": id,
        },
      );

      final statusCode = response.statusCode ?? 400;
      final statusCodeStr = statusCode.toString();

      if (statusCode == 401) {
        logger.w('Unauthorized access to Quiz details ');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch Quiz details . Statu: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to fetch Quiz details. Please try again.',
          statusCode: statusCode.toString(),
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for Quiz details');
        throw const ServerException(
          message: 'Failed to fetch Quiz details. No data received.',
          statusCode: '404',
        );
      }

      final responseData = QuizInfoResponseModel.fromJson(response.data!);
      logger.i('Successfully fetched Quiz details');
      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to get Quiz. Please try again later.',
        statusCode: '505',
      );
    }
  }
}
