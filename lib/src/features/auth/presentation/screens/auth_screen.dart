import 'package:flutter/material.dart';
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
        Background(),
        widget.child,
        BackButton(),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SystemSetting(),
            ],
          ),
        ),
      ],
    ));
  }
}
