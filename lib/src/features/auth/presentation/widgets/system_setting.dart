import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/localization/ui/widget/button_change_localization.dart';
import 'package:hubtsocial_mobile/src/core/theme/presentation/widget/button_change_theme.dart';

class SystemSetting extends StatelessWidget {
  const SystemSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          ButtonChangeLocalization(),
          SizedBox(height: 6),
          ButtonChangeTheme(),
        ],
      ),
    );
  }
}
