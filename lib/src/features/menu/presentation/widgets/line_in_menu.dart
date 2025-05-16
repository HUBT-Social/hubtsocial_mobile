import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class LineInMenu extends StatelessWidget {
  const LineInMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Container(
          color: context.colorScheme.outlineVariant,
          height: 2.h,
          width: double.infinity,
        ),
      ),
    );
  }
}
