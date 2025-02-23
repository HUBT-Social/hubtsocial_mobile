import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/constants/assets.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/datasources/chat_hub_connection.dart';

import '../../chat/presentation/bloc/receive_chat/receive_chat_cubit.dart';
import 'widgets/navigation_item.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  void changeNavigation(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    ChatHubConnection.initHubConnection(
      onReceiveChat: (message) =>
          context.read<ReceiveChatCubit>().receiveMessage(message),
    );
    super.initState();
  }

  @override
  void dispose() {
    ChatHubConnection.stopHubConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: CurvedNavigationBar(
        key: bottomNavigationKey,
        index: widget.navigationShell.currentIndex,
        items: const [
          NavigationItem(file: AppIcons.iconHome),
          NavigationItem(file: AppIcons.iconChat),
          NavigationItem(file: AppIcons.iconTimetable),
          NavigationItem(file: AppIcons.iconNotification),
          NavigationItem(file: AppIcons.iconMenu),
        ],
        color: context.colorScheme.surfaceDim,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeOutQuint,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          changeNavigation(index);
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
