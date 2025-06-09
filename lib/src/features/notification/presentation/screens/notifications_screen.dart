import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_type_id.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/hive/hive_adapters.dart';
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
  List<String> _blockedNotificationTypes = [];

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _loadBlockedNotificationTypes();
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

  Future<void> _loadBlockedNotificationTypes() async {
    try {
      final box = await Hive.openBox('settings');
      final List<dynamic> blockedTypes =
          box.get('blocked_types', defaultValue: []);
      setState(() {
        _blockedNotificationTypes = List<String>.from(blockedTypes);
      });
    } catch (e) {
      print('Error loading blocked notification types: $e');
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
      LocalStorageKey.learning_alerts,
      LocalStorageKey.academic_warning,
      LocalStorageKey.broadcast,
      LocalStorageKey.exam,
      LocalStorageKey.maintenance
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
        case LocalStorageKey.chat:
          final roomId = notification.data!['id']?.toString();
          if (roomId != null) {
            AppRoute.roomChat.push(navigatorKey.currentContext!,
                queryParameters: {"id": roomId});
          } else {
            router.go('/chat');
          }
          break;

        case LocalStorageKey.profile:
          final userId = notification.data!['userId']?.toString();
          if (userId != null) {
            router.go('/profile/$userId');
          } else {
            router.go('/menu/profile');
          }
          break;

        case LocalStorageKey.schedule:
        case LocalStorageKey.timeTable:
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
                color: context.colorScheme.onPrimary,
              ),
              onPressed: () => _showFilterDialog(context),
              tooltip: context.loc.filter_notifications,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/danh_dau.svg',
                width: 24.r,
                height: 24.r,
                color: context.colorScheme.onPrimary,
              ),
              onPressed: () => _markAllAsRead(context),
              tooltip: context.loc.mark_all_as_read,
            ),
          ],
        ),
      ],
      body: Container(
        color: context.colorScheme.surface,
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
                            color: context.colorScheme.onSurface.withAlpha(192),
                          ),
                          SizedBox(height: 16.h),
                          Text(context.loc.no_notifications_in_filter,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withAlpha(192),
                              )),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: 100.h),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >=
                                  (filteredNotifications.length > 100
                                      ? 100
                                      : filteredNotifications.length)) {
                                return null;
                              }
                              final notification = filteredNotifications[index];
                              return NotificationItem(
                                notification: notification,
                                onTap: () => _handleNotificationTap(
                                    context, notification),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  List<NotificationModel> _filterNotifications(
      List<NotificationModel> notifications) {
    List<NotificationModel> filteredList;

    // Step 1: Apply filtering based on selected filter
    switch (_selectedFilter) {
      case 'unread':
        filteredList = notifications.where((n) => !n.isRead).toList();
        break;
      case 'system':
        filteredList = notifications
            .where((n) =>
                n.data == null ||
                n.data!['type'] == LocalStorageKey.broadcast ||
                n.data!['isBroadcast'] == true)
            .toList();
        break;
      case LocalStorageKey.chat:
        filteredList = notifications
            .where((n) =>
                n.data != null &&
                n.data!['type'] == LocalStorageKey.chat &&
                n.data!['isBroadcast'] != true)
            .toList();
        break;
      case LocalStorageKey.group:
        filteredList = notifications
            .where((n) => n.data != null && n.data!['isGroupMessage'] == true)
            .toList();
        break;
      case LocalStorageKey.schedule:
        filteredList = notifications
            .where((n) =>
                n.data != null &&
                (n.data!['type'] == LocalStorageKey.schedule ||
                    n.data!['type'] == LocalStorageKey.timeTable))
            .toList();
        break;
      default: // 'all'
        filteredList = List.from(notifications); // Create a mutable copy
        break;
    }

    // Step 2: Filter out blocked notification types
    filteredList = filteredList.where((n) {
      final type = n.type?.toLowerCase() ??
          n.data?['type']?.toString().toLowerCase() ??
          '';
      return !_blockedNotificationTypes.contains(type);
    }).toList();

    // Step 3: Apply custom sorting to the filtered list
    filteredList.sort((a, b) {
      // Primary sort: Unread notifications first
      if (a.isRead && !b.isRead) {
        return 1; // b (unread) comes before a (read)
      }
      if (!a.isRead && b.isRead) {
        return -1; // a (unread) comes before b (read)
      }

      // Secondary sort (if read status is the same):
      // Prioritize non-timetable notifications over timetable (scheduled) notifications
      bool isTimetableA = a.type == LocalStorageKey.schedule ||
          a.type == LocalStorageKey.timeTable;
      bool isTimetableB = b.type == LocalStorageKey.schedule ||
          b.type == LocalStorageKey.timeTable;

      // If one is timetable and the other is not, put non-timetable first
      if (isTimetableA && !isTimetableB) {
        return 1; // b (non-timetable) comes before a (timetable)
      }
      if (!isTimetableA && isTimetableB) {
        return -1; // a (non-timetable) comes before b (timetable)
      }

      // Tertiary sort (if read status and type category are the same):
      // Sort by time
      if (!isTimetableA && !isTimetableB) {
        // Both are non-timetable: Sort by creation/receive time descending (most recent first)
        DateTime timeA = DateTime.parse(a.time);
        DateTime timeB = DateTime.parse(b.time);
        return timeB.compareTo(timeA);
      } else {
        // Both are timetable/schedule: Sort by scheduled start time ascending (earliest class first)
        DateTime? startTimeA =
            a.data != null && a.data!.containsKey('startTime')
                ? DateTime.tryParse(a.data!['startTime'])
                : null;
        DateTime? startTimeB =
            b.data != null && b.data!.containsKey('startTime')
                ? DateTime.tryParse(b.data!['startTime'])
                : null;

        // Handle null startTimes gracefully (e.g., put them at the end or compare by creation time)
        if (startTimeA == null && startTimeB == null) {
          // If both startTimes are null, fall back to sorting by creation time descending
          DateTime timeA = DateTime.parse(a.time);
          DateTime timeB = DateTime.parse(b.time);
          return timeB.compareTo(timeA);
        }
        if (startTimeA == null) return 1; // Null A goes after non-null B
        if (startTimeB == null) return -1; // Non-null A goes before null B

        return startTimeA.compareTo(startTimeB);
      }
    });

    return filteredList;
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc.filter_notifications),
        contentPadding: EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterOption(
              title: context.loc.all,
              icon: Icons.all_inbox,
              isSelected: _selectedFilter == LocalStorageKey.all,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.all);
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.unread,
              icon: Icons.mark_email_unread,
              isSelected: _selectedFilter == LocalStorageKey.unread,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.unread);
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.system,
              icon: Icons.campaign,
              isSelected: _selectedFilter == LocalStorageKey.system,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.system);
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.chat,
              icon: Icons.chat_bubble,
              isSelected: _selectedFilter == LocalStorageKey.chat,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.chat);
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.groups,
              icon: Icons.group,
              isSelected: _selectedFilter == LocalStorageKey.group,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.group);
                Navigator.pop(context);
              },
            ),
            FilterOption(
              title: context.loc.schedule,
              icon: Icons.schedule,
              isSelected: _selectedFilter == LocalStorageKey.schedule,
              onTap: () {
                setState(() => _selectedFilter = LocalStorageKey.schedule);
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
      SnackBar(
        content: Text(context.loc.mark_all_as_read),
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
}
