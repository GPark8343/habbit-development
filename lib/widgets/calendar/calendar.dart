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

    _getAttendanceDate() async {
      attendanceDate = [];

      items.forEach(
          (story) => attendanceDate.add(DateTime.parse(story.createdAt)));
    }

    void updateScreen() {
      setState(() {
        //마커 표시하게 화면 업데이트해주는 함수
      });
    }

    Future? first() async {
      await Provider.of<StoryManage>(context, listen: false)
          .fetchAndSetStories();

      await _getAttendanceDate();
      await Provider.of<MarkerManage>(context, listen: false)
          .updateAttendanceDate(attendanceDate);
      await Provider.of<MarkerManage>(context, listen: false).addMarker();
      updateScreen();
    }

    return FutureBuilder(
        future: first(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 360 * 120,
                child: Card(
                  color: mainColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 360 * 15),
                          child: Text(
                            '${widget.folder.title} 폴더 현황',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width /
                                    360 *
                                    25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 360 * 25,
                        ),
                        Row(
                          children: [
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '스토리 수:  ',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      360 *
                                      15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${attendanceProgress}',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width /
                                      360 *
                                      30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 360 * 420,
                child: TableCalendar(
                  locale: 'ko_KR', // 추가
                  firstDay: DateTime.utc(2021, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 360 * 20,
                          color: mainColor,
                          fontWeight: FontWeight.w800)),
                  calendarStyle: CalendarStyle(
                      markerSize:
                          MediaQuery.of(context).size.width / 360 * 13.0,
                      markerDecoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icons/check.png')),
                          color: Colors.yellow,
                          shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      todayTextStyle: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width / 360 * 20,
                          color: textColor,
                          fontWeight: FontWeight.bold)),
                  eventLoader: _getEventsForDay,
                ),
              ),
            ],
          );
        });
  }
}
