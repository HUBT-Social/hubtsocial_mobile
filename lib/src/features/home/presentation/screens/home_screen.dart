import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/assets.dart';
import '../../../../router/route.dart';
import '../../../../core/presentation/widget/url_image.dart';
import '../../../main_wrapper/presentation/widgets/main_app_bar.dart';
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
                        size: 256,
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
              width: 120,
              height: 120,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.amber,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.screenNotFound),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.passwordSuccessful),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.verificationWaiting),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.success),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.wrongInput),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.writeInput),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.paidSuccess),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              width: 500,
              child: Lottie.asset(AppLotties.paidFailed),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 500,
              color: Colors.red,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 800,
              color: Colors.blue,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 400,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
