import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationModel notification;
  final double size;

  const NotificationIcon({
    required this.notification,
    this.size = 70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notificationType = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';
    final avatarUrl = notification.data?['avatarUrl']?.toString();
    final imageUrl = notification.data?['imageUrl']?.toString();
    final isGroupMessage = notification.data?['isGroupMessage'] == true;

    // Ưu tiên imageUrl, nếu không có thì lấy avatarUrl
    final String? mainImage = (imageUrl?.isNotEmpty == true) ? imageUrl : null;

    if (mainImage != null && mainImage.isNotEmpty) {
      String smallIconPath;
      if (notificationType == 'chat' || notificationType == 'profile') {
        smallIconPath = AppIcons.notificationGroupChat;
      } else if (notificationType == 'maintenance') {
        smallIconPath = AppIcons.notificationSystemMaintenance;
      } else if (notificationType == 'schedule' ||
          notificationType == 'timetable') {
        smallIconPath = AppIcons.notificationTimetable;
      } else if (notificationType == 'exam') {
        smallIconPath = AppIcons.notificationTimetable;
      } else {
        smallIconPath = AppIcons.notificationAdmin;
      }
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: mainImage,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: size,
                    height: size,
                    child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/icons/ic_profile.png',
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.40,
                height: size * 0.40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    smallIconPath,
                    width: size * 0.40,
                    height: size * 0.40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Nếu không có ảnh, giữ nguyên icon lớn như cũ
    String imagePath;
    switch (notificationType) {
      case 'broadcast':
        imagePath = AppIcons.notificationAdmin;
        break;
      case 'profile':
        imagePath = AppIcons.notificationChat;
        break;
      case 'learning_alerts':
      case 'academic_warning':
        imagePath = AppIcons.notificationSubjectWarning;
        break;
      case 'schedule':
      case 'timetable':
        imagePath = AppIcons.notificationTimetable;
        break;
      case 'exam':
        imagePath = AppIcons.notificationTimetable;
        break;
      case 'maintenance':
        imagePath = AppIcons.notificationSystemMaintenance;
        break;
      case 'chat':
        imagePath = AppIcons.notificationGroupChat;
        break;
      default:
        imagePath = AppIcons.notificationAdmin;
    }

    return SvgPicture.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
