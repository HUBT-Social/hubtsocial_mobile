import 'package:dio/dio.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';

class ApiService {
  static Future<T> handleApiCall<T>(Future<T> apiCall) async {
    try {
      final response = await apiCall;
      return response;
    } on DioException catch (err) {
      logger.e(err.message.toString());
      throw DioException;
    } catch (e) {
      rethrow;
    }
  }
}
