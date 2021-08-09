import 'package:flutter/material.dart';
import 'package:fruitapp/widgets/appbar.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetablePage extends StatelessWidget {
  TimetablePage({Key key}) : super(key: key);

  // Controller for the timetable and the eventlist.
  // Copied verbatim from the documentation.
  final myController = TimetableController(
    eventProvider: EventProvider.list([
      BasicEvent(
        id: 0,
        title: 'A simple event',
        color: Colors.blue,
        start: LocalDate.today().at(LocalTime(13, 0, 0)),
        end: LocalDate.today().at(LocalTime(15, 0, 0)),
      ),
      BasicEvent(
        id: 1,
        title: 'An multi-day event',
        color: Colors.red,
        start: LocalDate.dateTime(DateTime.now().subtract(Duration(days: 4)))
            .at(LocalTime(13, 0, 0)),
        end: LocalDate.dateTime(DateTime.now().subtract(Duration(days: 2)))
            .at(LocalTime(13, 0, 0)),
      ),
      BasicEvent(
        id: 2,
        title: 'An event',
        color: Colors.yellow,
        start: LocalDate.dateTime(DateTime.now().subtract(Duration(days: 1)))
            .at(LocalTime(14, 0, 0)),
        end: LocalDate.dateTime(DateTime.now().subtract(Duration(days: 1)))
            .at(LocalTime(17, 0, 0)),
      ),
    ]),
    // Optional parameters with their default values:
    initialTimeRange: InitialTimeRange.range(
      startTime: LocalTime(8, 0, 0),
      endTime: LocalTime(20, 0, 0),
    ),
    initialDate: LocalDate.today(),
    visibleRange: VisibleRange.week(),
    firstDayOfWeek: DayOfWeek.monday,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(),
      body: SafeArea(
        child: Container(
          child: Timetable<BasicEvent>(
            controller: myController,
            eventBuilder: (event) => BasicEventWidget(event),
            allDayEventBuilder: (context, event, info) =>
                BasicAllDayEventWidget(event, info: info),
          ),
        ),
      ),
    );
  }
}
