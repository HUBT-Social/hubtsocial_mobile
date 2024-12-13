
// import 'package:hive/hive.dart';

// import '../../domain/repositories/notification_repository.dart';
// import '../../model/notification_model.dart';

// class NotificationRepositoryImpl implements NotificationRepository {
//   final Box<NotificationModel> _notificationBox;

//   NotificationRepositoryImpl(this._notificationBox);

//   @override
//   Future<List<NotificationModel>> getNotifications() async {
//     try {
//       return _notificationBox.values.toList()
//         ..sort(
//             (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
//     } catch (e) {
//       throw Exception('Lỗi khi lấy danh sách thông báo: $e');
//     }
//   }

//   @override
//   Future<void> deleteNotification(String id) async {
//     try {
//       final keys = _notificationBox.keys
//           .where((key) => _notificationBox.get(key)?.id == id)
//           .toList();

//       for (var key in keys) {
//         await _notificationBox.delete(key);
//       }
//     } catch (e) {
//       throw Exception('Lỗi khi xóa thông báo: $e');
//     }
//   }

//   @override
//   Future<void> markAsRead(String id) async {
//     try {
//       final notifications = _notificationBox.values
//           .where((notification) => notification.id == id);

//       for (var notification in notifications) {
//         if (!notification.isRead) {
//           notification.isRead = true;
//           await notification.save();
//         }
//       }
//     } catch (e) {
//       throw Exception('Lỗi khi đánh dấu đã đọc: $e');
//     }
//   }

//   @override
//   Future<void> markAllAsRead() async {
//     try {
//       final unreadNotifications = _notificationBox.values
//           .where((notification) => !notification.isRead)
//           .toList();

//       for (var notification in unreadNotifications) {
//         notification.isRead = true;
//         await notification.save();
//       }
//     } catch (e) {
//       throw Exception('Lỗi khi đánh dấu tất cả đã đọc: $e');
//     }
//   }

//   @override
//   Future<void> saveNotification(NotificationModel notification) async {
//     try {
//       await _notificationBox.add(notification);
//     } catch (e) {
//       throw Exception('Lỗi khi lưu thông báo: $e');
//     }
//   }
// }
