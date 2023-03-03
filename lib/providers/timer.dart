import 'dart:async';

import 'package:flutter/material.dart';

class Time with ChangeNotifier {
  int _seconds = 86400; // 하루에 86400초임
  bool _isRunning = false;
  Timer? _timer;

  int get seconds => _seconds;
  bool get isRunning => _isRunning;
 

  startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      _seconds--;
      notifyListeners();
    });
  }

  stopTimer() {
    _isRunning = false;
    _timer!.cancel();
    notifyListeners();
  }

  resetTimer() {
    _seconds = 86400; // 하루에 86400초임
    notifyListeners();
  }
}
