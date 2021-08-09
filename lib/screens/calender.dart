import 'package:flutter/material.dart';
import 'package:fruitapp/models/calender_model.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(),
      body: Container(child: Consumer<CalenderModel>(
        builder: (context, data, child) {
          return TableCalendar(
            calendarController: data.controller,
            initialSelectedDay:
                // The selected day that is visible to the user when they open
                // the calender
                Provider.of<DayModel>(context, listen: false).currentDate,
            onDaySelected: (DateTime selected, _, __) {
              // When a day is tapped on the calender, we get the datetime object
              // for that day and update our day model to reflect this.
              Provider.of<DayModel>(context, listen: false)
                  .setNewDate(selected);
              // Then we navigate to the day page to view it's fruits.
              Navigator.pushNamed(context, '/day');
            },
            events: data.datesWithFruits,
          );
        },
      )),
    );
  }
}
