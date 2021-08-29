import 'package:flutter/material.dart';
import 'package:fruitapp/models/calender_model.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/lanuguage_model.dart';
import 'package:provider/provider.dart';

// This app bar is standarised: it is present on almost every page
// except 1. Thus no need to redeclare it over and over again.
// Need to implement PreferredSizeWidget if I want to return AppBar from this
// widget.
class StandardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;

  StandardAppBar({this.tabBar});

  @override
  Widget build(BuildContext context) {

    return AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.calendar_today_outlined),
              onPressed: () {
                CalenderModel calenderModel =
                    Provider.of<CalenderModel>(context, listen: false);
                // If the calender is already open, then close it and set
                // the calenderModel's isCalenderOpen attribute to false.
                if (ModalRoute.of(context).settings.name == "/calender" &&
                    calenderModel.isCalenderOpen) {
                  Navigator.pop(context);
                  calenderModel.isCalenderOpen = false;
                } else {
                  // Else the calender needs to be opened.
                  calenderModel.refreshEvents();
                  Navigator.pushNamed(context, '/calender');
                  calenderModel.isCalenderOpen = true;
                }
              }),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => Navigator.pushNamed(context, '/timetable'),
          ),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
        ],
        title: Consumer<DayModel>(
          builder: (_, data, __) {
            // The current date is displayed on the app bar's title.
            // The date is fetched from the daymodel.
            return Text(
                "${data.currentDate.day}/${data.currentDate.month}/${data.currentDate.year}");
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        bottom: tabBar);
  }

  // Have to implement this method if I want to return AppBar. kToolBarHeight
  // is a variable present by default in the envoirnment, it represents the
  // height of the appbar.
  @override
  Size get preferredSize =>
      Size.fromHeight(tabBar == null ? kToolbarHeight : 2 * kToolbarHeight);
}
