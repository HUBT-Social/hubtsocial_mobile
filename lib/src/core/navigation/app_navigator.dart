import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/navigation/router.dart';
import '../ui/dialog/app_dialog.dart';

class AppNavigator {
  static void pauseAndPushScreen({
    required BuildContext context,
    required String routeName,
    required int delayTime,
    Map<String, dynamic>? arguments,
    Object? extra,
  }) {
    Timer(
      Duration(seconds: delayTime),
      () {
        AppDialog.closeDialog();
        context.go(
          parseRoute(
            route: '/$routeName',
            queryParameters: arguments,
          ),
          extra: extra,
        );
      },
    );
  }

  static void pauseAndPopScreen({
    required BuildContext context,
    required int delayTime,
  }) {
    Timer(
      Duration(seconds: delayTime),
      () {
        AppDialog.closeDialog();
        context.pop();
      },
    );
  }

  static void pauseAndPushNewScreenWithoutBack({
    required BuildContext context,
    required String routname,
    required int delayTime,
    Map<String, dynamic>? arguments,
    Object? extra,
  }) {
    Timer(
      Duration(seconds: delayTime),
      () {
        AppDialog.closeDialog();
        while (context.canPop()) {
          context.pop();
        }
        context.pushReplacement(
          parseRoute(
            route: '/$routname',
            queryParameters: arguments,
          ),
          extra: extra,
        );
      },
    );
  }
}
