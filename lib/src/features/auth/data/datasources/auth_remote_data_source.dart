import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hubtsocial_mobile/src/core/configs/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hubtsocial_mobile/src/core/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/api_request.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

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

  Future<void> forgotPassword({required String usernameOrEmail});
}

@LazySingleton(
  as: AuthRemoteDataSource,
)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required HiveInterface hiveAuth,
    required SharedPreferences prefs,
    required FirebaseMessaging messaging,
  })  : _hiveAuth = hiveAuth,
        _messaging = messaging;

  final HiveInterface _hiveAuth;
  final FirebaseMessaging _messaging;

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

      var responseData = SignInResponseModel.fromJson(response.body);
      if (response.statusCode != 200) {
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      if (!responseData.requiresTwoFactor! && responseData.userToken != null) {
        if (!await _hiveAuth.boxExists('token')) {
          await _hiveAuth.openBox('token');
        }
        if (!_hiveAuth.isBoxOpen('token')) {
          await _hiveAuth.openBox('token');
        }
        var token = responseData.userToken;
        var tokenBox = _hiveAuth.box('token');
        await tokenBox.put('userToken', token);
        logInfo('Sign in token : $token');

        // if (tokenBox.containsKey('fcmToken')) {
        //   String fcmToken = tokenBox.get('fcmToken');
        //   final response = await APIRequest.post(
        //     // url: ApiConstants.devicesEndpoint,
        //     url: EndPoint.apiUrl,
        //     body: {
        //       'token': fcmToken,
        //     },
        //     token: token.accessToken,
        //   );

        //   logInfo('Devices response : $response');
        // } else {
        //   _messaging.getToken().then((value) async {
        //     await tokenBox.put('fcmToken', value);
        //     await APIRequest.post(
        //       // url: ApiConstants.devicesEndpoint,
        //       url: EndPoint.apiUrl,

        //       body: {
        //         'token': value,
        //       },
        //       token: token.accessToken,
        //     );
        //   });
        // }
      }

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      debugPrintStack(stackTrace: s);
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
    logInfo('phone number :$userName, name: $email, password: $password');
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
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      logDebug(s.toString());
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
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
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
      if (!await _hiveAuth.boxExists('token')) {
        await _hiveAuth.openBox('token');
      }
      if (!_hiveAuth.isBoxOpen('token')) {
        await _hiveAuth.openBox('token');
      }

      var tokenBox = _hiveAuth.box('token');

      if (tokenBox.containsKey('fcmToken')) {
        String fcmToken = tokenBox.get('fcmToken');
        var response = await APIRequest.delete(
          // url: ApiConstants.devicesEndpoint,
          url: EndPoint.apiUrl,
          body: {
            'token': fcmToken,
          },
          token: userToken.accessToken,
        );
        logDebug('Devices response : ${response.body.toString()}');
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
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
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      if (!await _hiveAuth.boxExists('token')) {
        await _hiveAuth.openBox('token');
      }
      if (!_hiveAuth.isBoxOpen('token')) {
        await _hiveAuth.openBox('token');
      }
      var token = responseData.userToken;
      var tokenBox = _hiveAuth.box('token');
      await tokenBox.put('userToken', token);
      logInfo('Sign in token : $token');

      // if (tokenBox.containsKey('fcmToken')) {
      //   String fcmToken = tokenBox.get('fcmToken');
      //   final response = await APIRequest.post(
      //     // url: ApiConstants.devicesEndpoint,
      //     url: EndPoint.apiUrl,
      //     body: {
      //       'token': fcmToken,
      //     },
      //     token: token.accessToken,
      //   );

      //   logInfo('Devices response : $response');
      // } else {
      //   _messaging.getToken().then((value) async {
      //     await tokenBox.put('fcmToken', value);
      //     await APIRequest.post(
      //       // url: ApiConstants.devicesEndpoint,
      //       url: EndPoint.apiUrl,

      //       body: {
      //         'token': value,
      //       },
      //       token: token.accessToken,
      //     );
      //   });
      // }

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      debugPrintStack(stackTrace: s);
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
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: responseData.message.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      if (!await _hiveAuth.boxExists('token')) {
        await _hiveAuth.openBox('token');
      }
      if (!_hiveAuth.isBoxOpen('token')) {
        await _hiveAuth.openBox('token');
      }
      var token = responseData.userToken;
      var tokenBox = _hiveAuth.box('token');
      await tokenBox.put('userToken', token);
      logInfo('Sign in token : $token');

      // if (tokenBox.containsKey('fcmToken')) {
      //   String fcmToken = tokenBox.get('fcmToken');
      //   final response = await APIRequest.post(
      //     // url: ApiConstants.devicesEndpoint,
      //     url: EndPoint.apiUrl,
      //     body: {
      //       'token': fcmToken,
      //     },
      //     token: token.accessToken,
      //   );

      //   logInfo('Devices response : $response');
      // } else {
      //   _messaging.getToken().then((value) async {
      //     await tokenBox.put('fcmToken', value);
      //     await APIRequest.post(
      //       // url: ApiConstants.devicesEndpoint,
      //       url: EndPoint.apiUrl,

      //       body: {
      //         'token': value,
      //       },
      //       token: token.accessToken,
      //     );
      //   });
      // }

      return responseData;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> forgotPassword({required String usernameOrEmail}) async {
    try {
      final response = await APIRequest.post(
        url: EndPoint.authForgotPassword,
        body: {
          'usernameOrEmail': usernameOrEmail,
        },
      );

      if (response.statusCode != 200) {
        logError('Could not finalize api due to: ${response.body.toString()}');
        throw ServerException(
          message: response.body.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      return;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      logError(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: 'Please try again later',
        statusCode: '505',
      );
    }
  }
}
