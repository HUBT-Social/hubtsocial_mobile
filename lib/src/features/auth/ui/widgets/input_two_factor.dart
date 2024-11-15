import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/ui/input/input_field.dart';

class InputAuthOTP extends StatelessWidget {
  const InputAuthOTP({
    super.key,
    required this.otpController,
  });

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 52,
      child: InputField.otp(
        context: context,
        controller: otpController,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
