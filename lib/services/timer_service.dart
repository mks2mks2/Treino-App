// lib/services/timer_service.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  int _seconds = 90;
  int _maxSeconds = 90;
  bool _running = false;
  String? _exerciseId;

  int get seconds => _seconds;
  int get maxSeconds => _maxSeconds;
  bool get running => _running;
  bool get isActive => _exerciseId != null;
  bool get isLow => _seconds <= 10 && _seconds > 0;
  bool get isDone => _seconds == 0;
  String? get exerciseId => _exerciseId;

  double get progress =>
      _maxSeconds > 0 ? 1.0 - (_seconds / _maxSeconds) : 0.0;

  String get display {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void start(int seconds, String exerciseId) {
    _timer?.cancel();
    _seconds = seconds;
    _maxSeconds = seconds;
    _exerciseId = exerciseId;
    _running = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer t) {
    if (_seconds > 0) {
      _seconds--;
      notifyListeners();
      if (_seconds == 0) {
        _running = false;
        t.cancel();
        notifyListeners();
      }
    }
  }

  void toggle() {
    if (_running) {
      _timer?.cancel();
      _running = false;
    } else if (_seconds > 0) {
      _running = true;
      _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    }
    notifyListeners();
  }

  void addTime([int extra = 10]) {
    _seconds = (_seconds + extra).clamp(0, 599);
    if (_seconds > _maxSeconds) _maxSeconds = _seconds;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _running = false;
    _seconds = _maxSeconds;
    notifyListeners();
  }

  void dismiss() {
    _timer?.cancel();
    _running = false;
    _exerciseId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
