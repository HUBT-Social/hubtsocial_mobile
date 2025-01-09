import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/chat_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';

abstract class ChatRemoteDataSource {
  const ChatRemoteDataSource();

  Future<List<ChatResponseModel>> fetchChat({
    required int page,
  });
}

@LazySingleton(
  as: ChatRemoteDataSource,
)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

  @override
  Future<List<ChatResponseModel>> fetchChat({required int page}) async {
    try {
      final response = await APIRequest.get(
          url:
              "https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$page");

      if (response.statusCode != 200) {
        logger.e('Failed to Fetch Chat: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      final List newItems = json.decode(response.body);

      List<ChatResponseModel> items = [];

      items.addAll(newItems.map<ChatResponseModel>((item) {
        return ChatResponseModel.fromJson(item);
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
