import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../bloc/localization_bloc.dart';
import '../models/language.dart';

final class LocalizatioUtils {
  LocalizatioUtils._();
  static void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SafeArea(
            left: false,
            right: false,
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    context.loc.choose_language,
                    textAlign: TextAlign.left,
                    style: context.textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 24.h),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 0.3.sh,
                  ),
                  child: Material(
                    child: BlocBuilder<LocalizationBloc, AppLocalizationState>(
                      builder: (context, state) {
                        return ListView.separated(
                          padding: EdgeInsets.only(bottom: 24.h),
                          shrinkWrap: true,
                          itemCount: Language.values.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                context.read<LocalizationBloc>().add(
                                    ChangeLanguage(
                                        selectedLanguage:
                                            Language.values[index]));
                                Future.delayed(
                                        const Duration(milliseconds: 300))
                                    .then((value) => context.pop());
                              },
                              leading: Image.asset(
                                Language.values[index].image,
                                height: 32.r,
                                width: 32.r,
                                fit: BoxFit.contain,
                              ),
                              title: Text(
                                Language.values[index].text,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: Language.values[index] ==
                                          state.selectedLanguage
                                      ? context.colorScheme.primary
                                      : context.colorScheme.outline,
                                ),
                              ),
                              trailing: Language.values[index] ==
                                      state.selectedLanguage
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: context.colorScheme.primary,
                                    )
                                  : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: Language.values[index] ==
                                        state.selectedLanguage
                                    ? BorderSide(
                                        color: context.colorScheme.primary,
                                      )
                                    : BorderSide(
                                        color: context.colorScheme.outline,
                                      ),
                              ),
                              tileColor: Language.values[index] ==
                                      state.selectedLanguage
                                  ? context.colorScheme.primary
                                      .withOpacity(0.05)
                                  : null,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
