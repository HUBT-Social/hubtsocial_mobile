import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/features/wrapper/presentation/widgets/navigation_item.dart';
import 'package:hubtsocial_mobile/src/utils/extensions/theme_extension.dart';

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
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 60,
        index: 0,
        items: const [
          NavigationItem(icon: Icons.home_filled),
          NavigationItem(icon: Icons.notifications),
          NavigationItem(icon: Icons.person),
        ],
        color: context.colorScheme.surface,
        backgroundColor: Colors.transparent,
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
