import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../models/quiz_info_response_model.dart';
import '../models/quiz_response_model.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  });

  @override
  Future<List<QuizResponseModel>> fetchQuiz({required int page}) async {
    const int limit = 10;
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/quiz/quiz.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final int startIndex = (page - 1) * limit;
      final int endIndex = startIndex + limit;

      if (startIndex >= jsonList.length) return [];

      final pageItems = jsonList.sublist(
        startIndex,
        endIndex > jsonList.length ? jsonList.length : endIndex,
      );

      return pageItems
          .map<QuizResponseModel>((item) => QuizResponseModel.fromJson(item))
          .toList();
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
      final String jsonString =
          await rootBundle.loadString('assets/data/quiz/$id.json');

      var responseData =
          QuizInfoResponseModel.fromJson(json.decode(jsonString));

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
