import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/user/data/gender.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

import '../../../../core/app/providers/hive_provider.dart';
import '../../../../core/local_storage/local_storage_key.dart';
import '../../../../router/route.dart';
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
  }) : _hiveAuth = hiveAuth;

  final HiveInterface _hiveAuth;

  @override
  Future<SignInResponseModel> twoFactorPassword(
      {required String otpPassword}) async {
    try {
      final response = await APIRequest.post(
        url: EndPoint.twoFactorPassword,
        body: {'otpPassword': otpPassword},
      );

      var responseData = SignInResponseModel.fromJson(response.body);
      if (response.statusCode != 200) {
        logger.e(
            'Failed to verify OTP password: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

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
      final response = await APIRequest.post(
        url: EndPoint.authVerifyPassword,
        body: {
          'postcode': postcode,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Failed to verify password: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode.toString(),
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
      final response = await APIRequest.post(
        url: EndPoint.authSignIn,
        body: {
          'userName': userName,
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      var responseData = SignInResponseModel.fromJson(response.body);
      var token = responseData.userToken;
      final responseFcm = await APIRequest.put(
        url: EndPoint.updateFcmToken,
        token: token?.accessToken,
        body: {"fcmToken": await FirebaseMessaging.instance.getToken()},
      );

      if (responseFcm.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${responseFcm.statusCode}:  ${responseFcm.body.toString()}');
        throw ServerException(
          message: responseFcm.body.toString(),
          statusCode: responseFcm.statusCode.toString(),
        );
      }
      if (!responseData.requiresTwoFactor! && responseData.userToken != null) {
        if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
          await _hiveAuth.openBox(LocalStorageKey.token);
        }
        if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
          await _hiveAuth.openBox(LocalStorageKey.token);
        }
        var tokenBox = _hiveAuth.box(LocalStorageKey.token);
        await tokenBox.put(LocalStorageKey.userToken, token);
        logger.i('Sign in token : $token');
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
      final response = await APIRequest.post(
        url: EndPoint.authSignUp,
        body: {
          "userName": userName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
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
      final response = await APIRequest.post(
        url: '${EndPoint.apiUrl}/reset-password',
        body: {
          'newPassword': newPassword,
        },
        token: token,
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
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
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      var response = await APIRequest.delete(
        url: EndPoint.authDeleteToken,
        token: userToken.accessToken,
      );
      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}:  ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }
      HiveProvider.clearToken(
          () => AppRoute.getStarted.go(navigatorKey.currentContext!));
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
      final response = await APIRequest.post(
        url: EndPoint.authSignInTwoFactor,
        body: {
          'postcode': postcode,
        },
      );

      var responseData = SignInResponseModel.fromJson(response.body);
      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

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
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final responseFcm = await APIRequest.put(
        url: EndPoint.updateFcmToken,
        token: userToken.accessToken,
        body: {"fcmToken": await FirebaseMessaging.instance.getToken()},
      );

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
      final response = await APIRequest.post(
        url: EndPoint.authSignUpVerifyEmail,
        body: {
          'postcode': postcode,
        },
      );

      var responseData = SignInResponseModel.fromJson(response.body);
      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      var token = responseData.userToken;
      final responseFcm = await APIRequest.put(
        url: EndPoint.updateFcmToken,
        token: token?.accessToken,
        body: {"fcmToken": await FirebaseMessaging.instance.getToken()},
      );
      if (responseFcm.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${responseFcm.statusCode}:  ${responseFcm.body.toString()}');
        throw ServerException(
          message: responseFcm.body.toString(),
          statusCode: responseFcm.statusCode.toString(),
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
      final response = await APIRequest.post(
        url: EndPoint.authForgotPassword,
        body: {
          'usernameOrEmail': usernameOrEmail,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }
      var responseData = ForgotPasswordResponseModel.fromJson(response.body);

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
      final response = await APIRequest.put(
        url: EndPoint.authSetNewPassword,
        body: {
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
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
      UserToken userToken = await APIRequest.getUserToken(_hiveAuth);

      final response = await APIRequest.put(
        url: EndPoint.informationUser,
        token: userToken.accessToken,
        body: {
          "firstName": firstName,
          "lastName": lastName,
          "phoneNumber": phoneNumber,
          "gender": gender.index,
          "dateOfBirth": birthOfDate.toIso8601String()
        },
      );

      if (response.statusCode != 200) {
        logger.e(
            'Could not finalize api due to: statusCode: ${response.statusCode}: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
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
