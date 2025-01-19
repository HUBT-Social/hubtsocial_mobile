import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'base_action_button.dart';

class Profile2ActionButtons extends StatelessWidget {
  const Profile2ActionButtons({
    super.key,
    this.onEditPressed,
    this.onSharePressed,
    this.onAddPersonPressed,
  });

  final VoidCallback? onEditPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onAddPersonPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BaseActionButton(
            text: 'Edit profile',
            onPressed: onEditPressed,
            backgroundColor: Colors.lightGreen[100],
            textColor: Colors.black,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: BaseActionButton(
            text: 'Share profile',
            onPressed: onSharePressed,
            backgroundColor: Colors.lightGreen[100],
            textColor: Colors.black,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: BaseActionButton(
            text: 'Add person',
            onPressed: onAddPersonPressed,
            backgroundColor: Colors.lightGreen[100],
            textColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
