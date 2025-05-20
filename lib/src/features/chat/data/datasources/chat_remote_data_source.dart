import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:injectable/injectable.dart';

import '../../../../constants/end_point.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/logger/logger.dart';
import '../../../../core/extensions/string.dart';
import '../models/chat_response_model.dart';

abstract class ChatRemoteDataSource {
  const ChatRemoteDataSource();

  Future<List<ChatResponseModel>> fetchChat({
    required int page,
    required int limit,
  });
}

@LazySingleton(
  as: ChatRemoteDataSource,
)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required DioClient dioClient,
  })  : _hiveAuth = hiveAuth,
        _dioClient = dioClient;

  final HiveInterface _hiveAuth;
  final DioClient _dioClient;

  @override
  Future<List<ChatResponseModel>> fetchChat({
    required int page,
    required int limit,
  }) async {
    try {
      logger.i('Fetching chat list for page: $page, limit: $limit');

      final response = await _dioClient.get<List<dynamic>>(
        EndPoint.chatView,
        queryParameters: {
          "page": page.toString(),
          "limit": limit.toString(),
        },
      );

      final statusCode = response.statusCode ?? 400;
      final statusCodeStr = statusCode.toString();

      if (statusCode == 401) {
        logger.w('Unauthorized access to chat list');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (statusCode != 200) {
        logger.e(
          'Failed to fetch chat list. Status: $statusCode, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?[0]?.toString() ??
              'Failed to fetch chat list. Please try again.',
          statusCode: statusCodeStr,
        );
      }

      if (response.data == null) {
        logger.w('Empty response received for chat list');
        return [];
      }

      final items = response.data!.map<ChatResponseModel>((item) {
        try {
          final chatItem =
              ChatResponseModel.fromJson(item as Map<String, dynamic>);
          // Decrypt the last message if it's encrypted
          if (chatItem.lastMessage != null &&
              chatItem.lastMessage!.isNotEmpty) {
            final decryptedMessage =
                chatItem.lastMessage!.decrypt(key: chatItem.id);
            return chatItem.copyWith(lastMessage: decryptedMessage);
          }
          return chatItem;
        } catch (e) {
          logger.e('Error parsing chat item: $e, Data: $item');
          rethrow;
        }
      }).toList();

      logger.i('Successfully fetched ${items.length} chat items');
      return items;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching chat list: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to fetch chat list. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
