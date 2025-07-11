import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/button_back.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/widgets/system_setting.dart';

import '../widgets/background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  State<AuthScreen> createState() => _AuthScreenScreenState();
}

class _AuthScreenScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const Background(),
        widget.child,
        const SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonBack(),
              SystemSetting(),
            ],
          ),
        ),
      ],
    ));
  }
}
