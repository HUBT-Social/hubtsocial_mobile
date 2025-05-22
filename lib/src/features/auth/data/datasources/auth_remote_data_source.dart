import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';

import '../../../../core/local_storage/local_storage_key.dart';
import '../models/forgot_password_response_model.dart';
import '../models/sign_in_response_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<SignInResponseModel> signIn({
    required String userName,
    required String password,
  });

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<void> resetPassword({
    required String newPassword,
    required String token,
  });
  Future<void> signOut();
  Future<SignInResponseModel> twoFactor({required String postcode});
  Future<SignInResponseModel> verifyEmail({required String postcode});
  Future<SignInResponseModel> twoFactorPassword({required String otpPassword});
  Future<void> verifyPassword({required String postcode});
  Future<ForgotPasswordResponseModel> forgotPassword(
      {required String usernameOrEmail});
  Future<void> setNewPassword(
      {required String newPassword, required String confirmNewPassword});
  Future<void> informationUser(
      {required String firstName,
      required String lastName,
      required DateTime birthOfDate,
      required Gender gender,
      required String phoneNumber});
}

@LazySingleton(
  as: AuthRemoteDataSource,
)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required FirebaseMessaging messaging,
    required DioClient dioClient,
  })  : _hiveAuth = hiveAuth,
        _dioClient = dioClient;

  final HiveInterface _hiveAuth;
  final DioClient _dioClient;

  @override
  Future<SignInResponseModel> twoFactorPassword(
      {required String otpPassword}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.twoFactorPassword,
        data: {'otpPassword': otpPassword},
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to verify OTP password: statusCode: ${response.statusCode}:  ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to verify OTP password',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      var responseData = SignInResponseModel.fromMap(response.data!);
      if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }
      if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }

      var token = responseData.userToken;
      var tokenBox = _hiveAuth.box(LocalStorageKey.token);
      await tokenBox.put(LocalStorageKey.userToken, token);
      logger.i('Token saved successfully: $token');

      return responseData;
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

  @override
  Future<void> verifyPassword({required String postcode}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authVerifyPassword,
        data: {
          'postcode': postcode,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to verify password: statusCode: ${response.statusCode}:  ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to verify password',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Failed to verify email password. Please try again later.',
        statusCode: '505',
      );
    }
  }

  @override
  Future<SignInResponseModel> signIn({
    required String userName,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authSignIn,
        data: {
          'userName': userName,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ?? 'Failed to sign in',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      var responseData = SignInResponseModel.fromMap(response.data!);

      // Only store token if sign in is successful and doesn't require 2FA
      if (!responseData.requiresTwoFactor! && responseData.userToken != null) {
        try {
          if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
            await _hiveAuth.openBox(LocalStorageKey.token);
          }
          if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
            await _hiveAuth.openBox(LocalStorageKey.token);
          }
          var tokenBox = _hiveAuth.box(LocalStorageKey.token);
          await tokenBox.put(LocalStorageKey.userToken, responseData.userToken);
          logger.i('Sign in token stored successfully');
        } catch (e) {
          logger.e('Failed to store token: $e');
          // Continue even if token storage fails
        }

        // Update FCM token after successful sign in
        try {
          final responseFcm = await _dioClient.put<Map<String, dynamic>>(
            EndPoint.updateFcmToken,
            data: {"fcmToken": await FirebaseMessaging.instance.getToken()},
          );

          if (responseFcm.statusCode != 200) {
            logger.e(
                'Could not update FCM token: statusCode: ${responseFcm.statusCode}:  ${responseFcm.data}');
            // Continue even if FCM update fails
          }
        } catch (e) {
          logger.e('Failed to update FCM token: $e');
          // Continue even if FCM update fails
        }
      }

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    logger.i('phone number :$userName, name: $email, password: $password');
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authSignUp,
        data: {
          "userName": userName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ?? 'Failed to sign up',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Issue with the server',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String newPassword,
    required String token,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '${EndPoint.apiUrl}/reset-password',
        data: {
          'newPassword': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to reset password',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Issue with the server',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final userToken = await _dioClient.getUserToken();
      await _dioClient.delete<Map<String, dynamic>>(
        EndPoint.authDeleteToken,
      );
      await _hiveAuth.box(LocalStorageKey.token).clear();
      router.go(AppRoute.getStarted.path);
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Issue with the server',
        statusCode: '505',
      );
    }
  }

  @override
  Future<SignInResponseModel> twoFactor({required String postcode}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authSignInTwoFactor,
        data: {
          'postcode': postcode,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to verify two factor',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      var responseData = SignInResponseModel.fromMap(response.data!);
      if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }
      if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }
      var token = responseData.userToken;
      var tokenBox = _hiveAuth.box(LocalStorageKey.token);
      await tokenBox.put(LocalStorageKey.userToken, token);
      logger.i('Sign in token : $token');

      final responseFcm = await _dioClient.put<Map<String, dynamic>>(
        EndPoint.updateFcmToken,
        data: {"fcmToken": await FirebaseMessaging.instance.getToken()},
      );

      if (responseFcm.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${responseFcm.statusCode}:  ${responseFcm.data}');
        throw ServerException(
          message: responseFcm.data?['message']?.toString() ??
              'Failed to update FCM token',
          statusCode: responseFcm.statusCode?.toString() ?? '400',
        );
      }

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }

  @override
  Future<SignInResponseModel> verifyEmail({required String postcode}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authSignUpVerifyEmail,
        data: {
          'postcode': postcode,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.data}');
        throw ServerException(
          message:
              response.data?['message']?.toString() ?? 'Failed to verify email',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      var responseData = SignInResponseModel.fromMap(response.data!);
      var token = responseData.userToken;
      final responseFcm = await _dioClient.put<Map<String, dynamic>>(
        EndPoint.updateFcmToken,
        data: {"fcmToken": await FirebaseMessaging.instance.getToken()},
      );
      if (responseFcm.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${responseFcm.statusCode}:  ${responseFcm.data}');
        throw ServerException(
          message: responseFcm.data?['message']?.toString() ??
              'Failed to update FCM token',
          statusCode: responseFcm.statusCode?.toString() ?? '400',
        );
      }
      if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }
      if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
        await _hiveAuth.openBox(LocalStorageKey.token);
      }
      var tokenBox = _hiveAuth.box(LocalStorageKey.token);
      await tokenBox.put(LocalStorageKey.userToken, token);
      logger.i('Sign in token : $token');

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword(
      {required String usernameOrEmail}) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authForgotPassword,
        data: {
          'usernameOrEmail': usernameOrEmail,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to process forgot password request',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }
      var responseData = ForgotPasswordResponseModel.fromMap(response.data!);

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> setNewPassword(
      {required String newPassword, required String confirmNewPassword}) async {
    try {
      final response = await _dioClient.put<Map<String, dynamic>>(
        EndPoint.authSetNewPassword,
        data: {
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to set new password',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Issue with the server',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> informationUser(
      {required String firstName,
      required String lastName,
      required DateTime birthOfDate,
      required Gender gender,
      required String phoneNumber}) async {
    try {
      final response = await _dioClient.put<Map<String, dynamic>>(
        EndPoint.informationUser,
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "gender": gender.index,
          "dateOfBirth": birthOfDate.toIso8601String()
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.data}');
        throw ServerException(
          message: response.data?['message']?.toString() ??
              'Failed to update user information',
          statusCode: response.statusCode?.toString() ?? '400',
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logger.e(e.toString());
      logger.d(s.toString());
      throw const ServerException(
        message: 'Issue with the server',
        statusCode: '505',
      );
    }
  }
}
