import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/configs/assets.dart';
import '../../../../core/navigation/route.dart';

class PasswordSuccessfulScreen extends StatefulWidget {
  const PasswordSuccessfulScreen({super.key});

  @override
  State<PasswordSuccessfulScreen> createState() =>
      _PasswordSuccessfulScreenState();
}

class _PasswordSuccessfulScreenState extends State<PasswordSuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 347,
            width: 360,
            child: Lottie.asset(AppLotties.passwordSuccessful),
          ),
          SizedBox(height: 30),
          Text(
            context.loc.password_change_successful,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 38),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                AppRoute.signIn.go(context);
              },
              child: Text(
                context.loc.sign_in,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
