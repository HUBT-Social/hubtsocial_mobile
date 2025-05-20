import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/extensions/device_id.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/models/user_token_model.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:hubtsocial_mobile/src/core/api/cache/cache_manager.dart';
import 'package:hubtsocial_mobile/src/core/api/interceptors/auth_interceptor.dart';
import 'package:hubtsocial_mobile/src/core/api/interceptors/error_interceptor.dart';
import 'package:hubtsocial_mobile/src/core/api/interceptors/logging_interceptor.dart';
import 'package:hubtsocial_mobile/src/core/api/methods/http_methods.dart';

import '../../constants/end_point.dart';
import '../local_storage/local_storage_key.dart';

/// A singleton class that manages HTTP requests using Dio.
/// Handles authentication, logging, and error handling.
@singleton
class DioClient with HttpMethods {
  /// The Dio instance used for making HTTP requests
  @override
  late final Dio dio;

  /// The Hive interface for token storage
  final HiveInterface _hiveAuth;

  /// The cache manager for managing cache
  @override
  late final CacheManager cacheManager;

  /// Creates a new instance of DioClient
  ///
  /// [hiveAuth] is used for token storage
  DioClient(this._hiveAuth) {
    // Initialize cache manager
    cacheManager = CacheManager();
    cacheManager.initializeSync();

    // Initialize Dio instance
    dio = _createDioInstance();

    // Initialize cache asynchronously and then setup interceptors
    _initializeCacheAndSetupInterceptors();
  }

  /// Initialize cache and setup interceptors
  Future<void> _initializeCacheAndSetupInterceptors() async {
    try {
      // Wait for cache initialization
      await cacheManager.initialize();

      // Setup interceptors after cache is initialized
      _setupInterceptors();

      logger.i('DioClient initialized successfully');
    } catch (e) {
      logger.e('Error initializing DioClient: $e');
      // Even if cache initialization fails, we still want to setup basic interceptors
      _setupBasicInterceptors();
    }
  }

