import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/features/profile/presentation/widgets/base_action_button.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    super.key,
    this.onFollowPressed,
    this.onSharePressed,
  });

  final VoidCallback? onFollowPressed;
  final VoidCallback? onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BaseActionButton(
              text: context.loc.follow,
              onPressed: onFollowPressed ??
                  () {
                    AppRoute.editprofile.path;
                  },
              backgroundColor: context.colorScheme.primary,
              textColor: context.colorScheme.onPrimary),
        ),
        SizedBox(width: 8),
        Expanded(
          child: BaseActionButton(
              text: context.loc.share,
              onPressed: onFollowPressed ??
                  () {
                    AppRoute.editprofile.push(context);
                  },
              backgroundColor: context.colorScheme.primary,
              textColor: context.colorScheme.onPrimary),
        ),
      ],
    );
  }
}
