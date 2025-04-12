import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class LineInMenu extends StatelessWidget {
  const LineInMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        color: context.colorScheme.outlineVariant,
        height: 2,
        width: double.infinity,
      ),
    );
  }
}
