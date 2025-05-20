import 'dart:io';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:injectable/injectable.dart';

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
  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String email,
    required String avatarUrl,
    required File? newImage,
  }) async {
    try {
      logger.i('Updating user profile for userId: $userId');

      // TODO: Implement image upload if needed
      // if (newImage != null) {
      //   final ref = _dbClient.ref().child('profile_pics/$userId.png');
      //   await ref.putFile(newImage);
      //   avatarUrl = await ref.getDownloadURL();
      // }

      final response = await _dioClient.put<Map<String, dynamic>>(
        '${EndPoint.apiUrl}/profile',
        data: {
          'fullName': fullName,
          'email': email,
          'avatarUrl': avatarUrl,
        },
      );

      if (response.statusCode == 401) {
        logger.w('Unauthorized access while updating profile');
        throw const ServerException(
          message: 'Your session has expired. Please login again.',
          statusCode: '401',
        );
      }

      if (response.statusCode == 400) {
        logger.w('Invalid profile data provided');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Invalid profile information provided.',
          statusCode: '400',
        );
      }

      if (response.statusCode != 200) {
        logger.e(
          'Failed to update profile. Status: ${response.statusCode}, Response: ${response.data}',
        );
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to update profile. Please try again.',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      logger.i('Successfully updated user profile');
      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e('Unexpected error while updating profile: $e');
      logger.d('Stack trace: $s');
      throw ServerException(
        message: 'Failed to update profile. Please try again later.',
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
