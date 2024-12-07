import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends ChangeNotifier {
  late Timer _timer;
  int _remainingSeconds;
  final int _initialSeconds;

  CountdownTimer({required int seconds})
      : _remainingSeconds = seconds,
        _initialSeconds = seconds;

  int get remainingSeconds => _remainingSeconds;

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void start(Function onComplete) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer.cancel();
        onComplete();
      }
    });
  }

  void reset() {
    _timer.cancel();
    _remainingSeconds = _initialSeconds;
    //notifyListeners();

    void cancel() {
      _timer.cancel();
    }

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }
  }
}
