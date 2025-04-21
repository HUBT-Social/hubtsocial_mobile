import 'package:flutter/material.dart';

class TimerDisplayWidget extends StatelessWidget {
  final int seconds;

  const TimerDisplayWidget({
    Key? key,
    required this.seconds,
  }) : super(key: key);

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.timer, size: 20, color: Colors.orange),
        const SizedBox(width: 4),
        Text(
          _formatTime(seconds),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
