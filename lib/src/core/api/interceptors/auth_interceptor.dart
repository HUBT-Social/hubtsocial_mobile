import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';

/// Interceptor that handles authentication
class AuthInterceptor extends Interceptor {
  final HiveInterface _hiveAuth;
  final DioClient _dioClient;
  bool _isRefreshing = false;
  DateTime? _lastRefreshAttempt;
  Completer<UserTokenModel?>? _refreshCompleter;

  AuthInterceptor(this._hiveAuth, this._dioClient);

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

  /// Clears the token and redirects to the login screen
  Future<void> _clearToken() async {
    try {
      await _hiveAuth.box(LocalStorageKey.token).clear();
      if (navigatorKey.currentContext != null) {
        AppRoute.getStarted.go(navigatorKey.currentContext!);
      }
    } catch (e) {
      logger.e('Error clearing token: $e');
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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Disable cache for auth endpoints
      if (_isAuthEndpoint(options.path)) {
        options.extra['cache_options'] = CacheOptions(
          store: _dioClient.cacheManager.cacheStore,
          policy: CachePolicy.noCache,
        );
        handler.next(options);
        return;
      }

      final token = await _getValidToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
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

  /// Gets a valid token, refreshing if necessary
  Future<String?> _getValidToken() async {
    try {
      await _ensureTokenBoxOpen();

      final token = _getStoredToken();
      if (token == null) {
        logger.e('No token found in storage');
        return null;
      }

      if (_shouldRefreshToken(token)) {
        return await _handleTokenRefresh(token);
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

  /// Checks if the token should be refreshed
  bool _shouldRefreshToken(UserTokenModel token) {
    return _isExpiredToken(token.accessToken) ||
        _isTokenExpiringSoon(token.accessToken);
  }

  /// Handles token refresh with proper locking and error handling
  Future<String?> _handleTokenRefresh(UserTokenModel token) async {
    if (_isRefreshing && _refreshCompleter != null) {
      return await _waitForRefresh();
    }

    if (_isTooSoonToRefresh()) {
      return token.accessToken;
    }

    return await _startRefresh(token);
  }

  /// Waits for an ongoing refresh operation
  Future<String?> _waitForRefresh() async {
    try {
      final newToken = await _refreshCompleter!.future;
      return newToken?.accessToken;
    } catch (e) {
      logger.e('Error waiting for token refresh: $e');
      return null;
    }
  }

  /// Checks if it's too soon to attempt another refresh
  bool _isTooSoonToRefresh() {
    if (_lastRefreshAttempt == null) return false;
    return DateTime.now().difference(_lastRefreshAttempt!) <
        const Duration(seconds: 30);
  }

  /// Starts a new token refresh operation
  Future<String?> _startRefresh(UserTokenModel token) async {
    _isRefreshing = true;
    _lastRefreshAttempt = DateTime.now();
    _refreshCompleter = Completer<UserTokenModel?>();

    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        EndPoint.authRefreshToken,
        data: {"refreshToken": token.refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer ${token.accessToken}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = UserTokenModel.fromMap(response.data!);
        await _saveToken(newToken);
        _refreshCompleter?.complete(newToken);
        return newToken.accessToken;
      }

      return await _handleRefreshFailure(token);
    } catch (e) {
      return await _handleRefreshError(token, e);
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Handles refresh failure
  Future<String?> _handleRefreshFailure(UserTokenModel token) async {
    logger.e('Failed to refresh token');
    if (!_isExpiredToken(token.accessToken)) {
      _refreshCompleter?.complete(token);
      return token.accessToken;
    }
    _refreshCompleter?.completeError('Failed to refresh token');
    await _clearToken();
    return null;
  }

  /// Handles refresh error
  Future<String?> _handleRefreshError(
      UserTokenModel token, dynamic error) async {
    logger.e('Error refreshing token: $error');
    if (!_isExpiredToken(token.accessToken)) {
      _refreshCompleter?.complete(token);
      return token.accessToken;
    }
    _refreshCompleter?.completeError(error);
    await _clearToken();
    return null;
  }

  /// Saves a token to storage
  Future<void> _saveToken(UserTokenModel token) async {
    await _hiveAuth
        .box(LocalStorageKey.token)
        .put(LocalStorageKey.userToken, token);
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
}
