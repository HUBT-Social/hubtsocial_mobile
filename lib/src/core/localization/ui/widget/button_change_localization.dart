import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/localization/utils/change_language_bottom_sheet.dart';

import '../../bloc/localization_bloc.dart';

class ButtonChangeLocalization extends StatelessWidget {
  const ButtonChangeLocalization({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 60.w,
      child: OutlinedButton(
        onPressed: () => LocalizatioUtils.showLanguageBottomSheet(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(8.r),
          backgroundColor: context.colorScheme.surface,
          foregroundColor: context.colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            BlocBuilder<LocalizationBloc, AppLocalizationState>(
              builder: (context, state) {
                return Image.asset(
                  state.selectedLanguage.image,
                  fit: BoxFit.fitHeight,
                  height: 32,
                  width: 32,
                );
              },
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