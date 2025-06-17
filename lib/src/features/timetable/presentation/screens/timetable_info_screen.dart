import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/core/presentation/dialog/app_dialog.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/timetable_type.dart';
import 'package:hubtsocial_mobile/src/features/timetable/presentation/bloc/timetable_info_bloc.dart';
import 'package:hubtsocial_mobile/src/features/timetable/presentation/widgets/timetable_member_card.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/assets.dart';
import '../../../../core/presentation/widget/url_image.dart';

class TimetableInfoScreen extends StatefulWidget {
  const TimetableInfoScreen({required this.id, super.key});
  final String id;

  @override
  State<TimetableInfoScreen> createState() => _TimetableInfoScreenState();
}

class _TimetableInfoScreenState extends State<TimetableInfoScreen> {
  @override
  void initState() {
    context
        .read<TimetableInfoBloc>()
        .add(InitTimetableInfoEvent(timetableId: widget.id));

    super.initState();
  }

  final CarouselController lecturerController =
      CarouselController(initialItem: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocBuilder<TimetableInfoBloc, TimetableInfoState>(
        builder: (context, state) {
          if (state is TimetableInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TimetableInfoError) {
            return SafeArea(
              child: Center(
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    backgroundColor:
                        context.colorScheme.surfaceContainerHighest,
                    title: Text(context.loc.timetable),
                    automaticallyImplyLeading: true,
                  ),
                  SliverToBoxAdapter(
                    child: Text(state.message,
                        style: context.textTheme.titleMedium),
                  )
                ]),
              ),
            );
          }
          if (state is InitTimetableInfoSuccess) {
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      // snap: true,
                      // pinned: true,
                      // floating: true,
                      expandedHeight: 240.h,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsetsDirectional.only(
                            start: 16.w, bottom: 16.h),
                        centerTitle: false,
                        background: Container(
                          color: context.colorScheme.surfaceContainerHighest,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(48.r),
                            ),
                            child: Image.asset(
                              Assets.startedBg,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          state.timetableInfoModel.subject == null
                              ? state.timetableInfoModel.type.toString()
                              : state.timetableInfoModel.subject!
                                  .capitalizeFirst(),
                          style: TextStyle(
                            color: context.colorScheme.surface,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding:
                            EdgeInsets.only(top: 24.h, left: 12.w, right: 12.w),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.r),
                            bottomRight: Radius.circular(24.r),
                          ),
                        ),
                        child: Column(
                          spacing: 12.h,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 6.w,
                                  children: [
                                    Icon(
                                      Icons.token,
                                      color: context.colorScheme.primary,
                                      size: 24.r,
                                    ),
                                    Text(
                                      context.loc.credits(
                                          state.timetableInfoModel.creditNum ??
                                              0),
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                if (state.timetableInfoModel.type != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color:
                                          state.timetableInfoModel.type?.color,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      state.timetableInfoModel.type!.name,
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: context
                                                  .colorScheme.onPrimary),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              spacing: 6.w,
                              children: [
                                Icon(
                                  Icons.room,
                                  color: context.colorScheme.primary,
                                  size: 24.r,
                                ),
                                Text(
                                  state.timetableInfoModel.room!
                                      .capitalizeFirst(),
                                  style: context.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6.w,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  color: context.colorScheme.primary,
                                  size: 24.r,
                                ),
                                Text(
                                  state.timetableInfoModel.className!
                                      .capitalizeFirst(),
                                  style: context.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            if (state.timetableInfoModel.startTime != null)
                              Row(
                                spacing: 12.w,
                                children: [
                                  Expanded(
                                    child: Row(
                                      spacing: 6.w,
                                      children: [
                                        Icon(
                                          Icons.timer_rounded,
                                          color: context.colorScheme.primary,
                                          size: 24.r,
                                        ),
                                        Text(
                                          DateFormat.yMd().format(state
                                                  .timetableInfoModel
                                                  .startTime ??
                                              DateTime.now()),
                                          style: context.textTheme.bodyLarge,
                                        ),
                                        Text(
                                          DateFormat.jm().format(state
                                                  .timetableInfoModel
                                                  .startTime ??
                                              DateTime.now()),
                                          style: context.textTheme.bodyLarge,
                                        ),
                                        if (state.timetableInfoModel.endTime !=
                                            null)
                                          Text(
                                            "-",
                                            style: context.textTheme.bodyLarge,
                                          ),
                                        if (state.timetableInfoModel.endTime !=
                                            null)
                                          Text(
                                            DateFormat.jm().format(state
                                                    .timetableInfoModel
                                                    .endTime ??
                                                DateTime.now()),
                                            style: context.textTheme.bodyLarge,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            if (state.timetableInfoModel.zoomId!.isNotEmpty)
                              Row(
                                spacing: 12.w,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 6.w,
                                    children: [
                                      FilledButton(
                                          onPressed: () async {
                                            if (!await launchUrl(
                                              Uri.parse(
                                                  'https://zoom.us/j/${state.timetableInfoModel.zoomId}'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            )) {
                                              AppDialog.showMessageDialog(
                                                AppDialog.errorMessage(
                                                    context.loc
                                                        .zoom_cannot_be_accessed(
                                                            state
                                                                .timetableInfoModel
                                                                .zoomId!),
                                                    context),
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.h),
                                            child: Row(
                                              spacing: 6.w,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.voice_chat_rounded,
                                                  color: context
                                                      .colorScheme.onPrimary,
                                                  size: 24.r,
                                                ),
                                                Text(
                                                  state.timetableInfoModel
                                                      .zoomId!
                                                      .capitalizeFirst(),
                                                  style: context
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .onPrimary),
                                                ),
                                              ],
                                            ),
                                          )),
                                      IconButton(
                                        onPressed: () {
                                          if (state.timetableInfoModel.zoomId !=
                                              null) {
                                            Clipboard.setData(ClipboardData(
                                                text: state.timetableInfoModel
                                                    .zoomId!));
                                            context.showSnackBarMessage(
                                                context.loc.copied);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.copy,
                                          color: context.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 6.h)
                          ],
                        ),
                      ),
                    ),
                    if (state.timetableInfoModel.teacherleMembers.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 96.h),
                            child: CarouselView.weighted(
                              onTap: (index) {
                                final teacherleMember = state
                                    .timetableInfoModel.teacherleMembers[index];
                                AppRoute.userProfileDetails.push(
                                  navigatorKey.currentContext!,
                                  queryParameters: {
                                    "userName": teacherleMember.userName,
                                  },
                                );
                              },
                              flexWeights: state.timetableInfoModel
                                          .teacherleMembers.length >
                                      1
                                  ? [1, 8, 1]
                                  : [1],
                              itemSnapping: true,
                              consumeMaxWeight: false,
                              children: state
                                  .timetableInfoModel.teacherleMembers
                                  .map((teacherleMember) {
                                return ColoredBox(
                                  color: context
                                      .colorScheme.surfaceContainerHighest,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: UrlImage.circle(
                                            teacherleMember.avatarUrl ?? "",
                                            size: 48.r,
                                          ),
                                        ),
                                        SizedBox(width: 12.h),
                                        Flexible(
                                          child: Text(
                                            teacherleMember.fullName ?? "",
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                              color:
                                                  context.colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.clip,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 3.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.r),
                            topRight: Radius.circular(24.r),
                          ),
                          child: ExpansionTile(
                            minTileHeight: 52.h,
                            tilePadding: EdgeInsets.symmetric(horizontal: 18.w),
                            leading: Icon(
                              Icons.format_list_bulleted,
                              color: context.colorScheme.primary,
                              size: 24.r,
                            ),
                            title: Text(
                              context.loc.student_list,
                              style: context.textTheme.bodyLarge,
                            ),
                            collapsedBackgroundColor:
                                context.colorScheme.surfaceContainerHighest,
                            backgroundColor:
                                context.colorScheme.surfaceContainerHighest,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            collapsedShape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            children:
                                state.timetableInfoModel.studentMembers.map(
                              (member) {
                                return TimetableMemberCard(
                                  memberModel: member,
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 3.h),
                        height: 54.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: const BorderRadius.only(
                              // topLeft: Radius.circular(24.r),
                              // topRight: Radius.circular(24.r),
                              // bottomLeft: Radius.circular(24.r),
                              // bottomRight: Radius.circular(24.r),
                              ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                                // topLeft: Radius.circular(24.r),
                                // topRight: Radius.circular(24.r),
                                // bottomLeft: Radius.circular(24.r),
                                // bottomRight: Radius.circular(24.r),
                                ),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.content_paste_search,
                                    size: 24.r,
                                    color: context.colorScheme.primary,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    context.loc.content,
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 3.h),
                        height: 54.h,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.only(
                            // topLeft: Radius.circular(24.r),
                            // topRight: Radius.circular(24.r),
                            bottomLeft: Radius.circular(24.r),
                            bottomRight: Radius.circular(24.r),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(24.r),
                              // topRight: Radius.circular(24.r),
                              bottomLeft: Radius.circular(24.r),
                              bottomRight: Radius.circular(24.r),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.rate_review_rounded,
                                    size: 24.r,
                                    color: context.colorScheme.primary,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    context.loc.evaluate,
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 120.h,
                      ),
                    ),
                  ],
                ),
                if (state.timetableInfoModel.chatRoomId != null &&
                    state.timetableInfoModel.chatRoomId!.isNotEmpty)
                  Positioned(
                    bottom: 72.h,
                    right: 24.w,
                    child: FloatingActionButton(
                      onPressed: () {
                        AppRoute.roomChat.push(navigatorKey.currentContext!,
                            queryParameters: {
                              "id": state.timetableInfoModel.chatRoomId
                            });
                      },
                      child: const Icon(Icons.message),
                    ),
                  ),
              ],
            );
          }
          return Center(
            child: Text(context.loc.no_data),
          );
        },
      ),
    );
  }
}
