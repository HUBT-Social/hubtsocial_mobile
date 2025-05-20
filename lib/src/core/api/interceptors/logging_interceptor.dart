import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';

/// Interceptor that handles logging
class LoggingInterceptor extends Interceptor {
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
    final statusCode = err.response?.statusCode;
    final errorType = err.type.name;
    final path = err.requestOptions.path;
    final errorMessage = err.message ?? 'Unknown error';

    logger.e(
      'ERROR[$errorType${statusCode != null ? ':$statusCode' : ''}] => PATH: $path\nMessage: $errorMessage',
    );

    if (err.response?.data != null) {
      logger.d('Error response data: ${err.response?.data}');
    }

    super.onError(err, handler);
  }
}
