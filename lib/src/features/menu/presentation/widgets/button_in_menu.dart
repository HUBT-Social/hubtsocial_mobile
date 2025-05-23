import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class ButtonInMenu extends StatefulWidget {
  const ButtonInMenu({
    super.key,
    this.borderRadiusTop = 0,
    this.borderRadiusBottom = 0,
    required this.icon,
    required this.label,
    required this.iconArrow,
    required this.onTap,
  });

  final Widget icon;
  final Widget iconArrow;
  final String label;
  final double borderRadiusTop;
  final double borderRadiusBottom;
  final GestureTapCallback? onTap;

  @override
  State<ButtonInMenu> createState() => _ButtonInMenuState();
}

class _ButtonInMenuState extends State<ButtonInMenu> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.borderRadiusTop),
              topRight: Radius.circular(widget.borderRadiusTop),
              bottomLeft: Radius.circular(widget.borderRadiusBottom),
              bottomRight: Radius.circular(widget.borderRadiusBottom),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadiusTop),
                topRight: Radius.circular(widget.borderRadiusTop),
                bottomLeft: Radius.circular(widget.borderRadiusBottom),
                bottomRight: Radius.circular(widget.borderRadiusBottom),
              ),
              onTap: widget.onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.icon,
                        SizedBox(width: 12.w),
                        Text(
                          widget.label,
                          style: context.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    widget.iconArrow
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
