import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class AnswerOptionWidget extends StatefulWidget {
  final String text;
  final int index;
  final int? selectedIndex;
  final int? correctIndex;
  final VoidCallback onTap;

  const AnswerOptionWidget({
    super.key,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
    required this.onTap,
  });

  @override
  State<AnswerOptionWidget> createState() => _AnswerOptionWidgetState();
}

class _AnswerOptionWidgetState extends State<AnswerOptionWidget> {
  Color _getColor() {
    if (widget.correctIndex == null) return context.colorScheme.onSurface;

    if (widget.index == widget.correctIndex) return context.colorScheme.primary;
    if (widget.index == widget.selectedIndex &&
        widget.index != widget.correctIndex) {
      return context.colorScheme.error;
    }

    return context.colorScheme.onSurfaceVariant;
  }

  IconData? _getIcon() {
    if (widget.correctIndex == null) return null;

    if (widget.index == widget.correctIndex) return Icons.check;
    if (widget.index == widget.selectedIndex &&
        widget.index != widget.correctIndex) {
      return Icons.close;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.text,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: color,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
