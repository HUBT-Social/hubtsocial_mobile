import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/localization/ui/widget/button_change_localization.dart';
import 'package:hubtsocial_mobile/src/core/theme/presentation/widget/button_change_theme.dart';

class SystemSetting extends StatelessWidget {
  const SystemSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        spacing: 6.h,
        children: const [
          ButtonChangeLocalization(),
          ButtonChangeTheme(),
        ],
      ),
    );
  }
}
