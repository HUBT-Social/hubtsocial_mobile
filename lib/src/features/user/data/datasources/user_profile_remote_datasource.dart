import 'dart:io';
import 'package:hive_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/configs/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_request.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/domain/entities/user_token.dart';
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

  Future<void> changePassword(
      {required String oldPassword, required String newPassword});
}

@LazySingleton(
  as: UserProfileRemoteDataSource,
)
class UserProfileRemoteDataSourceImpl extends UserProfileRemoteDataSource {
  const UserProfileRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

  @override
  Future<UserModel> initUserProfile() async {
    try {
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.get(
        url: EndPoint.authGetUser,
        token: userToken.accessToken,
      );
      if (response.statusCode != 200) {
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode.toString(),
        );
      }
      return UserModel.fromJson(response.body);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      logDebug(s.toString());
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
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
    // try {
    //   if (newImage != null) {
    //     final ref = _dbClient.ref().child('profile_pics/$userId.png');

    //     await ref.putFile(newImage);
    //     avatarUrl = await ref.getDownloadURL();
    //   }

    //   UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

    //   final response = await APIRequest.put(
    //     url: '${ApiConstants.usersEndpoint}/profile',
    //     body: {
    //       'fullName': fullName,
    //       'email': email,
    //       'avatarUrl': avatarUrl,
    //     },
    //     token: userToken.accessToken,
    //   );
    //   if (response.statusCode != 200) {
    //     logger.e('Could not finalize api due to: ${response.body.toString()}');
    //     throw ServerException(
    //       message: response.body.toString(),
    //       statusCode: response.statusCode.toString(),
    //     );
    //   }
    //   return;
    // } on ServerException {
    //   rethrow;
    // } catch (e, s) {
    //   logger.e(e);
    //   debugPrintStack(stackTrace: s);
    //   throw const ServerException(
    //     message: 'Please try again later',
    //     statusCode: '505',
    //   );
    // }
  }

  @override
  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.post(
        url: '${EndPoint.apiUrl}/change-password',
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        token: userToken.accessToken,
      );
      if (response.statusCode != 200) {
        logError('Could not finalize api due to: ${response.body.toString()}');
        if (response.statusCode == 400) {
          throw ServerException(
            message: 'Your current password is incorrect',
            statusCode: response.statusCode.toString(),
          );
        } else {
          throw ServerException(
            message: response.body.toString(),
            statusCode: response.statusCode.toString(),
          );
        }
      }
      return;
    } on ServerException {
      rethrow;
    }
  }
}
