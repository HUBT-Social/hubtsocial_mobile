import 'package:flutter/material.dart';

class AnswerOptionWidget extends StatelessWidget {
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

  Color _getColor() {
    if (correctIndex == null) return Colors.grey[800]!;

    if (index == correctIndex) return Colors.green;
    if (index == selectedIndex && index != correctIndex) return Colors.red;

    return Colors.grey[700]!;
  }

  IconData? _getIcon() {
    if (correctIndex == null) return null;

    if (index == correctIndex) return Icons.check;
    if (index == selectedIndex && index != correctIndex) return Icons.close;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final icon = _getIcon();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
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
                text,
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
