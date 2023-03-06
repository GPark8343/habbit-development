import 'package:flutter/material.dart';
import 'package:habbit/colors.dart';
import 'package:habbit/models/folder.dart';
import 'package:habbit/models/story.dart';
import 'package:habbit/providers/marker_manage.dart';
import 'package:habbit/providers/story_manage.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final Folder folder;
  const Calendar(this.folder);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  //

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

  @override
  Widget build(BuildContext context) {
    List<DateTime> attendanceDate =
        Provider.of<MarkerManage>(context, listen: false).attendanceDate;
    Map events = Provider.of<MarkerManage>(context, listen: false).events;

    List<Event> _getEventsForDay(DateTime day) {
      return events[day] ?? [];
    }

    List<Story> items = Provider.of<StoryManage>(context, listen: false)
        .items
        .where((element) => element.folderId == widget.folder.id)
        .toList();
    int attendanceProgress = items.length;

    Future<List<DateTime>>? _getAttendanceDate() {
      attendanceDate = [];
      print('${items}이거 보고 싶어');
      items.forEach(
          (story) => attendanceDate.add(DateTime.parse(story.createdAt)));
      Provider.of<MarkerManage>(context, listen: false)
          .updateAttendanceDate(attendanceDate);
      print('${attendanceDate}이거 보고 싶어');
    }

    Future? first() async {
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();
      await _getAttendanceDate();
      await Provider.of<MarkerManage>(context, listen: false).addMarker();
      return null;
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Text('${attendanceProgress}/${widget.folder.days}'),
              Text(
                  '${widget.folder.title} 폴더의 days: ${widget.folder.days.toString()}'),
              SizedBox(
                height: MediaQuery.of(context).size.width / 360 * 30,
              ),
              TableCalendar(
                locale: 'ko_KR', // 추가
                firstDay: DateTime.utc(2021, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 20,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w800)),
                calendarStyle: CalendarStyle(
                    markerSize: 10.0,
                    markerDecoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 360 * 20,
                        color: textColor,
                        fontWeight: FontWeight.bold)),
                eventLoader: _getEventsForDay,
              ),
            ],
          );
        });
  }
}
