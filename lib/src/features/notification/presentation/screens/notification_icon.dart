import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationModel notification;
  final double size;

  const NotificationIcon({
    required this.notification,
    this.size = 70,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationType = notification.type?.toLowerCase() ??
        notification.data?['type']?.toString().toLowerCase() ??
        '';
    final avatarUrl = notification.data?['avatarUrl']?.toString();
    final imageUrl = notification.data?['imageUrl']?.toString();
    final isGroupMessage = notification.data?['isGroupMessage'] == true;

    // Ưu tiên avatarUrl, nếu không có thì lấy imageUrl
    final String? mainImage = (avatarUrl?.isNotEmpty == true)
        ? avatarUrl
        : (imageUrl?.isNotEmpty == true ? imageUrl : null);

    if (mainImage != null && mainImage.isNotEmpty) {
      String smallIconPath;
      if (notificationType == 'chat' || notificationType == 'profile') {
        smallIconPath = isGroupMessage
            ? AppIcons.notificationGroupChat
            : AppIcons.notificationChat;
      } else if (notificationType == 'maintenance') {
        smallIconPath = AppIcons.notificationSystemMaintenance;
      } else {
        smallIconPath = AppIcons.notificationAdmin;
      }
      return SizedBox(
        width: size + 8,
        height: size + 8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: ClipOval(
                child: Image.network(
                  mainImage,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/ic_profile.png',
                      width: size,
                      height: size,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    smallIconPath,
                    width: size * 0.35,
                    height: size * 0.35,
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
        imagePath = isGroupMessage
            ? AppIcons.notificationGroupChat
            : AppIcons.notificationChat;
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
