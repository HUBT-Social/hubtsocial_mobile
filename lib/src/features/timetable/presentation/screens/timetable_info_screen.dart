import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/extensions/string.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/background.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/timetable_type.dart';
import 'package:hubtsocial_mobile/src/features/timetable/presentation/bloc/timetable_info_bloc.dart';

import '../../../../constants/assets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      // appBar: AppBar(
      //   backgroundColor: context.colorScheme.surface,
      //   title: Text(
      //     "Thông tin thời khóa biểu",
      //     textAlign: TextAlign.center,
      //     style: context.textTheme.headlineSmall?.copyWith(
      //       color: context.colorScheme.onSurface,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   actions: [],
      // ),
      body: BlocBuilder<TimetableInfoBloc, TimetableInfoState>(
        builder: (context, state) {
          if (state is TimetableInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TimetableInfoError) {
            return SafeArea(
              child: Center(
                child:
                    Text(state.message, style: context.textTheme.titleMedium),
              ),
            );
          }
          if (state is InitTimetableInfoSuccess) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  // snap: true,
                  // pinned: true,
                  // floating: true,
                  expandedHeight: 240.h,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding:
                        EdgeInsetsDirectional.only(start: 16.w, bottom: 16.h),
                    centerTitle: false,
                    background: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24.r),
                      ),
                      child: Image.asset(
                        Assets.startedBg,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      state.timetableInfoModel.subject == null
                          ? state.timetableInfoModel.type.toString()
                          : state.timetableInfoModel.subject!.capitalizeFirst(),
                      style: TextStyle(
                        color: context.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            state.timetableInfoModel.subject == null
                                ? state.timetableInfoModel.type.toString()
                                : state.timetableInfoModel.subject!
                                    .capitalizeFirst(),
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        if (state.timetableInfoModel.type != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: state.timetableInfoModel.type?.color,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              state.timetableInfoModel.type!.name,
                              style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.onPrimary),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  padding: EdgeInsets.only(top: 24.h, left: 12.w, right: 12.w),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("data"),
                      Text("data"),
                      Text("data"),
                      Text("data"),
                      Text("data"),
                      Text("data"),
                      Text("data"),
                      Text("data"),
                    ],
                  ),
                )),
                SliverToBoxAdapter(
                    child: Container(
                        color: context.colorScheme.surface, height: 10000.h)),
                SliverToBoxAdapter(
                  child: Container(
                    color: context.colorScheme.surface,
                    height: 100.h,
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: Text("No data"),
          );
        },
      ),
    );
  }
}
