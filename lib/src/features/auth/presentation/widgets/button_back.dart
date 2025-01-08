import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ButtonBack extends StatefulWidget {
  const ButtonBack({
    super.key,
  });

  @override
  State<ButtonBack> createState() => _ButtonBackState();
}

class _ButtonBackState extends State<ButtonBack> {
  @override
  Widget build(BuildContext context) {
    late bool canPop = context.canPop();

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (canPop != context.canPop()) {
        setState(() {
          canPop = context.canPop();
        });
      }
    });
    return canPop
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: context.colorScheme.surface,
              size: 32.dg,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {}
            },
          )
        : SizedBox();
  }
}
