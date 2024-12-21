import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

import '../../../logger/logger.dart';
import '../../api_request.dart';

class AuthorizationInterceptor extends Interceptor {
  get Fluttertoast => null;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      UserToken userToken = await APIRequest.getUserToken(Hive);
      options.headers.addAll(
          {HttpHeaders.authorizationHeader: "Bearer ${userToken.accessToken}"});
      handler.next(options);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // final errorMessage = DioException.fromDioError(err).toString();

    // print('---cvcxvcxvcx' + errorMessage);

    /*  Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );*/

    super.onError(err, handler);
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET') {
      return false;
    } else {
      return true;
    }
  }
}
