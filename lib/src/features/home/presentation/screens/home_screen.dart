import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/widgets/user_header_widget.dart';

import '../../../../router/route.dart';
import '../../../../core/presentation/widget/url_image.dart';
import '../../../../router/router.import.dart';
import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../timetable/data/datasources/timetable_remote_data_source.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<UserBloc>().add(const InitUserProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<_FunctionItem> functions = [
      _FunctionItem("Revise", Icons.grid_view, Colors.red.shade300, () {
        AppRoute.quiz.push(context);
      }),
      _FunctionItem("Module", Icons.menu_book, Colors.amber.shade400, () {}),
      _FunctionItem(
          "Academic result", Icons.emoji_events, Colors.blue.shade700, () {}),
      _FunctionItem("Student list", Icons.people, Colors.pink.shade200, () {}),
      _FunctionItem(
          "Pay tuition", Icons.attach_money, Colors.green.shade400, () {}),
      _FunctionItem(
          "School survey", Icons.poll, Colors.lightBlue.shade400, () {}),
      _FunctionItem("Instructor Evaluation", Icons.rate_review,
          Colors.deepOrange.shade300, () {}),
      _FunctionItem(
          "Academic advisor", Icons.person_pin, Colors.red.shade700, () {}),
    ];
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          toolbarHeight: 52.h,
          floating: true,
          snap: true,
          title: Text(
            context.loc.home,
            style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.surface,
                fontWeight: FontWeight.w600),
          ),
          expandedHeight: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 100.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff52C755),
                  Color(0xff43B446),
                  Color(0xff33A036),
                  Color(0xff248D27),
                ],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ],
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  User user = state.user;
                  return UserHeaderWidget(user: user);
                } else {
                  return SizedBox(height: 200.h);
                }
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Functions",
                  style: context.textTheme.headlineMedium
                      ?.copyWith(color: context.colorScheme.onSurface),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 6.w,
                mainAxisSpacing: 3.h,
                childAspectRatio: 2,
                children: functions.map((item) => _FunctionCard(item)).toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: ElevatedButton(
                onPressed: () async {
                  await getIt<TimetableRemoteDataSource>().testNotification();
                },
                child: Text('Test Notification'),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }
}

class _FunctionItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _FunctionItem(this.title, this.icon, this.color, this.onTap);
}

class _FunctionCard extends StatelessWidget {
  final _FunctionItem item;

  const _FunctionCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: item.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              Icon(item.icon, color: context.colorScheme.onPrimary, size: 34.r),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  item.title,
                  style: context.textTheme.bodyLarge
                      ?.copyWith(color: context.colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
