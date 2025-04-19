import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../models/quiz_response_model.dart';
import 'package:flutter/services.dart' show rootBundle;

abstract class QuizRemoteDataSource {
  const QuizRemoteDataSource();

  Future<List<QuizResponseModel>> fetchQuiz({
    required int page,
  });
}

@LazySingleton(
  as: QuizRemoteDataSource,
)
class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  const QuizRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

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
}
