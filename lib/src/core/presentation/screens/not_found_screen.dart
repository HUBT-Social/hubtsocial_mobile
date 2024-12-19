import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/router/route.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/assets.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key, required this.url});

  final String? url;
  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Screen not found",
            style: context.textTheme.displaySmall,
          ),
          Lottie.asset(
            AppLotties.screenNotFound,
            fit: BoxFit.contain,
            height: 360,
            width: 360,
          ),
          Text(
            "Oh no!",
            style: context.textTheme.displaySmall,
          ),
          Text(
            "May be bigfoot has broken this page",
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            kDebugMode ? widget.url ?? "" : "",
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          FilledButton(
              onPressed: () {
                try {
                  context.pop();
                } catch (e) {
                  AppRoute.home.go(context);
                }
              },
              child: Text("Go Home"))
        ],
      )),
    );
  }
}
