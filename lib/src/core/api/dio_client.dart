import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/hive_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/device_id.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

import '../../constants/end_point.dart';
import '../local_storage/local_storage_key.dart';

/// A singleton class that manages HTTP requests using Dio.
/// Handles authentication, logging, and error handling.
@singleton
class DioClient {
  /// The Dio instance used for making HTTP requests
  late final Dio _dio;

  /// The Hive interface for token storage
  final HiveInterface _hiveAuth;

  /// Creates a new instance of DioClient
  ///
  /// [hiveAuth] is used for token storage
  DioClient(this._hiveAuth) {
    _dio = _createDioInstance();
    _setupInterceptors();
  }

  /// Creates and configures the Dio instance with base options
  Dio _createDioInstance() {
    return Dio(
      BaseOptions(
        baseUrl: EndPoint.apiUrl,
        connectTimeout: const Duration(seconds: 600),
        receiveTimeout: const Duration(seconds: 600),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  /// Sets up all interceptors for the Dio instance
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      _AuthInterceptor(this),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Makes a GET request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: _addCultureParameter(queryParameters),
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a POST request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [data] is the request body
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: _addCultureParameter(queryParameters),
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a PUT request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [data] is the request body
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: _addCultureParameter(queryParameters),
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a PATCH request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [data] is the request body
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: _addCultureParameter(queryParameters),
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a DELETE request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [data] is the request body
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: _addCultureParameter(queryParameters),
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Adds the culture parameter to query parameters if not present
  Map<String, dynamic> _addCultureParameter(
      Map<String, dynamic>? queryParameters) {
    queryParameters ??= {};
    queryParameters.putIfAbsent(
      "culture",
      () => AppLocalStorage.currentLanguageCode,
    );
    return queryParameters;
  }

  /// Gets the current user token, refreshing it if necessary
  ///
  /// Returns the current valid token or throws an exception if token is invalid
  Future<String?> getUserToken() async {
    try {
      await _ensureTokenBoxOpen();

      final token = _getStoredToken();
      if (token == null) {
        logger.e('No token found in storage');
        return null;
      }

      if (_isExpiredToken(token.accessToken) ||
          _isTokenExpiringSoon(token.accessToken)) {
        return await _refreshToken(token);
      }

      return token.accessToken;
    } catch (e) {
      logger.e('Error getting valid token: $e');
      return null;
    }
  }

  /// Ensures the token box is open
  Future<void> _ensureTokenBoxOpen() async {
    if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
      await _hiveAuth.openBox(LocalStorageKey.token);
    }
    if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
      await _hiveAuth.openBox(LocalStorageKey.token);
    }
  }

  /// Gets the stored token
  UserTokenModel? _getStoredToken() {
    return _hiveAuth.box(LocalStorageKey.token).get(LocalStorageKey.userToken);
  }

  /// Checks if a token is expired
  bool _isExpiredToken(String token) {
    try {
      final payload = jwtDecode(token).payload;
      final expiredTime = payload['exp'] as int;
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      return currentTimestamp ~/ 1000 > expiredTime;
    } catch (e) {
      logger.e('Error checking token expiration: $e');
      return true;
    }
  }

  /// Checks if a token is about to expire (within 2 minutes)
  bool _isTokenExpiringSoon(String token) {
    try {
      final payload = jwtDecode(token).payload;
      final expiredTime = payload['exp'] as int;
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      return (expiredTime - (currentTimestamp ~/ 1000)) < 120;
    } catch (e) {
      logger.e('Error checking if token is expiring soon: $e');
      return false;
    }
  }

  /// Refreshes the token using the refresh token
  Future<String?> _refreshToken(UserTokenModel token) async {
    try {
      var deviceId = await DeviceId.getUniqueDeviceId();

      final response = await post(
        EndPoint.authRefreshToken,
        data: {"refreshToken": token.refreshToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
            'User-Agent': deviceId,
          },
        ),
      );

      if (response.statusCode == 200) {
        try {
          final newToken = UserTokenModel.fromMap(response.data!);
          await _saveToken(newToken);
          return newToken.accessToken;
        } catch (e) {
          logger.e('Error parsing refresh token response: $e');
          throw FormatException('Failed to parse refresh token response');
        }
      }

      if (response.statusCode == 401) {
        logger.w('Refresh token expired or invalid');
        await _clearToken();
        return null;
      }

      logger.e('Failed to refresh token: ${response.statusCode}');
      return token.accessToken; // Return old token if refresh fails
    } catch (e) {
      logger.e('Error during token refresh: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        await _clearToken();
      }
      return token.accessToken; // Return old token if refresh fails
    }
  }

