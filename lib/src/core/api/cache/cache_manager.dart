import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_hive_store/http_cache_hive_store.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:collection';

/// A simple in-memory cache store implementation
class InMemoryCacheStore implements CacheStore {
  final Map<String, CacheResponse> _cache = HashMap();

  @override
  Future<void> clean({CachePriority? priorityOrBelow, bool? staleOnly}) async {
    if (staleOnly == true) {
      final now = DateTime.now();
      _cache.removeWhere((_, response) =>
          response.cacheControl?.maxAge != null &&
          response.date != null &&
          now.difference(response.date!).inSeconds >
              response.cacheControl!.maxAge!);
    } else {
      _cache.clear();
    }
  }

  @override
  Future<void> close() async {
    _cache.clear();
  }

  @override
  Future<void> delete(String key, {bool? staleOnly}) async {
    if (staleOnly == true) {
      final response = _cache[key];
      if (response != null &&
          response.cacheControl?.maxAge != null &&
          response.date != null) {
        final now = DateTime.now();
        if (now.difference(response.date!).inSeconds >
            response.cacheControl!.maxAge!) {
          _cache.remove(key);
        }
      }
    } else {
      _cache.remove(key);
    }
  }

  @override
  Future<void> deleteFromPath(RegExp path,
      {Map<String, String?>? queryParams}) async {
    final keysToRemove =
        _cache.keys.where((key) => path.hasMatch(key)).toList();
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  @override
  Future<bool> exists(String key) async {
    return _cache.containsKey(key);
  }

  @override
  Future<CacheResponse?> get(String key) async {
    final response = _cache[key];
    if (response != null &&
        response.cacheControl?.maxAge != null &&
        response.date != null) {
      final now = DateTime.now();
      if (now.difference(response.date!).inSeconds >
          response.cacheControl!.maxAge!) {
        _cache.remove(key);
        return null;
      }
    }
    return response;
  }

  @override
  Future<List<CacheResponse>> getFromPath(RegExp path,
      {Map<String, String?>? queryParams}) async {
    final matchingKeys =
        _cache.keys.where((key) => path.hasMatch(key)).toList();
    final responses = <CacheResponse>[];
    for (final key in matchingKeys) {
      final response = await get(key);
      if (response != null) {
        responses.add(response);
      }
    }
    return responses;
  }

  @override
  bool pathExists(String key, RegExp path,
      {Map<String, String?>? queryParams}) {
    return path.hasMatch(key);
  }

  @override
  Future<void> set(CacheResponse response) async {
    final key = CacheOptions.defaultCacheKeyBuilder(
      url: response.url is String
          ? Uri.parse(response.url as String)
          : response.url as Uri,
    );
    _cache[key] = response;
  }
}

/// Manages cache operations for Dio client
class CacheManager {
  CacheStore? _cacheStore;
  DioCacheInterceptor? _cacheInterceptor;
  bool _isInitialized = false;
  bool _usingInMemoryCache = false;

  /// Gets whether the cache is initialized
  bool get isInitialized => _isInitialized;

  /// Gets whether we're using in-memory cache
  bool get usingInMemoryCache => _usingInMemoryCache;

  /// Initialize cache synchronously with default values
  void initializeSync() {
    // Create a temporary in-memory store for initial interceptor
    _initializeInMemoryCache();
  }

  /// Initialize cache asynchronously
  Future<void> initialize() async {
    if (_isInitialized) {
      logger.d('Cache already initialized');
      return;
    }

    try {
      // Try to get the application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDir.path}/cache_store');

      // Create cache directory if it doesn't exist
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Verify we have write permissions
      final testFile = File('${cacheDir.path}/test.txt');
      try {
        await testFile.writeAsString('test');
        await testFile.delete();
      } catch (e) {
        logger.w(
            'No write permissions to cache directory, falling back to in-memory cache');
        _initializeInMemoryCache();
        return;
      }

      // Initialize Hive cache store
      _cacheStore = HiveCacheStore(LocalStorageKey.cacheStore);

      _cacheInterceptor = DioCacheInterceptor(
        options: CacheOptions(
          store: _cacheStore!,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
          allowPostMethod: false,
          hitCacheOnErrorCodes: [500, 502, 503, 504, 0],
          hitCacheOnNetworkFailure: true,
        ),
      );

      _isInitialized = true;
      _usingInMemoryCache = false;
      logger.i('Cache initialized successfully with persistent storage');
    } catch (e) {
      logger.e('Error initializing persistent cache: $e');
      _initializeInMemoryCache();
    }
  }

  /// Initialize in-memory cache as fallback
  void _initializeInMemoryCache() {
    logger.w('Using in-memory cache as fallback');
    try {
      // Use our custom in-memory cache store
      _cacheStore = InMemoryCacheStore();

      _cacheInterceptor = DioCacheInterceptor(
        options: CacheOptions(
          store: _cacheStore!,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 7),
          priority: CachePriority.normal,
          keyBuilder: CacheOptions.defaultCacheKeyBuilder,
          allowPostMethod: false,
          hitCacheOnErrorCodes: [500, 502, 503, 504, 0],
          hitCacheOnNetworkFailure: true,
        ),
      );

      _isInitialized = true;
      _usingInMemoryCache = true;
      logger.i('In-memory cache initialized successfully');
    } catch (e) {
      logger.e('Error initializing in-memory cache: $e');
      _isInitialized = false;
    }
  }

  /// Gets the cache store
  CacheStore get cacheStore {
    if (!_isInitialized) {
      throw StateError('Cache not initialized. Call initialize() first.');
    }
    return _cacheStore!;
  }

  /// Gets the cache interceptor
  DioCacheInterceptor get cacheInterceptor {
    if (!_isInitialized) {
      throw StateError('Cache not initialized. Call initialize() first.');
    }
    return _cacheInterceptor!;
  }

  /// Clears all cached data
  Future<void> clean() async {
    if (!_isInitialized) {
      logger.w('Cache not initialized, skipping clean');
      return;
    }

    try {
      await _cacheStore?.clean();
    } catch (e) {
      logger.e('Error cleaning cache: $e');
    }
  }

  /// Deletes cache for a specific key
  Future<void> delete(String key) async {
    if (!_isInitialized) {
      logger.w('Cache not initialized, skipping delete');
      return;
    }

    try {
      await _cacheStore?.delete(key);
    } catch (e) {
      logger.e('Error deleting cache key: $e');
    }
  }

  /// Removes cache for a specific endpoint
  Future<void> removeCache(String path) async {
    if (!_isInitialized) {
      logger.w('Cache not initialized, skipping removeCache');
      return;
    }

    try {
      final cacheKey = CacheOptions.defaultCacheKeyBuilder(
        url: Uri.parse(path),
      );
      await _cacheStore?.delete(cacheKey);
    } catch (e) {
      logger.e('Error removing cache for path: $path', error: e);
    }
  }

  /// Removes cache for multiple endpoints
  Future<void> removeMultipleCache(List<String> paths) async {
    if (!_isInitialized) {
      logger.w('Cache not initialized, skipping removeMultipleCache');
      return;
    }

    for (final path in paths) {
      await removeCache(path);
    }
  }

  /// Removes cache for multiple endpoints with logging
  Future<void> removeMultipleCacheWithLogging(List<String> paths) async {
    if (!_isInitialized) {
      logger
          .w('Cache not initialized, skipping removeMultipleCacheWithLogging');
      return;
    }

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
