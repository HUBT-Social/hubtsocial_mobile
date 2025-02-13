import 'dart:convert';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../../constants/end_point.dart';
import '../local_storage/local_storage_key.dart';

class APIRequest {
  static Future<http.Response> post(
      {required String url,
      required Map<String, dynamic>? body,
      String? token}) async {
    logger.d(jsonEncode(body).toString());

    final response = await http.post(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
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

  static Future<http.Response> patch(
      {required String url, Map<String, dynamic>? body, String? token}) async {
    logger.d(jsonEncode(body).toString());
    final response = await http.patch(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
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
    required Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await http.put(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
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
  }) async {
    final response = await http.get(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
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
  }) async {
    final response = await http.delete(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
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
        .subtract(const Duration(minutes: 0))
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
        var tokenBox = Hive.box(LocalStorageKey.token);
        tokenBox.clear();
      }

      if (response.statusCode != 200) {
        logger.e(response.body);
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
