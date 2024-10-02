import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/theme_extension.dart';

class NavigationItem extends StatelessWidget {
  final IconData icon;

  const NavigationItem({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 18.sp,
      color: context.colorScheme.onSurface,
    );
  }
}
