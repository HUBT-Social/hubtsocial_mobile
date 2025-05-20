import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:hubtsocial_mobile/src/core/api/cache/cache_manager.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';

/// Mixin that provides HTTP methods for Dio client
mixin HttpMethods {
  Dio get dio;
  CacheManager get cacheManager;

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

  /// Makes a GET request to the specified path
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

  /// Makes a GET request with custom cache policy
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

  /// Makes a GET request with default cache settings
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

  /// Makes a POST request and invalidates related cache
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
        await cacheManager.removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a PUT request and invalidates related cache
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
        await cacheManager.removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a DELETE request and invalidates related cache
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
        await cacheManager.removeCache(cachePath);
      }
    }

    return response;
  }

  /// Makes a PATCH request and invalidates related cache
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
        await cacheManager.removeCache(cachePath);
      }
    }

    return response;
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
