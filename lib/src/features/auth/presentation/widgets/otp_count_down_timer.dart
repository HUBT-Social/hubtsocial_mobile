import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:intl/intl.dart';

class OtpCountDownTimer extends StatelessWidget {
  const OtpCountDownTimer({
    super.key,
    required this.countdownTimerController,
  });

  final CountdownTimerController countdownTimerController;

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      controller: countdownTimerController,
      widgetBuilder: (_, time) {
        if (time == null) {
          return Text(
            context.loc.otp_expire_message,
            style: context.textTheme.labelLarge
                ?.copyWith(color: context.colorScheme.error),
          );
        }

        var numberFormat = NumberFormat("00");

        String min = time.min != null ? numberFormat.format(time.min) : "0";

        String sec = time.sec != null ? numberFormat.format(time.sec) : "00";

        return Text(
          context.loc.the_code_will('$min:$sec'),
          style: context.textTheme.labelLarge
              ?.copyWith(color: context.colorScheme.primary),
        );
      },
    );
  }
}
