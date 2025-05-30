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

      if (response.statusCode == 401) {
        logger.w('Unauthorized access to user profile');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

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
      throw ServerException(
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

      final response = await _dioClient.put<Map<String, dynamic>>(
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
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to update user name. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      logger.i('Successfully updated user name');
      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while updating user name: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to update user name. Please try again later.',
        statusCode: '500',
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
      throw ServerException(
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

      if (response.statusCode == 401) {
        logger.w('Unauthorized access while changing password');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

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
      throw ServerException(
        message: 'Failed to change password. Please try again later.',
        statusCode: '500',
      );
    }
  }
}
