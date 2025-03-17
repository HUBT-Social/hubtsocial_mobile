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
    // Sắp xếp thông báo theo thời gian mới nhất
    notifications.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    
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
    return Card(
      elevation: 0,
      color: notification.isRead ? null : Colors.blue.withOpacity(0.05),
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
        child: Padding(
          padding: EdgeInsets.all(16),
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
                        fontSize: 16,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    if (notification.body != null) ...[
                      SizedBox(height: 4),
                      Text(
                        notification.body!,
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                    SizedBox(height: 8),
                    Text(
                      _formatTime(context, notification.time),
                      style: context.textTheme.labelSmall,
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
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
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

    IconData icon;
    Color color;

    if (isBroadcast) {
      icon = Icons.campaign;
      color = Colors.red;
    } else if (isGroupMessage) {
      icon = Icons.group;
      color = Colors.green;
    } else {
      switch (type) {
        case 'chat':
          icon = Icons.chat_bubble;
          color = Colors.blue;
          break;
        case 'timetable':
          icon = Icons.schedule;
          color = Colors.orange;
          break;
        case 'profile':
          icon = Icons.person;
          color = Colors.purple;
          break;
        default:
          icon = Icons.notifications;
          color = Colors.grey;
      }
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
