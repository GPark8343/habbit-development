import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;

  Event(this.title);
}

class Calendar extends StatefulWidget {
  final Folder folder;
  const Calendar(this.folder);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> events = {
    DateTime.utc(2023, 3, 01): [Event('')],
    DateTime.utc(2023, 3, 02): [Event('')],
  };
  // void addAll() {
  //   int folderYear = DateTime.parse(widget.folder.createdAt).year;
  //   String folderMonth = DateTime.parse(widget.folder.createdAt).month < 10
  //       ? '0${DateTime.parse(widget.folder.createdAt).month.toString()}'
  //       : DateTime.parse(widget.folder.createdAt).month.toString();
  //   String folderDay = DateTime.parse(widget.folder.createdAt).day < 10
  //       ? '0${DateTime.parse(widget.folder.createdAt).day.toString()}'
  //       : DateTime.parse(widget.folder.createdAt).day.toString();

  //   DateTime folderCreatedAt =
  //       DateTime.parse('${folderYear}-${folderMonth}-${folderDay} 00:00:00');

  //   for (int i = 0; i < widget.folder.days; i++) {
  //     events.addAll({
  //       folderCreatedAt.add(const Duration(days: 1)): [Event('')]
  //     });
  //   }
  // }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.folder.title} 폴더의 days: ${widget.folder.days.toString()}'),
        TableCalendar(
          locale: 'ko_KR', // 추가
          firstDay: DateTime.utc(2021, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w800)),
          calendarStyle: CalendarStyle(
              markerSize: 10.0,
              markerDecoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              todayTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          eventLoader: _getEventsForDay,
        ),
      ],
    );
  }
}
