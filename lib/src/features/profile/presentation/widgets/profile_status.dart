import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ProfileStatus extends StatelessWidget {
  const ProfileStatus({
    super.key,
    required this.status,
    this.maxLength = 150,
    this.onTap,
  });

  final String status;
  final int maxLength;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        status.isEmpty ? 'Add bio' : status,
        style: context.textTheme.bodyMedium?.copyWith(
          color: status.isEmpty ? Colors.grey : Colors.black,
          fontSize: 14,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
