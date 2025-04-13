import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                height: 72,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    UrlImage.circle(
                      user.avatarUrl,
                      size: 48,
                    ),
                    SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullname,
                          style: context.textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
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
              height: 72,
              child: Shimmer.fromColors(
                baseColor: Colors.red,
                highlightColor: Colors.blue,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 12,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
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