  /// Setup basic interceptors without cache
  void _setupBasicInterceptors() {
    dio.interceptors.addAll([
      AuthInterceptor(_hiveAuth, this),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
    logger.w('Using basic interceptors without cache');
  }

  /// Sets up all interceptors for the Dio instance
  void _setupInterceptors() {
    if (!cacheManager.isInitialized) {
      logger.w('Cache not fully initialized, using basic interceptors');
      _setupBasicInterceptors();
      return;
    }

    dio.interceptors.addAll([
      AuthInterceptor(_hiveAuth, this),
      cacheManager.cacheInterceptor,
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
    logger.i('All interceptors setup successfully');
  }

  /// Creates and configures the Dio instance with base options
  Dio _createDioInstance() {
    return Dio(
      BaseOptions(
        baseUrl: EndPoint.apiUrl,
        connectTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': DeviceId.getUniqueDeviceId(),
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }

  /// Gets the current user token, refreshing it if expired
  ///
  /// Returns the current valid token or throws an exception if token is invalid
  Future<UserTokenModel> getUserToken() async {
    await _ensureTokenBoxOpen();

    final token = _getStoredToken();
    if (token == null) {
      throw UnauthorizedException(
        message: 'No token found',
        statusCode: '401',
      );
    }

    if (_isExpiredToken(token.accessToken)) {
      return _refreshToken(token);
    }

    return token;
  }

  /// Ensures the token box is open and available
  Future<void> _ensureTokenBoxOpen() async {
    if (!await _hiveAuth.boxExists(LocalStorageKey.token)) {
      await _hiveAuth.openBox(LocalStorageKey.token);
    }
    if (!_hiveAuth.isBoxOpen(LocalStorageKey.token)) {
      await _hiveAuth.openBox(LocalStorageKey.token);
    }
  }

  /// Gets the stored token from Hive
  UserTokenModel? _getStoredToken() {
    return _hiveAuth.box(LocalStorageKey.token).get(LocalStorageKey.userToken);
  }

  /// Refreshes the token using the refresh token
  Future<UserTokenModel> _refreshToken(UserTokenModel token) async {
    try {
      final response = await post<Map<String, dynamic>>(
        EndPoint.authRefreshToken,
        data: {"refreshToken": token.refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer ${token.accessToken}'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = UserTokenModel.fromMap(response.data!);
        await _saveToken(newToken);
        return newToken;
      }

      throw ServerException(
        message:
            response.data?['message']?.toString() ?? 'Failed to refresh token',
        statusCode: response.statusCode?.toString() ?? '401',
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        await _clearToken();
      }
      rethrow;
    }
  }

  /// Saves a token to Hive storage
  Future<void> _saveToken(UserTokenModel token) async {
    await _hiveAuth
        .box(LocalStorageKey.token)
        .put(LocalStorageKey.userToken, token);
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

  /// Makes a GET request to the specified path
  ///
  /// [path] is the endpoint to request
  /// [queryParameters] are optional query parameters
  /// [options] are optional request options
  /// [cancelToken] is an optional token to cancel the request
  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.get(
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
  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.post(
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
  @override
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.put(
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
  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.patch(
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
  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return dio.delete(
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

  /// Clears all cached data
  Future<void> clearCache() async {
    await cacheManager.clean();
  }

  /// Removes cache for a specific endpoint
  Future<void> removeCache(String path) async {
    final cacheKey = CacheOptions.defaultCacheKeyBuilder(
      url: Uri.parse('$EndPoint.apiUrl$path'),
    );
    await cacheManager.delete(cacheKey);
  }

  /// Makes a GET request with custom cache policy
  @override
  Future<Response<T>> getWithCachePolicy<T>(
    String path, {
    CachePolicy policy = CachePolicy.refreshForceCache,
    Duration? maxStale,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final cacheOptions = CacheOptions(
      store: cacheManager.cacheStore,
      policy: policy,
      maxStale: maxStale,
    );

    final requestOptions = options?.copyWith(
          extra: {
            ...?options.extra,
            'cache_options': cacheOptions,
          },
        ) ??
        Options(
          extra: {'cache_options': cacheOptions},
        );

    return dio.get(
      path,
      queryParameters: _addCultureParameter(queryParameters),
      options: requestOptions,
      cancelToken: cancelToken,
    );
  }

  /// Makes a GET request with cache
  @override
  Future<Response<T>> getWithCache<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration? maxStale,
    CachePolicy policy = CachePolicy.refreshForceCache,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // Disable cache for auth endpoints
    if (_isAuthEndpoint(path)) {
      return get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    }

    final cacheOptions = CacheOptions(
      store: cacheManager.cacheStore,
      policy: policy,
      maxStale: maxStale ?? const Duration(hours: 1),
    );

    final requestOptions = options?.copyWith(
          extra: {
            ...?options.extra,
            'cache_options': cacheOptions,
          },
        ) ??
        Options(
          extra: {'cache_options': cacheOptions},
        );

    return dio.get(
      path,
      queryParameters: _addCultureParameter(queryParameters),
      options: requestOptions,
      cancelToken: cancelToken,
    );
  }

  /// Makes a POST request and invalidates related cache
  @override
  Future<Response<T>> postAndInvalidateCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    // Disable cache invalidation for auth endpoints
    if (_isAuthEndpoint(path)) {
      return post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    }

    final response = await post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    // Invalidate related cache paths
    if (invalidatePaths != null) {
      for (final cachePath in invalidatePaths) {
        await removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a PUT request and invalidates related cache
  @override
  Future<Response<T>> putAndInvalidateCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    // Invalidate related cache paths
    if (invalidatePaths != null) {
      for (final cachePath in invalidatePaths) {
        await removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a DELETE request and invalidates related cache
  @override
  Future<Response<T>> deleteAndInvalidateCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    // Invalidate related cache paths
    if (invalidatePaths != null) {
      for (final cachePath in invalidatePaths) {
        await removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a PATCH request and invalidates related cache
  @override
  Future<Response<T>> patchAndInvalidateCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    // Invalidate related cache paths
    if (invalidatePaths != null) {
      for (final cachePath in invalidatePaths) {
        await removeCache(cachePath);
      }
    }

    return response;
  }

  /// Removes cache for multiple endpoints
  Future<void> removeMultipleCache(List<String> paths) async {
    for (final path in paths) {
      await removeCache(path);
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

  /// Makes a GET request with default cache settings
  /// Use this for most GET requests that need caching
  @override
  Future<Response<T>> getWithDefaultCache<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return getWithCache<T>(
      path,
      queryParameters: queryParameters,
      maxStale: const Duration(hours: 1), // Default 1 hour cache
      policy: CachePolicy.refreshForceCache,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a GET request with long-term cache
  /// Use this for data that rarely changes (e.g., static content, configurations)
  @override
  Future<Response<T>> getWithLongTermCache<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration maxStale = const Duration(days: 7),
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return getWithCache<T>(
      path,
      queryParameters: queryParameters,
      maxStale: maxStale,
      policy: CachePolicy.refreshForceCache,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a GET request with short-term cache
  /// Use this for frequently changing data (e.g., notifications, real-time updates)
  @override
  Future<Response<T>> getWithShortTermCache<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration maxStale = const Duration(minutes: 5),
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return getWithCache<T>(
      path,
      queryParameters: queryParameters,
      maxStale: maxStale,
      policy: CachePolicy.refreshForceCache,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a GET request with real-time cache
  /// Use this for data that needs to be as fresh as possible
  @override
  Future<Response<T>> getWithRealTimeCache<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration maxStale = const Duration(seconds: 30),
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return getWithCache<T>(
      path,
      queryParameters: queryParameters,
      maxStale: maxStale,
      policy: CachePolicy.refresh,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a POST request and invalidates related cache with default settings
  Future<Response<T>> postAndInvalidateDefaultCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return postAndInvalidateCache<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      invalidatePaths: invalidatePaths,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a PUT request and invalidates related cache with default settings
  Future<Response<T>> putAndInvalidateDefaultCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return putAndInvalidateCache<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      invalidatePaths: invalidatePaths,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a DELETE request and invalidates related cache with default settings
  Future<Response<T>> deleteAndInvalidateDefaultCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return deleteAndInvalidateCache<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      invalidatePaths: invalidatePaths,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Makes a PATCH request and invalidates related cache with default settings
  Future<Response<T>> patchAndInvalidateDefaultCache<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? invalidatePaths,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return patchAndInvalidateCache<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      invalidatePaths: invalidatePaths,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Removes cache for multiple endpoints with logging
  Future<void> removeMultipleCacheWithLogging(List<String> paths) async {
    for (final path in paths) {
      try {
        await removeCache(path);
        logger.d('Cache removed for path: $path');
      } catch (e) {
        logger.e('Error removing cache for path: $path', error: e);
      }
    }
  }
}
