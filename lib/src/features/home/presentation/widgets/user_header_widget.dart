import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_role.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app/providers/user_provider.dart';

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
              gradient: const LinearGradient(
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
            child: Icon(
              context.read<UserProvider>().mainRole.icon,
              size: 30.r,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class UserHeaderShimmer extends StatelessWidget {
  const UserHeaderShimmer({super.key});

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
              gradient: const LinearGradient(
                colors: [
                  Color(0xff52C755),
                  Color(0xff43B446),
                  Color(0xff33A036),
                  Color(0xff248D27),
                ],
              ),
              boxShadow: [
                BoxShadow(blurRadius: 4, color: context.colorScheme.shadow)
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70.r,
                        height: 70.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 100.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 80.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
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
        ),
        // GPA circle shimmer
        Positioned(
          right: 24.w,
          bottom: 12.h,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12.r,
                    color: context.colorScheme.shadow.withAlpha(128),
                  ),
                ],
              ),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
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
