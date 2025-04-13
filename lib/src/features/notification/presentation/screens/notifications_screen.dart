import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_type_id.dart';
import 'package:hubtsocial_mobile/hive/hive_adapters.dart';

import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';

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
    final type = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';

    return Container(
      height: 75,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 4),
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
            if ([
              'learning_alerts',
              'academic_warning',
              'broadcast',
              'exam',
              'maintenance'
            ].contains(type)) {
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
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NotificationIcon(notification: notification),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (notification.body != null) ...[
                        SizedBox(height: 2),
                        Text(
                          notification.body!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      Spacer(),
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
                  SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl!,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 45,
                          height: 45,
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
      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(LocalStorageTypeId.notification)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }

      _notificationsBox =
          await Hive.openBox<NotificationModel>('notifications');
      setState(() {});
    } catch (e) {
      print('Error initializing Hive in NotificationsScreen: $e');
    }
  }

  void _handleNotificationTap(
      BuildContext context, NotificationModel notification) async {
    if (!notification.isRead) {
      notification.isRead = true;
      await notification.save();
    }

    final type = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';

    if ([
      'learning_alerts',
      'academic_warning',
      'broadcast',
      'exam',
      'maintenance'
    ].contains(type)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NotificationDetailScreen(notification: notification),
        ),
      );
      return;
    }

    if (notification.data != null) {
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

        default:
          router.go(AppRoute.notifications.path);
      }
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
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      final imageUrl = notification.data?['imageUrl'];

                      return InkWell(
                        onTap: () =>
                            _handleNotificationTap(context, notification),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left icon
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: _NotificationIcon(
                                    notification: notification),
                              ),
                              SizedBox(width: 12),
                              // Content in the middle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      notification.title ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (notification.body != null) ...[
                                      SizedBox(height: 2),
                                      Text(
                                        notification.body ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 2),
                                    Text(
                                      _formatTime(notification.time),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              // Right image or empty space
                              Container(
                                width: 50,
                                height: 50,
                                child: imageUrl?.toString().isNotEmpty == true
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          imageUrl!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề thông báo
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
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
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Nội dung thông báo
              Text(
                'Nội dung',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Hình ảnh (nếu có)
              if (notification.data?['imageUrl'] != null) ...[
                Text(
                  'Hình ảnh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    notification.data!['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
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
