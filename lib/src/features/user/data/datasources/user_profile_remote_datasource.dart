import 'dart:io';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/dio_client.dart';
import '../../../../core/api/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserProfileRemoteDataSource {
  const UserProfileRemoteDataSource();

  Future<UserModel> initUserProfile();

  Future<UserModel> getUserByUsername({
    required String userName,
  });

  Future<void> updateUserName({
    // required String userId,
    required String firstName,
    required String lastName,
  });

  Future<void> updateUserAvatar({
    required File newImage,
  });

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

@LazySingleton(
  as: UserProfileRemoteDataSource,
)
class UserProfileRemoteDataSourceImpl extends UserProfileRemoteDataSource {
  const UserProfileRemoteDataSourceImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<UserModel> initUserProfile() async {
    try {
      logger.i('Initializing user profile');

      final response = await _dioClient.get<Map<String, dynamic>>(
        EndPoint.userGetUser,
      );

      if (response.statusCode != 200) {
        logger.e(
          'Failed to get user profile. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to get user profile. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      if (response.data == null) {
        logger.e('Empty response received for user profile');
        throw const ServerException(
          message: 'Invalid user profile data received from server.',
          statusCode: '400',
        );
      }

      final userProfile = UserModel.fromMap(response.data!);
      logger.i('Successfully fetched user profile');
      return userProfile;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while getting user profile: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to get user profile. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<UserModel> getUserByUsername({required String userName}) async {
    try {
      logger.i('Get user profile');

      final response = await _dioClient.get<Map<String, dynamic>>(
        EndPoint.userGetUser,
        queryParameters: {
          'userName': userName,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
          'Failed to get user profile. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to get user profile. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      if (response.data == null) {
        logger.e('Empty response received for user profile');
        throw const ServerException(
          message: 'Invalid user profile data received from server.',
          statusCode: '400',
        );
      }

      final userProfile = UserModel.fromMap(response.data!);
      logger.i('Successfully fetched user profile');
      return userProfile;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while getting user profile: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to get user profile. Please try again later.',
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateUserName({
    // required String userId,
    required String firstName,
    required String lastName,
  }) async {
    try {
      //  logger.i('Updating user name for userId: $userId');

      final response = await _dioClient.put<dynamic>(
        EndPoint.uptateName,
        data: {
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
          'Failed to update user name. Status: ${response.statusCode}, Response: ${response.data}',
        );
        // Handle both String and Map response data for error message
        String? errorMessage;
        if (response.data is String) {
          errorMessage = response.data.toString();
        } else if (response.data is Map) {
          errorMessage = response.data?['message']?.toString() ??
              'Failed to update user name. Please try again.';
        } else {
          errorMessage =
              'Failed to update user name. Unexpected response format.';
        }

        throw ServerException(
          message: errorMessage ?? 'An unknown error occurred',
          statusCode: response.statusCode?.toString() ?? 'Unknown',
        );
      } else {
        logger.i('Successfully updated user name');
        return;
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e, s) {
      // Create a detailed log message for Dio errors
      final logMessage =
          'Dio error while updating user name: \n  Type: ${e.type}\n  Message: ${e.message ?? 'No message'}${e.response != null ? '\n  Response Status: ${e.response?.statusCode}' : ''}${e.response != null ? '\n  Response Data: ${e.response?.data}' : ''}${e.error != null ? '\n  Original Error: ${e.error}' : ''}';

      logger.e(logMessage, error: e, stackTrace: s);

      // Determine the user-friendly error message and status code
      String? errorMessage;
      String? statusCode;

      if (e.response != null) {
        // Handle errors with a response from the server (e.g., 400, 401, 404, 500)
        statusCode = e.response?.statusCode?.toString() ?? 'Unknown';
        // Try to get message from response data, fallback to Dio message or generic
        if (e.response?.data is Map) {
          errorMessage = e.response?.data?['message']?.toString() ??
              e.message ??
              'Server responded with an error.';
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data.toString();
        } else {
          errorMessage =
              e.message ?? 'Server responded with an error (unknown format).';
        }
      } else {
        // Handle Dio errors without a response (e.g., network issues, timeouts, cancellations)
        statusCode = 'NetworkError'; // Custom status for network/client errors
        errorMessage = e.message ??
            'Request failed or network error.'; // Use Dio message or generic
        // Add more specific messages based on e.type if needed
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Connection timed out.';
        } else if (e.type == DioExceptionType.cancel) {
          errorMessage = 'Request was cancelled.';
        } else if (e.type == DioExceptionType.unknown) {
          // For DioErrorType.DEFAULT
          errorMessage = e.error?.toString() ??
              'An unknown error occurred during the request.'; // Use original error if available
        }
      }

      // Ensure errorMessage and statusCode are not null before throwing
      throw ServerException(
        message: errorMessage ?? 'An unknown error occurred',
        statusCode: statusCode ?? 'Unknown',
      );
    } catch (e, s) {
      logger.e('Unexpected error while updating user name: $e',
          error: e, stackTrace: s);
      throw const ServerException(
        message:
            'Failed to update user name. An unexpected client-side error occurred.',
        statusCode: 'ClientError', // Differentiate from server/network errors
      );
    }
  }

  @override
  Future<void> updateUserAvatar({
    required File newImage,
  }) async {
    try {
      // logger.i('Updating user avatar for userId: $userId');

      String fileName = newImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(newImage.path, filename: fileName),
      });

      final response = await _dioClient.put<Map<String, dynamic>>(
        EndPoint.updateAvatar,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        logger.e(
          'Failed to update user avatar. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to update user avatar. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      logger.i('Successfully updated user avatar');
      return;
    } on DioException catch (e, s) {
      logger.e('Dio error while updating user avatar: ${e.message}');
      logger.d('Stack trace: $s');
      if (e.response != null) {
        throw ServerException(
          message: e.response?.data?['message']?.toString() ??
              e.message ??
              'Failed to update user avatar.',
          statusCode: e.response?.statusCode?.toString() ?? 'Unknown',
        );
      } else {
        throw ServerException(
          message: e.message ?? 'Failed to update user avatar.',
          statusCode: 'Unknown',
        );
      }
    } catch (e, s) {
      logger.e('Unexpected error while updating user avatar: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to update user avatar. Please try again later.',
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
    // This method might not be needed anymore if name and avatar updates are separate.
    // I'll keep it for now, but its implementation might need adjustment or it could be removed
    // if not used elsewhere.
    logger.w(
        'updateUserProfile method is called. Consider using separate methods.');
    // Placeholder implementation or throw an error if this combination is not supported.
    throw UnimplementedError(
        'updateUserProfile is not implemented for combined updates.');
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      logger.i('Changing password');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '${EndPoint.apiUrl}/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 400) {
        logger.w('Invalid password provided');
        throw const ServerException(
          message: 'Your current password is incorrect.',
          statusCode: '400',
        );
      }

      if (response.statusCode != 200) {
        logger.e(
          'Failed to change password. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to change password. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      logger.i('Successfully changed password');
      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while changing password: $e');
      logger.d('Stack trace: $s');
      throw const ServerException(
        message: 'Failed to change password. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
