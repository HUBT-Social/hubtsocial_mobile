import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../../../auth/domain/entities/user_token.dart';
import '../models/quiz_response_model.dart';

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
    try {
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.get(
        url: EndPoint.apiUrl,
        token: userToken.accessToken,
        queryParameters: {
          'page': page.toString(),
          'limit': '10',
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to Fetch Quiz: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      final List newItems = json.decode(response.body);

      List<QuizResponseModel> items = [];

      items.addAll(newItems.map<QuizResponseModel>((item) {
        return QuizResponseModel.fromJson(item);
      }).toList());

      return items;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to verify OTP password. Please try again later.',
        statusCode: '505',
      );
    }
  }
}
