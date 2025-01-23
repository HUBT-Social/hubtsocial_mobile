import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:provider/provider.dart';

final class AboutProfileUtils {
  AboutProfileUtils._();

  static void showAboutProfileBottomSheet(BuildContext context) {
    final user = context.read<UserProvider>().user;

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(12.r),
          child: SafeArea(
            left: false,
            right: false,
            top: false,
            child: SingleChildScrollView(
              // Thêm widget cuộn
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'About this profile',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoItem(
                    context,
                    'First name',
                    user?.firstName ?? '',
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoItem(
                    context,
                    'Last name',
                    user?.lastName ?? '',
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoItem(
                    context,
                    'Email',
                    user?.email ?? '',
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoItem(
                    context,
                    'Gender',
                    (user?.gender ?? '').toString(),
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoItem(
                    context,
                    'Date of birth',
                    (user?.birthDay ?? '').toString(),
                  ),
                  SizedBox(height: 6.h),
                  _buildInfoItem(
                    context,
                    'Phone number',
                    user?.phoneNumber ?? '',
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildInfoItem(
      BuildContext context, String label, String value) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.r),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall,
          ),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
