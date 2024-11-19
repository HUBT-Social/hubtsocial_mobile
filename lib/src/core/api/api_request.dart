import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:hubtsocial_mobile/src/core/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../configs/end_point.dart';

class APIRequest {
  static Future<http.Response> post(
      {required String url,
      required Map<String, dynamic>? body,
      String? token}) async {
    logDebug(jsonEncode(body).toString());

    final response = await http.post(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );

    logDebug(response.body);
    return response;
  }

  static Future<http.Response> patch(
      {required String url, Map<String, dynamic>? body, String? token}) async {
    logDebug(jsonEncode(body).toString());
    final response = await http.patch(
      Uri.parse(
        "$url?culture=${AppLocalStorage.currentLanguageCode}",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logDebug(response.body);
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
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logDebug(response.body);
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
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    );
    logDebug(response.body);
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
        'Authorization': token != null ? 'Bearer $token' : '',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    logDebug(response.toString());
    return response;
  }

  static bool isExpiredToken(String token) {
    var payload = jwtDecode(token).payload;
    int expiredTime = payload['exp'];
    var currentTimestamp = DateTime.now()
        .subtract(const Duration(minutes: 30))
        .millisecondsSinceEpoch;
    if (currentTimestamp ~/ 1000 > expiredTime) {
      return true;
    }
    return false;
  }

  static Future<UserTokenModel> getUserToken(HiveInterface hiveAuth) async {
    if (!await hiveAuth.boxExists('token')) {
      await hiveAuth.openBox('token');
    }
    if (!hiveAuth.isBoxOpen('token')) {
      await hiveAuth.openBox('token');
    }

    UserTokenModel token = hiveAuth.box('token').get('userToken');
    if (isExpiredToken(token.accessToken)) {
      final response = await APIRequest.post(
        url: '${EndPoint.apiUrl}/refresh',
        body: {
          'refreshToken': token.refreshToken,
        },
      );
      if (response.statusCode != 200) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: '401',
        );
      }
      var newToken = UserTokenModel.fromJson(response.body);
      await hiveAuth.box('token').put('userToken', newToken);
      return newToken;
    }
    return token;
  }
}
