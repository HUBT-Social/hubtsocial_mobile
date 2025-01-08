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
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.r),
        child: Container(
          padding:
              EdgeInsets.only(right: 24.r, left: 24.r, top: 24.r, bottom: 36.r),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withAlpha(128),
                blurRadius: 4.r,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
