import 'package:dio/dio.dart';
import '../models/class_schedule.dart';

class ScheduleApiService {
  final Dio _dio;

  ScheduleApiService(this._dio);

  Future<List<ClassSchedule>> getSchedules() async {
    try {
      // Thay thế URL bằng API thật của bạn
      final response = await _dio.get('/api/schedules');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ClassSchedule.fromJson(json)).toList();
      }
      
      throw Exception('Failed to load schedules');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 