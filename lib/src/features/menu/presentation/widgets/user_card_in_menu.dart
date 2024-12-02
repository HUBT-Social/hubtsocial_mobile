import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/navigation/route.dart';
import 'package:hubtsocial_mobile/src/core/presentation/widget/url_image.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
import 'package:hubtsocial_mobile/src/features/user/presentation/bloc/user_bloc.dart';

class UserCardInMenu extends StatelessWidget {
  const UserCardInMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.colorScheme.surfaceContainerHighest,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserProfileLoaded) {
            User user = state.user;
            return GestureDetector(
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
                            "Xem trang cá nhân",
                            style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  )),
            );
          } else if (state is UserProfileLoading) {
            return Center(child: Text("UserProfileLoading"));
          } else if (state is UserProfileInitial) {
            return Center(child: Text("UserProfileInitial"));
          } else {
            return Center(child: Text(state.toString()));
          }
        },
      ),
    );
  }
}
