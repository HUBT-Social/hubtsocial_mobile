import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AboutProfileScreen extends StatelessWidget {
  const AboutProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;

    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: context.colorScheme.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About this profile',
          style: context.textTheme.headlineMedium?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 8.r),
        children: [
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
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
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
