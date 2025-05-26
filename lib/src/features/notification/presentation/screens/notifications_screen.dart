import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_type_id.dart';
import 'package:hubtsocial_mobile/hive/hive_adapters.dart';
import 'notification_icon.dart';
import 'notification_detail_screen.dart';
import 'filter_option.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/features/notification/presentation/screens/notification_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsState();
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
              icon: SvgPicture.asset(
                'assets/icons/loc_thong_bao.svg',
                width: 24.r,
                height: 24.r,
              ),
              onPressed: () => _showFilterDialog(context),
              tooltip: 'Lọc thông báo',
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/danh_dau.svg',
                width: 24.r,
                height: 24.r,
              ),
              onPressed: () => _markAllAsRead(context),
              tooltip: 'Đánh dấu tất cả là đã đọc',
            ),
          ],
        ),
      ],
      body: Container(
        color: context.colorScheme.background,
        child: _notificationsBox == null
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
                            size: 80.r,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
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
                            size: 80.r,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text('Không có thông báo nào trong bộ lọc này',
                              style: context.textTheme.bodyLarge),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return NotificationItem(
                        notification: notification,
                        onTap: () =>
                            _handleNotificationTap(context, notification),
                      );
                    },
                  );
                },
              ),
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
        title: Text('lọc thông báo'),
        contentPadding: EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterOption(
              title: context.loc.all,
              icon: Icons.all_inbox,
              isSelected: _selectedFilter == 'all',
              onTap: () {
                setState(() => _selectedFilter = 'all');
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.unread,
              icon: Icons.mark_email_unread,
              isSelected: _selectedFilter == 'unread',
              onTap: () {
                setState(() => _selectedFilter = 'unread');
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.system,
              icon: Icons.campaign,
              isSelected: _selectedFilter == 'system',
              onTap: () {
                setState(() => _selectedFilter = 'system');
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.chat,
              icon: Icons.chat_bubble,
              isSelected: _selectedFilter == 'chat',
              onTap: () {
                setState(() => _selectedFilter = 'chat');
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.groups,
              icon: Icons.group,
              isSelected: _selectedFilter == 'group',
              onTap: () {
                setState(() => _selectedFilter = 'group');
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.schedule,
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

  String _formatTime(String time, BuildContext context) {
    // Chuyển đổi chuỗi thời gian thành DateTime
    final dateTime = DateTime.parse(time);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${context.loc.the_day_before}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${context.loc.the_time_before}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${context.loc.the_muniest_before}';
    } else {
      return context.loc.just_finished;
    }
  }

  Widget buildNotificationAvatar(NotificationModel notification) {
    final imageUrl = notification.data?['imageUrl'];
    final avatarUrl = notification.data?['avatarUrl'];
    final mainImage = imageUrl ?? avatarUrl;

    if (mainImage != null && mainImage.toString().isNotEmpty) {
      return Stack(
        children: [
          ClipOval(
            child: Image.network(
              mainImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: NotificationIcon(notification: notification, size: 16),
            ),
          ),
        ],
      );
    } else {
      return NotificationIcon(notification: notification, size: 50);
    }
  }
}
