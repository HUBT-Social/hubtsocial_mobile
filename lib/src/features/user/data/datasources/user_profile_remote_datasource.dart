import 'dart:io';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/dio_client.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserProfileRemoteDataSource {
  const UserProfileRemoteDataSource();

  Future<UserModel> initUserProfile();

  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String email,
    required String avatarUrl,
    required File? newImage,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

@LazySingleton(as: UserProfileRemoteDataSource)
class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  const UserProfileRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<UserModel> initUserProfile() async {
    try {
      logger.i('Initializing user profile');

      // Try to get data from cache first
      final cachedData = await _getCachedUserProfile();
      if (cachedData != null) {
        logger.i('Using cached user profile data');
        return cachedData;
      }

      // If no cache, try network request
      return await _fetchUserProfileFromNetwork();
    } on DioException catch (e) {
      logger.e('Network error while fetching user profile: ${e.message}');
      logger.d('Error type: ${e.type}, Error: ${e.error}');

      // Handle specific connection errors
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        // Try to get cached data as fallback
        final cachedData = await _getCachedUserProfile();
        if (cachedData != null) {
          logger.i('Using cached user profile data after connection error');
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
        message: e.message ??
            'Failed to fetch user profile. Please try again later.',
        statusCode: e.response?.statusCode?.toString() ?? '500',
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while fetching user profile: $e');
      logger.d('Stack trace: $s');

      // Final attempt to get cached data
      final cachedData = await _getCachedUserProfile();
      if (cachedData != null) {
        logger.i('Using cached user profile data after error');
        return cachedData;
      }

      throw ServerException(
        message: 'Failed to fetch user profile. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String email,
    required String avatarUrl,
    required File? newImage,
  }) async {
    try {
      logger.i('Updating user profile for userId: $userId');

      final formData = await _buildUpdateProfileFormData(
        userId: userId,
        fullName: fullName,
        email: email,
        avatarUrl: avatarUrl,
        newImage: newImage,
      );

      final response =
          await _dioClient.putAndInvalidateDefaultCache<Map<String, dynamic>>(
        '${EndPoint.apiUrl}/profile',
        data: formData,
      );

      _validateResponse(response);
      logger.i('Successfully updated user profile');
    } on DioException catch (e) {
      logger.e('Network error while updating user profile: ${e.message}');
      logger.d('Error type: ${e.type}, Error: ${e.error}');

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        throw ServerException(
          message:
              'Unable to connect to the server. Please check your internet connection.',
          statusCode: '0',
        );
      }

      throw ServerException(
        message: e.message ??
            'Failed to update user profile. Please try again later.',
        statusCode: e.response?.statusCode?.toString() ?? '500',
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Error updating user profile: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to update user profile. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      logger.i('Changing password');

      final response = await _dioClient.put<Map<String, dynamic>>(
        '${EndPoint.apiUrl}/profile/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      _validateResponse(response);
      logger.i('Successfully changed password');
    } on DioException catch (e) {
      logger.e('Network error while changing password: ${e.message}');
      logger.d('Error type: ${e.type}, Error: ${e.error}');

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        throw ServerException(
          message:
              'Unable to connect to the server. Please check your internet connection.',
          statusCode: '0',
        );
      }

      throw ServerException(
        message:
            e.message ?? 'Failed to change password. Please try again later.',
        statusCode: e.response?.statusCode?.toString() ?? '500',
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Error changing password: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to change password. Please try again later.',
        statusCode: '500',
      );
    }
  }

  /// Attempts to get user profile data from cache
  Future<UserModel?> _getCachedUserProfile() async {
    try {
      final response = await _dioClient.getWithCache<Map<String, dynamic>>(
        EndPoint.userGetUser,
        policy: CachePolicy.forceCache,
      );

      if (response.data != null) {
        logger.i('Successfully retrieved cached user profile data');
        return UserModel.fromMap(response.data!);
      }
    } catch (e) {
      logger.w('No cached user profile data available: $e');
    }
    return null;
  }

  /// Fetches user profile data from network
  Future<UserModel> _fetchUserProfileFromNetwork() async {
    final response = await _dioClient.getWithCache<Map<String, dynamic>>(
      EndPoint.userGetUser,
      maxStale: const Duration(hours: 1),
      policy: CachePolicy.refreshForceCache,
    );

    _validateResponse(response);
    return UserModel.fromMap(response.data!);
  }

  /// Builds form data for profile update request
  Future<FormData> _buildUpdateProfileFormData({
    required String userId,
    required String fullName,
    required String email,
    required String avatarUrl,
    required File? newImage,
  }) async {
    final formData = FormData.fromMap({
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'avatarUrl': avatarUrl,
    });

    if (newImage != null) {
      formData.files.add(
        MapEntry(
          'newImage',
          await MultipartFile.fromFile(
            newImage.path,
            filename: newImage.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
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
