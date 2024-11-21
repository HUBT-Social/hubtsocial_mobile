import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

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
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  void changeNavigation(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        // height: 75,
        index: 0,
        items: const [
          NavigationItem(icon: Icons.home_filled),
          NavigationItem(icon: Icons.newspaper),
          NavigationItem(icon: Icons.calendar_month),
          NavigationItem(icon: Icons.notifications),
          NavigationItem(icon: Icons.menu),
        ],
        color: context.colorScheme.surfaceContainerHighest,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeOutQuint,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            changeNavigation(index);
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
