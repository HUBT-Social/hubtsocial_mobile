import 'package:flutter/material.dart';
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
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          width: 536,
          height: 498,
          padding: EdgeInsets.only(
            top: 12,
            right: 10,
            bottom: 12,
            left: 10,
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
              SizedBox(height: 4),
              Text(
                context.loc.first_name,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user?.firstName ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8),
              Text(
                context.loc.last_name,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user?.lastName ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8),
              Text(
                context.loc.gender,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user?.gender.toString() ?? '',
                  style: context.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 8),
              Text(
                context.loc.birth_of_date,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
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
