import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:intl/intl.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_type_id.dart';
import 'package:hubtsocial_mobile/hive/hive_adapters.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsState();
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
    final hasImage = notification.data?['imageUrl'] != null;
    final imageUrl = notification.data?['imageUrl'];

    return Container(
      height: 85,
      width: 360,
      margin: EdgeInsets.only(bottom: 8),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _NotificationIcon(notification: notification),
                SizedBox(width: 12),
                Container(
                  width: 242,
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (notification.body != null) ...[
                        SizedBox(height: 4),
                        Text(
                          notification.body!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 4),
                      Text(
                        _formatTime(notification.time),
                        style: TextStyle(
                          fontSize: 12,
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
                      imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
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
    String imagePath;

    final notificationType = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';
    final avatarUrl = notification.data?['avatarUrl']?.toString();
    final isGroupMessage = notification.data?['isGroupMessage'] == true;

    switch (notificationType) {
      case 'broadcast':
        imagePath = 'assets/icons/ic_thongbao.png';
        break;
      case 'profile':
        if (avatarUrl != null) return buildNetworkAvatar(avatarUrl);
        imagePath = 'assets/icons/ic_profile.png';
        break;
      case 'learning_alerts':
      case 'academic_warning':
        imagePath = 'assets/icons/ic_canhbao.png';
        break;
      case 'schedule':
      case 'timetable':
        imagePath = 'assets/icons/ic_lichhoc.png';
        break;
      case 'exam':
        imagePath = 'assets/icons/ic_lichthi.png';
        break;
      case 'maintenance':
        imagePath = 'assets/icons/ic_baotri.png';
        break;
      case 'chat':
        if (isGroupMessage) {
          imagePath = 'assets/icons/ic_groupchat.png';
        } else if (avatarUrl != null) {
          return buildNetworkAvatar(avatarUrl);
        } else {
          imagePath = 'assets/icons/ic_chat.png';
        }
        break;
      default:
        imagePath = 'assets/icons/ic_thongbao.png';
    }

    return Image.asset(
      imagePath,
      width: 50,
      height: 50,
      fit: BoxFit.contain,
    );
  }
}

Widget buildNetworkAvatar(String url) {
  return Image.network(
    url,
    width: 50,
    height: 50,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        'assets/icons/ic_profile.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      );
    },
  );
}

class _NotificationsState extends State<NotificationsScreen> {
  String _selectedFilter = 'all';
  Box<NotificationModel>? _notificationsBox;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapter if needed
      if (!Hive.isAdapterRegistered(LocalStorageTypeId.notification)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }

      // Open notifications box
      _notificationsBox =
          await Hive.openBox<NotificationModel>('notifications');

      // Force rebuild to show notifications
      setState(() {});
    } catch (e) {
      print('Error initializing Hive in NotificationsScreen: $e');
    }
  }

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
      body: _notificationsBox == null
          ? Center(child: CircularProgressIndicator())
          : ValueListenableBuilder<Box<NotificationModel>>(
              valueListenable: _notificationsBox!.listenable(),
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

                return Container(
                  color: Colors.grey[50],
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _NotificationItem(
                        notification: notification,
                        onTap: () =>
                            _handleNotificationTap(context, notification),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  List<NotificationModel> _filterNotifications(
      List<NotificationModel> notifications) {
    notifications.sort(
        (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));

    switch (_selectedFilter) {
      case 'unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'system':
        return notifications
            .where((n) =>
                n.data == null ||
                n.data!['type'] == 'broadcast' ||
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
            .where((n) =>
                n.data != null &&
                (n.data!['type'] == 'timetable' ||
                    n.data!['type'] == 'schedule'))
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
      final type = notification.data!['type']?.toString().toLowerCase();

      switch (type) {
        case 'chat':
          final roomId = notification.data!['id']?.toString();
          final title = notification.data!['title']?.toString();
          final avatarUrl = notification.data!['avatarUrl']?.toString();
          if (roomId != null) {
            AppRoute.roomChat.push(context, queryParameters: {
              "id": roomId,
              "title": title,
              "avatarUrl": avatarUrl
            });
          } else {
            router.go('/chat');
          }
          break;

        case 'profile':
          final userId = notification.data!['userId']?.toString();
          if (userId != null) {
            router.go('/profile/$userId');
          } else {
            router.go('/menu/profile');
          }
          break;

        case 'timetable':
          router.go('/timetable');
          break;

        case 'academic_warning':
        case 'maintenance':
        case 'broadcast':
        case 'exam':
        default:
          // Không cần điều hướng, chỉ cần đánh dấu là đã đọc
          // Vì chúng ta đã ở màn hình thông báo rồi
          break;
      }
    }
  }
}
