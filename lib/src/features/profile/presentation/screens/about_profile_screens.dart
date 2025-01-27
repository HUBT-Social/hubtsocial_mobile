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
        return Container(
          width: 536.w,
          height: 498.h,
          padding: EdgeInsets.only(
            top: 12.h,
            right: 10.w,
            bottom: 12.h,
            left: 10.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  context.loc.about_this_profile,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                context.loc.first_name,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  user?.firstName ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.loc.last_name,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  user?.lastName ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.loc.gender,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  user?.gender.toString() ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.loc.birth_of_date,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  user?.birthDay.toString() ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
