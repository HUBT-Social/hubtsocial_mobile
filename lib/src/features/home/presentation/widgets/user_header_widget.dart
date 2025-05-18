import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

class UserHeaderWidget extends StatelessWidget {
  final User user;

  const UserHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: _SlantClipper(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                left: 20.w, top: 12.h, right: 20.w, bottom: 50.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff52C755),
                  Color(0xff43B446),
                  Color(0xff33A036),
                  Color(0xff248D27),
                ],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(blurRadius: 4, color: context.colorScheme.shadow)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UrlImage.circle(
                      user.avatarUrl,
                      size: 70.r,
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullname,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            user.userName,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            "aaaaa",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        // GPA circle
        Positioned(
          right: 24.w,
          bottom: 12.h,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 12.r,
                    color: context.colorScheme.shadow.withAlpha(128)),
              ],
            ),
            child: Text(
              "35.4",
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height); // Bottom-left
    path.lineTo(size.width, size.height - 50.h); // Bottom-right higher
    path.lineTo(size.width, 0); // Top-right
    path.close(); // Back to start (0,0)
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
