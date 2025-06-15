import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_provider.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';

import '../../../../core/presentation/widget/url_image.dart';
import '../../data/models/timetable_info_member_model.dart';

class TimetableMemberCard extends StatefulWidget {
  const TimetableMemberCard({
    required this.memberModel,
    super.key,
  });
  final TimetableInfoMemberModel memberModel;

  @override
  State<TimetableMemberCard> createState() => _TimetableMemberCardState();
}

class _TimetableMemberCardState extends State<TimetableMemberCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey<String>(widget.memberModel.userName.toString()),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          if (context.read<UserProvider>().isTeacher)
            SlidableAction(
              onPressed: (context) {
                AppRoute.profile.push(
                  context,
                  queryParameters: {
                    "userName": widget.memberModel.userName,
                  },
                );
              },
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icons.info,
              label: context.loc.information,
            ),
          if (context.read<UserProvider>().isTeacher)
            SlidableAction(
              onPressed: (context) {
                context.showSnackBarMessage("Sinh viên đã có mặt");
              },
              backgroundColor: context.colorScheme.tertiary,
              foregroundColor: context.colorScheme.onTertiary,
              icon: Icons.check,
              label: context.loc.present,
            ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          if (context.read<UserProvider>().isTeacher)
            SlidableAction(
              onPressed: (context) {
                context.showSnackBarMessage("Sinh viên đã vắng mặt");
              },
              backgroundColor: context.colorScheme.errorContainer,
              foregroundColor: context.colorScheme.onErrorContainer,
              icon: Icons.close,
              label: context.loc.absent,
            ),
          if (context.read<UserProvider>().isTeacher)
            SlidableAction(
              onPressed: (context) {
                context.showSnackBarMessage("Sinh viên đã bị cấm thi");
              },
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
              icon: Icons.block,
              label: context.loc.exam_ban,
            ),
        ],
      ),
      child: InkWell(
        onTap: () {
          AppRoute.profile.push(
            context,
            queryParameters: {
              "userName": widget.memberModel.userName,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  if (widget.memberModel.avatarUrl != null)
                    UrlImage.circle(
                      widget.memberModel.avatarUrl ?? "",
                      size: 48.r,
                    ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    height: 14.r,
                    width: 14.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colorScheme.surface,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.memberModel.fullName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelLarge
                            ?.copyWith(color: context.colorScheme.onSurface),
                      ),
                      Text(
                        widget.memberModel.userName ?? "",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: context.textTheme.labelMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
