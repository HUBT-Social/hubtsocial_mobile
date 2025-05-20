import 'package:chatview/chatview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/features/room_chat/data/models/room_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';

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
    required String groupId,
  });
}

@LazySingleton(as: RoomChatRemoteDataSource)
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

      // Try to get data from cache first
      final cachedData = await _getCachedRoomChat(roomId, page, limit);
      if (cachedData != null) return cachedData;

      // If no cache, try network request
      return await _fetchRoomChatFromNetwork(roomId, page, limit);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching room chat: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedRoomChat(roomId, page, limit);
      if (cachedData != null) return cachedData;

      throw ServerException(
        message: 'Failed to fetch room chat. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<RoomInfoModel> getRoomMember({
    required String groupId,
  }) async {
    try {
      logger.i('Fetching room member info for groupId: $groupId');

      // Try to get data from cache first
      final cachedData = await _getCachedRoomMember(groupId);
      if (cachedData != null) return cachedData;

      // If no cache, try network request
      return await _fetchRoomMemberFromNetwork(groupId);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching room member: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedRoomMember(groupId);
      if (cachedData != null) return cachedData;

      throw ServerException(
        message: 'Failed to fetch room member info. Please try again later.',
        statusCode: '500',
      );
    }
  }

  /// Attempts to get room chat data from cache
  Future<List<Message>?> _getCachedRoomChat(
    String roomId,
    int? page,
    int? limit,
  ) async {
    try {
      final response = await _dioClient.getWithCache<List<dynamic>>(
        EndPoint.roomHistory,
        queryParameters: _buildRoomChatQueryParams(roomId, page, limit),
        policy: CachePolicy.forceCache,
      );

      if (response.data != null) {
        logger.i('Successfully retrieved cached room chat data');
        return _parseRoomChatResponse(response.data!);
      }
    } catch (e) {
      logger.w('No cached data available: $e');
    }
    return null;
  }

  /// Fetches room chat data from network
  Future<List<Message>> _fetchRoomChatFromNetwork(
    String roomId,
    int? page,
    int? limit,
  ) async {
    final response = await _dioClient.getWithCache<List<dynamic>>(
      EndPoint.roomHistory,
      queryParameters: _buildRoomChatQueryParams(roomId, page, limit),
      maxStale: const Duration(hours: 1),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    return _parseRoomChatResponse(response.data ?? []);
  }

  /// Attempts to get room member data from cache
  Future<RoomInfoModel?> _getCachedRoomMember(String groupId) async {
    try {
      final response = await _dioClient.getWithCache<Map<String, dynamic>>(
        EndPoint.roomInfo,
        queryParameters: {"groupId": groupId},
        policy: CachePolicy.forceCache,
      );

      if (response.data != null) {
        logger.i('Successfully retrieved cached room member data');
        return RoomInfoModel.fromJson(response.data!);
      }
    } catch (e) {
      logger.w('No cached data available: $e');
    }
    return null;
  }

  /// Fetches room member data from network
  Future<RoomInfoModel> _fetchRoomMemberFromNetwork(String groupId) async {
    final response = await _dioClient.getWithCache<Map<String, dynamic>>(
      EndPoint.roomInfo,
      queryParameters: {"groupId": groupId},
      maxStale: const Duration(hours: 1),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    return RoomInfoModel.fromJson(response.data!);
  }

  /// Validates the response and throws appropriate exceptions
  void _validateResponse(Response response) {
    final statusCode = response.statusCode ?? 400;

    if (statusCode == 401) {
      logger.w('Unauthorized access');
      throw const ServerException(
        message: 'Your session has expired. Please login again.',
        statusCode: '401',
      );
    }

    if (statusCode != 200) {
      logger
          .e('Request failed. Status: $statusCode, Response: ${response.data}');
      throw ServerException(
        message: response.data?[0]?.toString() ??
            'Request failed. Please try again.',
        statusCode: statusCode.toString(),
      );
    }
  }

  /// Builds query parameters for room chat request
  Map<String, String> _buildRoomChatQueryParams(
    String roomId,
    int? page,
    int? limit,
  ) =>
      {
        "ChatRoomId": roomId,
        if (page != null) "page": page.toString(),
        if (limit != null) "limit": limit.toString(),
      };

  /// Parses the room chat response data
  List<Message> _parseRoomChatResponse(List<dynamic> data) {
    return data.map<Message>((item) {
      try {
        final message = Message.fromJson(item as Map<String, dynamic>);
        if (message.message.isNotEmpty) {
          return message.copyWith(
            message: message.message.decrypt(key: message.id),
          );
        }
        return message;
      } catch (e) {
        logger.e('Error parsing room chat item: $e, Data: $item');
        rethrow;
      }
    }).toList();
  }
}
