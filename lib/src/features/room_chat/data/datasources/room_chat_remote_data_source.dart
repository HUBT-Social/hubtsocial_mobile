import 'package:chatview/chatview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/extensions/string.dart';

abstract class RoomChatRemoteDataSource {
  const RoomChatRemoteDataSource();

  Future<List<Message>> fetchRoomChat({
    required String roomId,
    int? page,
    int? limit,
  });

  Future<RoomInfoModel> getRoomMember({
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
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<Message>> fetchRoomChat({
    required String roomId,
    int? page,
    int? limit,
  }) async {
    try {
      logger.i(
          'Fetching room chat for roomId: $roomId, page: $page, limit: $limit');

      final response = await _dioClient.get<List<dynamic>>(
        EndPoint.roomHistory,
        queryParameters: {
          "ChatRoomId": roomId,
          if (page != null) "page": page.toString(),
          if (limit != null) "limit": limit.toString(),
        },
      );

      final statusCode = response.statusCode ?? 400;
      final statusCodeStr = statusCode.toString();

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch room chat. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?[0]?.toString() ??
              'Failed to fetch room chat. Please try again.',
          statusCode: statusCodeStr,
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for room chat');
        return [];
      }

      final items = response.data!.map<Message>((item) {
        try {
          final message = Message.fromJson(item as Map<String, dynamic>);
          // Decrypt the message if it's encrypted
          if (message.message.isNotEmpty) {
            final decryptedMessage = message.message.decrypt(key: roomId);
            return message.copyWith(message: decryptedMessage);
          }
          return message;
        } catch (e) {
          logger.e('Error parsing message: $e, Data: $item');
          rethrow;
        }
      }).toList();

      logger.i('Successfully fetched ${items.length} messages');
      return items;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching room chat: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to fetch room chat. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<RoomInfoModel> getRoomMember({
    required String roomId,
  }) async {
    try {
      logger.i('Fetching room members for roomId: $roomId');

      final response = await _dioClient.get<Map<String, dynamic>>(
        EndPoint.roomInfo,
        queryParameters: {
          "groupId": roomId,
        },
      );

      final statusCode = response.statusCode ?? 400;

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch room members. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to fetch room members. Please try again.',
          statusCode: statusCode.toString(),
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for room members');
        throw const ServerException(
          message: 'Failed to fetch room members. No data received.',
          statusCode: '404',
        );
      }

      final roomInfo = RoomInfoModel.fromJson(response.data!);
      logger.i('Successfully fetched room members');
      return roomInfo;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching room members: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to fetch room members. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
