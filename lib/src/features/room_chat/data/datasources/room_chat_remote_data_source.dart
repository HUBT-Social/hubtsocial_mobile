import 'dart:convert';

import 'package:chatview/chatview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../../../auth/domain/entities/user_token.dart';

abstract class RoomChatRemoteDataSource {
  const RoomChatRemoteDataSource();

  Future<List<Message>> fetchRoomChat({
    required String roomId,
  });
}

@LazySingleton(
  as: RoomChatRemoteDataSource,
)
class RoomChatRemoteDataSourceImpl implements RoomChatRemoteDataSource {
  const RoomChatRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

  @override
  Future<List<Message>> fetchRoomChat({required String roomId}) async {
    try {
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.get(
        url: "${EndPoint.getHistoryChat}?ChatRoomId=$roomId",
        token: userToken.accessToken,
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to Fetch RoomChat: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      final List newItems = json.decode(response.body);

      List<Message> items = [];

      items.addAll(newItems.map<Message>((item) {
        return Message.fromJson(item);
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
