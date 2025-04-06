import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:intl/intl.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsScreen> {
  String _selectedFilter = 'all'; // all, unread, system, chat, schedule

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.notifications,
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
            ),
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
                  SizedBox(height: 16),
                  Text(context.loc.noNotifications,
                      style: context.textTheme.bodyLarge),
                ],
              ),
            );
          }

          final filteredNotifications =
              _filterNotifications(box.values.toList());

          if (filteredNotifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_list_off,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text('Không có thông báo nào trong bộ lọc này',
                      style: context.textTheme.bodyLarge),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(12),
            itemCount: filteredNotifications.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final notification = filteredNotifications[index];
              return _NotificationItem(
                notification: notification,
                onTap: () => _handleNotificationTap(context, notification),
              );
            },
          );
        },
      ),
    );
  }

  List<NotificationModel> _filterNotifications(
      List<NotificationModel> notifications) {
    switch (_selectedFilter) {
      case 'unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'system':
        return notifications
            .where((n) =>
                n.data == null ||
                n.data!['type'] == 'system' ||
                n.data!['isBroadcast'] == true)
            .toList();
      case 'chat':
        return notifications
            .where((n) =>
                n.data != null &&
                n.data!['type'] == 'chat' &&
                n.data!['isBroadcast'] != true)
            .toList();
      case 'group':
        return notifications
            .where((n) => n.data != null && n.data!['isGroupMessage'] == true)
            .toList();
      case 'schedule':
        return notifications
            .where((n) => n.data != null && n.data!['type'] == 'timetable')
            .toList();
      default:
        return notifications;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lọc thông báo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterOption(
              title: 'Tất cả',
              icon: Icons.all_inbox,
              isSelected: _selectedFilter == 'all',
              onTap: () {
                setState(() => _selectedFilter = 'all');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Chưa đọc',
              icon: Icons.mark_email_unread,
              isSelected: _selectedFilter == 'unread',
              onTap: () {
                setState(() => _selectedFilter = 'unread');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Hệ thống',
              icon: Icons.campaign,
              isSelected: _selectedFilter == 'system',
              onTap: () {
                setState(() => _selectedFilter = 'system');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Tin nhắn',
              icon: Icons.chat_bubble,
              isSelected: _selectedFilter == 'chat',
              onTap: () {
                setState(() => _selectedFilter = 'chat');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Nhóm',
              icon: Icons.group,
              isSelected: _selectedFilter == 'group',
              onTap: () {
                setState(() => _selectedFilter = 'group');
                Navigator.pop(context);
              },
            ),
            _FilterOption(
              title: 'Lịch học',
              icon: Icons.schedule,
              isSelected: _selectedFilter == 'schedule',
              onTap: () {
                setState(() => _selectedFilter = 'schedule');
                Navigator.pop(context);
              },
            ),
          ],
        ),
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

class _FilterOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color:
                  isSelected ? Theme.of(context).primaryColor : Colors.black)),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: onTap,
    );
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
    final hasImage = notification.data?['image'] != null;
    
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: notification.isRead ? Colors.white : Colors.blue.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(notification: notification),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (notification.body != null) ...[
                      SizedBox(height: 2),
                      Text(
                        notification.body!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 4),
                    Text(
                      _formatTime(context, notification.time),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasImage) ...[
                SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    notification.data!['image'],
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
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

class _NotificationIcon extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationIcon({required this.notification});

  @override
  Widget build(BuildContext context) {
    final type = notification.data?['type'] ?? 'system';
    final isGroupMessage = notification.data?['isGroupMessage'] == true;
    final isBroadcast = notification.data?['isBroadcast'] == true;

    String imagePath;
    Color backgroundColor;

    if (isBroadcast) {
      imagePath = 'assets/images/notifications/canhbao.png';
      backgroundColor = Colors.red.withOpacity(0.1);
    } else if (isGroupMessage) {
      imagePath = 'assets/images/notifications/logotruong.png';
      backgroundColor = Colors.green.withOpacity(0.1);
    } else {
      switch (type) {
        case 'chat':
          imagePath = 'assets/images/notifications/logotruong.png';
          backgroundColor = Colors.blue.withOpacity(0.1);
          break;
        case 'timetable':
          imagePath = 'assets/images/notifications/lichthi.png';
          backgroundColor = Colors.orange.withOpacity(0.1);
          break;
        case 'academic_warning':
          imagePath = 'assets/images/notifications/canh_bao_hoc_tap.png';
          backgroundColor = Colors.purple.withOpacity(0.1);
          break;
        default:
          imagePath = 'assets/images/notifications/logotruong.png';
          backgroundColor = Colors.grey.withOpacity(0.1);
      }
    }

    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(0),
      child: Image.asset(
        imagePath,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
  }
}
