import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                        size: 256.r,
                      ),
                      Center(
                          child: Text("UserProfileLoaded: ${user.firstName}")),
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
        ],
      ),
    );
  }
}