  /// Saves a token to storage
  Future<void> _saveToken(UserTokenModel token) async {
    await _hiveAuth
        .box(LocalStorageKey.token)
        .put(LocalStorageKey.userToken, token);
  }

  /// Clears the token and redirects to login
  Future<void> _clearToken() async {
    try {
      HiveProvider.clearToken(
          () => AppRoute.getStarted.go(navigatorKey.currentContext!));
    } catch (e) {
      logger.e('Error clearing token: $e');
    }
  }
}

/// Interceptor that handles authentication
class _AuthInterceptor extends Interceptor {
  final DioClient _dioClient;

  _AuthInterceptor(this._dioClient);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_isAuthEndpoint(options.path)) {
        handler.next(options);
        return;
      }

      final token = await _dioClient.getUserToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['User-Agent'] = await DeviceId.getUniqueDeviceId();
      }
      handler.next(options);
    } catch (e) {
      logger.e('Error in auth interceptor: $e');
      if (e is UnauthorizedException || e is ServerException) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: e,
          ),
        );
      } else {
        handler.next(options);
      }
    }
  }

  /// Checks if the endpoint is an authentication endpoint
  bool _isAuthEndpoint(String path) {
    return path.contains(EndPoint.authSignIn) ||
        path.contains(EndPoint.authSignUp) ||
        path.contains(EndPoint.authRefreshToken) ||
        path.contains(EndPoint.authSignInTwoFactor) ||
        path.contains(EndPoint.authSignUpVerifyEmail);
  }
}

/// Interceptor that handles logging
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    super.onError(err, handler);
  }
}

/// Interceptor that handles error responses
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException(
          message: 'Connection timeout',
          statusCode: err.response?.statusCode?.toString() ?? '408',
        );
      case DioExceptionType.connectionError:
        throw ServerException(
          message:
              'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng của bạn.',
          statusCode: '500',
        );
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;
      case DioExceptionType.cancel:
        break;
      default:
        if (err.error?.toString().contains('Failed host lookup') ?? false) {
          throw ServerException(
            message:
                'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng của bạn.',
            statusCode: '500',
          );
        }
        throw ServerException(
          message: err.message ?? 'Unknown error',
          statusCode: err.response?.statusCode?.toString() ?? '500',
        );
    }
    super.onError(err, handler);
  }

  /// Handles bad response errors with specific status codes
  void _handleBadResponse(DioException err) {
    final message = err.response?.data?['message']?.toString() ?? '';
    final statusCode = err.response?.statusCode;

    switch (statusCode) {
      case 400:
        throw BadRequestException(
          message: message.isNotEmpty ? message : 'Bad request',
          statusCode: statusCode?.toString() ?? '400',
        );
      case 401:
        throw UnauthorizedException(
          message: message.isNotEmpty ? message : 'Unauthorized',
          statusCode: statusCode?.toString() ?? '401',
        );
      case 403:
        throw ForbiddenException(
          message: message.isNotEmpty ? message : 'Forbidden',
          statusCode: statusCode?.toString() ?? '403',
        );
      case 404:
        throw NotFoundException(
          message: message.isNotEmpty ? message : 'Not found',
          statusCode: statusCode?.toString() ?? '404',
        );
      case 500:
        throw ServerException(
          message: message.isNotEmpty ? message : 'Server error',
          statusCode: statusCode?.toString() ?? '500',
        );
      default:
        throw ServerException(
          message: message.isNotEmpty ? message : 'Unknown error',
          statusCode: statusCode?.toString() ?? '500',
        );
    }
  }
}
