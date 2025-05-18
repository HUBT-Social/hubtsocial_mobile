import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'notification_icon.dart';
import 'notification_detail_screen.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationItem({
    required this.notification,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final type = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';

    final typesToShowDetail = [
      'learning_alerts',
      'academic_warning',
      'broadcast',
      'exam',
      'maintenance',
    ];

    return Container(
      height: screenHeight / 9,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            notification.isRead ? Colors.white : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if ((notification.body?.isNotEmpty == true) &&
                typesToShowDetail.contains(type)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetailScreen(notification: notification),
                ),
              );
            } else {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: NotificationIcon(notification: notification, size: 70),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (notification.body != null) ...[
                        SizedBox(height: 3),
                        Text(
                          notification.body!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      Spacer(),
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
