import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: const [
          NavigationItem(icon: Icons.home_filled),
          NavigationItem(icon: Icons.notifications),
          NavigationItem(icon: Icons.person),
        ],
        color: Theme.of(context).colorScheme.tertiaryContainer,
        buttonBackgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.surface,
        animationCurve: Curves.easeOutQuint,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _goBranch(index);
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final IconData icon;

  const NavigationItem({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 28.r,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
