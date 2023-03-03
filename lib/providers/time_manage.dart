import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';

class TimeManage with ChangeNotifier {
 int howManyDaysPassed(Folder folder) {
    int folderYear = DateTime.parse(folder.createdAt).year;
    int folderMonth = DateTime.parse(folder.createdAt).month;
    int folderDay = DateTime.parse(folder.createdAt).day;

    int yearDifference = DateTime.now().year - folderYear;
    int monthDifference = DateTime.now().month - folderMonth;
    int dayDifference = DateTime.now().day - folderDay;
    // int minuteDifference = DateTime.now().minute - DateTime.parse(folder.createdAt).minute;
    int allDifferenceTypeOfDay =
        365 * yearDifference + 12 * monthDifference + dayDifference;

    print(allDifferenceTypeOfDay);
    return allDifferenceTypeOfDay;
  }

  int _seconds = 86400; // 하루에 86400초임
  bool _isRunning = false;
  Timer? _timer;

  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      _seconds++;
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
