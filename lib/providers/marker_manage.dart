import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';

class Event {
  String title;

  Event(this.title);
}

class MarkerManage extends ChangeNotifier {
  List<DateTime> attendanceDate = [];

  Map<DateTime, List<Event>> events = {};

  Future addMarker() async {
    events = {};

    attendanceDate.forEach((datetime) {
      events.addAll({
        DateTime.utc(datetime.year, datetime.month, datetime.day): [Event('')]
      });
    });
  
    notifyListeners();
  }

  updateAttendanceDate(List<DateTime> pickedAttendanceDate) async {
    attendanceDate = pickedAttendanceDate;
    notifyListeners();
  }
}
