import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:lottie/lottie.dart';

import '../../configs/assets.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

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
            Assets.screenNotFound,
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
          SizedBox(height: 24),
          FilledButton(
              onPressed: () {
                context.pop();
              },
              child: Text("Go Home"))
        ],
      )),
    );
  }
}
