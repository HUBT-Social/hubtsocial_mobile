import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/utils/validators.dart';

class InputAuthOTP extends StatelessWidget {
  const InputAuthOTP({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 60,
      width: 52,
      textStyle: context.textTheme.bodyLarge,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorScheme.outline),
      ),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: 6,
        autofocus: true,
        controller: controller,
        onCompleted: onCompleted,
        validator: Validators.otp,
        showCursor: false,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 60,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: context.colorScheme.primary),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colorScheme.error),
          ),
        ),
        errorTextStyle: context.textTheme.labelMedium
            ?.copyWith(color: context.colorScheme.error),
      ),
    );
  }
}
