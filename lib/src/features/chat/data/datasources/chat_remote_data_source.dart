import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
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
    int? page,
    int? limit,
  });
}

@LazySingleton(
  as: ChatRemoteDataSource,
)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<ChatResponseModel>> fetchChat({
    int? page,
    int? limit,
  }) async {
    try {
      logger.i('Fetching chat list with page: $page, limit: $limit');

      // Try to get data from cache first
      final cachedData = await _getCachedChat(page, limit);
      if (cachedData != null) {
        logger.i('Using cached chat data');
        return cachedData;
      }

      // If no cache, try network request
      return await _fetchChatFromNetwork(page, limit);
    } on DioException catch (e) {
      logger.e('Network error while fetching chat list: ${e.message}');
      logger.d('Error type: ${e.type}, Error: ${e.error}');

      // Handle specific connection errors
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        // Try to get cached data as fallback
        final cachedData = await _getCachedChat(page, limit);
        if (cachedData != null) {
          logger.i('Using cached chat data after connection error');
          return cachedData;
        }

        throw ServerException(
          message:
              'Unable to connect to the server. Please check your internet connection.',
          statusCode: '0',
        );
      }

      // Handle other Dio errors
      throw ServerException(
        message:
            e.message ?? 'Failed to fetch chat list. Please try again later.',
        statusCode: e.response?.statusCode?.toString() ?? '500',
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching chat list: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedChat(page, limit);
      if (cachedData != null) {
        logger.i('Using cached chat data after error');
        return cachedData;
      }

      throw ServerException(
        message: 'Failed to fetch chat list. Please try again later.',
        statusCode: '500',
      );
    }
  }

  /// Attempts to get chat data from cache
  Future<List<ChatResponseModel>?> _getCachedChat(int? page, int? limit) async {
    try {
      final response = await _dioClient.getWithCache<List<dynamic>>(
        EndPoint.chatView,
        queryParameters: _buildQueryParams(page, limit),
        policy: CachePolicy.forceCache,
      );

      if (response.data != null) {
        logger.i('Successfully retrieved cached chat data');
        return _parseChatResponse(response.data!);
      }
    } catch (e) {
      logger.w('No cached chat data available: $e');
    }
    return null;
  }

  /// Fetches chat data from network
  Future<List<ChatResponseModel>> _fetchChatFromNetwork(
      int? page, int? limit) async {
    final response = await _dioClient.getWithCache<List<dynamic>>(
      EndPoint.chatView,
      queryParameters: _buildQueryParams(page, limit),
      maxStale: const Duration(hours: 1),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    return _parseChatResponse(response.data ?? []);
  }

  /// Builds query parameters for chat request
  Map<String, String> _buildQueryParams(int? page, int? limit) => {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      };

  /// Parses the chat response data
  List<ChatResponseModel> _parseChatResponse(List<dynamic> data) {
    return data.map<ChatResponseModel>((item) {
      try {
        return ChatResponseModel.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        logger.e('Error parsing chat item: $e, Data: $item');
        rethrow;
      }
    }).toList();
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
        message: response.data?['message']?.toString() ??
            'Request failed. Please try again.',
        statusCode: statusCode.toString(),
      );
    }
  }
}
