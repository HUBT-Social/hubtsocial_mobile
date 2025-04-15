import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
import 'package:hubtsocial_mobile/src/features/user/presentation/bloc/user_bloc.dart';
import 'package:shimmer/shimmer.dart';

class UserCardInMenu extends StatefulWidget {
  const UserCardInMenu({
    super.key,
  });

  @override
  State<UserCardInMenu> createState() => _UserCardInMenuState();
}

class _UserCardInMenuState extends State<UserCardInMenu> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.colorScheme.surfaceContainerHighest,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserProfileLoaded) {
            User user = state.user;
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => AppRoute.profile.push(context),
              child: SizedBox(
                height: 72.h,
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    UrlImage.circle(
                      user.avatarUrl,
                      size: 48.r,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullname,
                          style: context.textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          context.loc.see_your_personal_page,
                          style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              height: 72.h,
              child: Shimmer.fromColors(
                baseColor: context.colorScheme.surfaceContainerLowest,
                highlightColor: context.colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Container(
                      height: 48.r,
                      width: 48.r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    SizedBox(width: 12.h),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          height: 12.h,
                          width: 180.w,
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
