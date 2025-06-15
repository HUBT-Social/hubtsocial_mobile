import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'notification_icon.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final type = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';
    String title = 'Chi tiết thông báo';

    // Xác định tiêu đề dựa trên loại thông báo
    switch (type) {
      case 'learning_alerts':
        title = 'Cảnh báo học tập';
        break;
      case 'academic_warning':
        title = 'Cảnh báo học vụ';
        break;
      case 'broadcast':
        title = 'Thông báo chung';
        break;
      case 'exam':
        title = 'Thông báo thi';
        break;
      case 'maintenance':
        title = 'Thông báo bảo trì';
        break;
    }

    final avatarUrl = notification.data?['avatarUrl'];
    final imageUrl = notification.data?['imageUrl'];
    // Avatar lớn phía trên
    Widget mainImageWidget = Center(
      child: NotificationIcon(notification: notification, size: 100),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainImageWidget,
              const SizedBox(height: 24),
              // Box thông tin thông báo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NotificationIcon(notification: notification, size: 60),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.title ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatTime(notification.time, context),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Nội dung thông báo
              const Text(
                'Nội dung',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  notification.body ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Hình ảnh (nếu có)
              if (imageUrl != null && imageUrl.toString().isNotEmpty) ...[
                const Text(
                  'Hình ảnh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Không thể tải hình ảnh',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time, BuildContext context) {
    final dateTime = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
