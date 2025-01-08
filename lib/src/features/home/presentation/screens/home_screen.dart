import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../router/route.dart';
import '../../../../core/presentation/widget/url_image.dart';
import '../../../main_wrapper/ui/widgets/main_app_bar.dart';
import '../../../user/domain/entities/user.dart';
import '../../../user/presentation/bloc/user_bloc.dart';

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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        MainAppBar(
          title: context.loc.home,
        )
      ],
      body: CustomScrollView(
        // controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  context.userProvider.initUser(state.user);
                  User user = state.user;
                  return Column(
                    children: [
                      UrlImage.square(
                        user.avatarUrl,
                        size: 256.dm,
                      ),
                      Center(
                          child: Text("UserProfileLoaded: ${user.lastName}")),
                    ],
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
          ),
          // Text(context.userProvider.user!.avatarUrl),
          SliverToBoxAdapter(
            child: FilledButton(
                onPressed: () {
                  AppRoute.profile.go(context);
                },
                child: Text("go profile")),
          ),
          SliverToBoxAdapter(
            child: FilledButton(
                onPressed: () {
                  AppRoute.menu.go(context);
                },
                child: Text("go menu")),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              onPressed: () {
                context.push("/location");
              },
              child: Text("aaaaaaaa"),
            ),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              onPressed: () {
                context.pushReplacement("/location");
              },
              child: Text("aaaaaaaa"),
            ),
          ),
          SliverToBoxAdapter(
            child: Image.asset(
              Assets.appIcon,
              width: 120.w,
              height: 120.h,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200.h,
              color: Colors.amber,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.screenNotFound),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.passwordSuccessful),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.verificationWaiting),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.success),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.wrongInput),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.writeInput),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.paidSuccess),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700.h,
              width: 500.w,
              child: Lottie.asset(AppLotties.paidFailed),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 500.h,
              color: Colors.red,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 800.h,
              color: Colors.blue,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 400.h,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
