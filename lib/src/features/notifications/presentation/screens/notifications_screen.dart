import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/core/navigation/router.import.dart';
import 'package:intl/intl.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.notifications,
          actions: [
            TextButton.icon(
              onPressed: () => _markAllAsRead(context),
              icon: const Icon(Icons.done_all, color: Colors.blue),
              label: Text(
                context.loc.markAllAsRead,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
      body: ValueListenableBuilder<Box<NotificationModel>>(
        valueListenable:
            Hive.box<NotificationModel>('notifications').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.loc.noNotifications,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = box.getAt(box.length - 1 - index);
              return _NotificationItem(
                notification: notification!,
                onTap: () => _handleNotificationTap(context, notification),
              );
            },
          );
        },
      ),
    );
  }

  void _markAllAsRead(BuildContext context) async {
    var box = Hive.box<NotificationModel>('notifications');
    for (var i = 0; i < box.length; i++) {
      final notification = box.getAt(i);
      if (notification != null && !notification.isRead) {
        notification.isRead = true;
        await notification.save();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đánh dấu tất cả là đã đọc'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleNotificationTap(
      BuildContext context, NotificationModel notification) async {
    if (!notification.isRead) {
      notification.isRead = true;
      await notification.save();
    }

    if (notification.data != null) {
      switch (notification.data!['type']) {
        case 'chat':
          router.go('/chat');
          break;
        case 'timetable':
          router.go('/timetable');
          break;
        case 'profile':
          router.go('/menu/profile');
          break;
        default:
          router.go('/chat');
          break;
      }
    }
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notification.isRead ? Colors.transparent : Colors.blue,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (notification.data != null &&
                        notification.data!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: notification.data!.entries.map((entry) {
                              return Text(
                                '${entry.key}: ${entry.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(context, notification.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(BuildContext context, String time) {
    final dateTime = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat(context.loc.timeFormat).format(dateTime);
    } else if (difference.inHours > 0) {
      return context.loc.hoursAgo(difference.inHours.toString());
    } else if (difference.inMinutes > 0) {
      return context.loc.minutesAgo(difference.inMinutes.toString());
    } else {
      return context.loc.justNow;
    }
  }
}
