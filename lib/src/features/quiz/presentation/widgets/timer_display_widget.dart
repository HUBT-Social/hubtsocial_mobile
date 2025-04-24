import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';

class TimerDisplayWidget extends StatelessWidget {
  final TimerController controller;

  const TimerDisplayWidget({super.key, required this.controller});

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Text(
          _formatTime(controller.elapsedSeconds),
          style: context.textTheme.bodyLarge
              ?.copyWith(color: context.colorScheme.primary),
        );
      },
    );
  }
}

class TimerController extends ChangeNotifier {
  bool _isRunning = false;
  int _elapsedSeconds = 0;
  Timer? _timer;

  int get elapsedSeconds => _elapsedSeconds;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
