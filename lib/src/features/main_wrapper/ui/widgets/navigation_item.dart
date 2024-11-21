import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

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
      size: 24,
      color: context.colorScheme.onSurfaceVariant,
    );
  }
}
