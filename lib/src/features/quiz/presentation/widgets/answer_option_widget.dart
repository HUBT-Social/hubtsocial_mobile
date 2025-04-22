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
    Key? key,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnswerOptionWidget> createState() => _AnswerOptionWidgetState();
}

class _AnswerOptionWidgetState extends State<AnswerOptionWidget> {
  Color _getColor() {
    if (widget.correctIndex == null) return Colors.grey[800]!;

    if (widget.index == widget.correctIndex) return context.colorScheme.primary;
    if (widget.index == widget.selectedIndex &&
        widget.index != widget.correctIndex) {
      return context.colorScheme.error;
    }

    return Colors.grey[700]!;
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

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12.w),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}
