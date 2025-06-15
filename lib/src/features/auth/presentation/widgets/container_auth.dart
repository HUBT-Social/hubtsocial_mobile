import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ContainerAuth extends StatefulWidget {
  const ContainerAuth({required this.children, super.key});
  final List<Widget> children;

  @override
  State<ContainerAuth> createState() => _ContainerAuthState();
}

class _ContainerAuthState extends State<ContainerAuth> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: 320.w,
        padding:
            EdgeInsets.only(right: 12.w, left: 12.w, top: 24.h, bottom: 36.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadiusDirectional.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withAlpha(128),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          spacing: 12.h,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.children,
        ),
      ),
    );
  }
}
