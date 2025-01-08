import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';

import '../../bloc/theme_bloc.dart';
import '../../utils/change_theme_bottom_sheet.dart';

class ButtonChangeTheme extends StatelessWidget {
  const ButtonChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      width: 60.w,
      child: OutlinedButton(
        onPressed: () => ThemeUtils.showThemeBottomSheet(
            navigatorKey.currentContext ?? context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 6.r),
          backgroundColor: context.colorScheme.surface,
          foregroundColor: context.colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.r),
              child: BlocBuilder<ThemeBloc, AppThemeState>(
                builder: (context, state) {
                  return SvgPicture.asset(
                    colorFilter: ColorFilter.mode(
                        context.colorScheme.onSurface, BlendMode.srcIn),
                    state.selectedTheme.image,
                    fit: BoxFit.fitHeight,
                    height: 32.h,
                  );
                },
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_drop_down_rounded,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
