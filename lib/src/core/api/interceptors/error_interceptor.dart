import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';

/// Interceptor that handles error responses
class ErrorInterceptor extends Interceptor {
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
      case DioExceptionType.badResponse:
        _handleBadResponse(err);
        break;
      case DioExceptionType.cancel:
        break;
      default:
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
