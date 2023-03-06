import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';

class TimeManage with ChangeNotifier {

  int howManyDaysPassed(Folder folder) {
    
    int folderYear = DateTime.parse(folder.createdAt).year;
    String folderMonth = DateTime.parse(folder.createdAt).month < 10
        ? '0${DateTime.parse(folder.createdAt).month.toString()}'
        : DateTime.parse(folder.createdAt).month.toString();
    String folderDay = DateTime.parse(folder.createdAt).day < 10
        ? '0${DateTime.parse(folder.createdAt).day.toString()}'
        : DateTime.parse(folder.createdAt).day.toString();

    DateTime folderCreatedAt =
        DateTime.parse('${folderYear}-${folderMonth}-${folderDay} 00:00:00');
    // '2012-02-27 13:27:00'
    // int minuteDifference = DateTime.now().minute - DateTime.parse(folder.createdAt).minute;
    var allDifferenceTypeOfDay = -DateTime(
            folderCreatedAt.year,
            folderCreatedAt.month,
            folderCreatedAt.day,
            folderCreatedAt.hour,
            folderCreatedAt.minute,
            folderCreatedAt.second)
        .difference(DateTime.now())
        .inDays;

  
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