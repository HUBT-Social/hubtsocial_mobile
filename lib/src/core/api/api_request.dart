import 'dart:convert';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/hive_provider.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../../constants/end_point.dart';
import '../local_storage/local_storage_key.dart';

class APIRequest {
  static Future<http.Response> post({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters?.putIfAbsent(
        "culture", () => AppLocalStorage.currentLanguageCode);

    Map<String, String>? parameters =
        queryParameters?.map((key, value) => MapEntry(key, value.toString()));

    Uri uri = Uri.parse(url).replace(queryParameters: parameters);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': AppLocalStorage.uniqueDeviceId,
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    logger.d(response.body);
    return response;
  }

  static Future<http.Response> patch({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters?.putIfAbsent(
        "culture", () => AppLocalStorage.currentLanguageCode);

    Map<String, String>? parameters =
        queryParameters?.map((key, value) => MapEntry(key, value.toString()));

    Uri uri = Uri.parse(url).replace(queryParameters: parameters);

    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': AppLocalStorage.uniqueDeviceId,
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logger.d(response.body);
    return response;
  }

  static Future<http.Response> put({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters?.putIfAbsent(
        "culture", () => AppLocalStorage.currentLanguageCode);

    Map<String, String>? parameters =
        queryParameters?.map((key, value) => MapEntry(key, value.toString()));

    Uri uri = Uri.parse(url).replace(queryParameters: parameters);
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': AppLocalStorage.uniqueDeviceId,
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logger.d(response.body);
    return response;
  }

  static Future<http.Response> get({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters?.putIfAbsent(
        "culture", () => AppLocalStorage.currentLanguageCode);

    Map<String, String>? parameters =
        queryParameters?.map((key, value) => MapEntry(key, value.toString()));

    Uri uri = Uri.parse(url).replace(queryParameters: parameters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': AppLocalStorage.uniqueDeviceId,
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    );
    logger.d(response.body);
    return response;
  }

  static Future<http.Response> delete({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters?.putIfAbsent(
        "culture", () => AppLocalStorage.currentLanguageCode);

    Map<String, String>? parameters =
        queryParameters?.map((key, value) => MapEntry(key, value.toString()));

    Uri uri = Uri.parse(url).replace(queryParameters: parameters);

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': AppLocalStorage.uniqueDeviceId,
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logger.d(response.toString());
    return response;
  }

  static bool isExpiredToken(String token) {
    var payload = jwtDecode(token).payload;
    int expiredTime = payload['exp'];
    var currentTimestamp = DateTime.now()
        .subtract(const Duration(minutes: 15))
        .millisecondsSinceEpoch;
    if (currentTimestamp ~/ 1000 > expiredTime) {
      return true;
    }
    return false;
  }

  static Future<UserTokenModel> getUserToken(HiveInterface hiveAuth) async {
    if (!await hiveAuth.boxExists(LocalStorageKey.token)) {
      await hiveAuth.openBox(LocalStorageKey.token);
    }
    if (!hiveAuth.isBoxOpen(LocalStorageKey.token)) {
      await hiveAuth.openBox(LocalStorageKey.token);
    }

    UserTokenModel token =
        hiveAuth.box(LocalStorageKey.token).get(LocalStorageKey.userToken);
    if (isExpiredToken(token.accessToken)) {
      final response = await APIRequest.post(
        url: EndPoint.authRefreshToken,
        body: {
          "refreshToken": token.refreshToken,
        },
        token: token.accessToken,
      );

      if (response.statusCode == 401) {
        HiveProvider.clearToken(
            () => AppRoute.getStarted.go(navigatorKey.currentContext!));
        throw ServerException(
          message: response.statusCode.toString(),
          statusCode: response.statusCode.toString(),
        );
      }

      if (response.statusCode != 200) {
        logger.e("statusCode: ${response.statusCode}: ${response.body}");
        throw ServerException(
          message: response.statusCode.toString(),
          statusCode: response.statusCode.toString(),
        );
      }
      var newToken = UserTokenModel.fromJson(response.body);
      await hiveAuth
          .box(LocalStorageKey.token)
          .put(LocalStorageKey.userToken, newToken);
      return newToken;
    }
    return token;
  }
}
