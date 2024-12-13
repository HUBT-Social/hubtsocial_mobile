// import 'package:dio/dio.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';
// import '../../model/notification_model.dart';

// /*
// Lưu trữ thông báo locally để xem offline
// Đồng bộ với server khi có kết nối
// Nhận thông báo realtime qua WebSocket
// Xử lý các tác vụ như đánh dấu đã đọc cả ở local và server
// */
// class NotificationService {
//   final Dio _dio;

//   NotificationService(this._dio);

//   Future<List<NotificationModel>> getNotifications() async {
//     try {
//       final response = await _dio.get('/api/notifications');

//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data['data'];
//         return data.map((json) => NotificationModel.fromJson(json)).toList();
//       }
//       throw Exception('Không thể lấy thông báo');
//     } catch (e) {
//       throw Exception('Lỗi khi lấy thông báo: $e');
//     }
//   }

//   // Thêm phương thức để đánh dấu đã đọc
//   Future<void> markAsRead(String id) async {
//     try {
//       await _dio.put('/api/notifications/$id/read');
//     } catch (e) {
//       throw Exception('Lỗi khi đánh dấu đã đọc: $e');
//     }
//   }

//   // Thêm phương thức để lấy thông báo mới (polling hoặc websocket)
//   Stream<NotificationModel> subscribeToNewNotifications() {
//     // Sử dụng WebSocket
//     final wsUrl = Uri.parse('ws://your-backend/notifications');
//     final channel = WebSocketChannel.connect(wsUrl);

//     return channel.stream.map((data) {
//       final json = jsonDecode(data);
//       return NotificationModel.fromJson(json);
//     });
//   }
// }
