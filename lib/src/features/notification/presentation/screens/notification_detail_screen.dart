import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'notification_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    if (!widget.notification.isRead) {
      widget.notification.isRead = true;
      final box = await Hive.openBox<NotificationModel>('notifications');
      await box.put(widget.notification.key, widget.notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final type = widget.notification.type?.toLowerCase() ??
          widget.notification.data?['type']?.toString().toLowerCase() ??
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

      final avatarUrl = widget.notification.data?['avatarUrl'];
      final imageUrl = widget.notification.data?['imageUrl'];
      // Avatar lớn phía trên
      Widget mainImageWidget = Center(
        child: NotificationIcon(notification: widget.notification, size: 100.r),
      );

      return Scaffold(
        appBar: AppBar(
          title: Text(title, style: TextStyle(fontSize: 18.sp)),
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainImageWidget,
                SizedBox(height: 24.h),
                // Box thông tin thông báo
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NotificationIcon(
                          notification: widget.notification, size: 60.r),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.notification.title ?? '',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              _formatTime(widget.notification.time, context),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Nội dung thông báo
                Text(
                  'Nội dung',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    widget.notification.body ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                // Hình ảnh (nếu có)
                if (imageUrl != null && imageUrl.toString().isNotEmpty) ...[
                  Text(
                    'Hình ảnh',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 300.h,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          height: 200.h,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.r),
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
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } catch (e, s) {
      print('Lỗi khi build NotificationDetailScreen: $e\n$s');
      return Scaffold(
        appBar: AppBar(title: Text('Lỗi', style: TextStyle(fontSize: 18.sp))),
        body: Center(
            child: Text('Có lỗi khi hiển thị thông báo',
                style: TextStyle(fontSize: 15.sp))),
      );
    }
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
