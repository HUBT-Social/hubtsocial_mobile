import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class NavigationItem extends StatelessWidget {
  final String file;

  const NavigationItem({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.r),
      child: SvgPicture.asset(
        file,
        width: 24.r,
        height: 24.r,
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(context.colorScheme.onSurface, BlendMode.srcIn),
      ),
    );
  }
}
