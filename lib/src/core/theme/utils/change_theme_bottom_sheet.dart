import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

import '../bloc/theme_bloc.dart';
import '../models/theme_model.dart';

final class ThemeUtils {
  ThemeUtils._();
  static void showThemeBottomSheet(BuildContext context) {
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
          padding: EdgeInsets.all(12.r),
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
                    textAlign: TextAlign.left,
                    context.loc.choose_theme,
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 12.h),
                BlocBuilder<ThemeBloc, AppThemeState>(
                  builder: (context, state) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: ThemeModel.values.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            context.read<ThemeBloc>().add(ChangeTheme(
                                selectedTheme: ThemeModel.values[index]));
                            Future.delayed(const Duration(milliseconds: 300))
                                .then((value) => context.pop());
                          },
                          leading: SvgPicture.asset(
                            colorFilter: ColorFilter.mode(
                                context.colorScheme.onSurface, BlendMode.srcIn),
                            ThemeModel.values[index].image,
                            height: 32.h,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            switch (ThemeModel.values[index]) {
                              ThemeModel.system => context.loc.theme_system,
                              ThemeModel.light => context.loc.theme_light,
                              ThemeModel.dark => context.loc.theme_dark,
                            },
                            style: context.textTheme.titleMedium?.copyWith(
                              color: ThemeModel.values[index] ==
                                      state.selectedTheme
                                  ? context.colorScheme.primary
                                  : context.colorScheme.outline,
                            ),
                          ),
                          trailing:
                              ThemeModel.values[index] == state.selectedTheme
                                  ? Icon(
                                      Icons.check_circle_rounded,
                                      color: context.colorScheme.primary,
                                    )
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side:
                                ThemeModel.values[index] == state.selectedTheme
                                    ? BorderSide(
                                        color: context.colorScheme.primary,
                                      )
                                    : BorderSide(
                                        color: context.colorScheme.outline,
                                      ),
                          ),
                          tileColor: ThemeModel.values[index] ==
                                  state.selectedTheme
                              ? context.colorScheme.primary.withOpacity(0.05)
                              : null,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 12.h);
                      },
                    );
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
