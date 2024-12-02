import 'package:flutter/material.dart';
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
    return SvgPicture.asset(
      file,
      width: 36,
      height: 36,
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
          context.colorScheme.onSurfaceVariant, BlendMode.srcIn),
    );
  }
}
