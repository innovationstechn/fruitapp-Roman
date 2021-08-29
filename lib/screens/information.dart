import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Dialog/NameFruitDialogComponents/NameFruitDialog.dart';
import 'package:fruitapp/Model_Classes/Fruit.dart';
import 'package:fruitapp/models/calender_model.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/screens/detail.dart';
import 'package:fruitapp/screens/statistics.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {

  @override
  Widget build(BuildContext context) {
    // Extract the arguments (i.e the fruit that has been selected) from the
    // route.
    Fruit fruit = ModalRoute.of(context).settings.arguments;

    // Default tab controller for tabs in information page.
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // Refer to appbar.dart for info, most of this is same.
            actions: [
              IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    CalenderModel calenderModel =
                        Provider.of<CalenderModel>(context, listen: false);

                    if (ModalRoute.of(context).settings.name == "/calender" &&
                        calenderModel.isCalenderOpen) {
                      Navigator.pop(context);
                      calenderModel.isCalenderOpen = false;
                    } else {
                      calenderModel.refreshEvents();
                      Navigator.pushNamed(context, '/calender');
                      calenderModel.isCalenderOpen = true;
                    }
                  }),

              // Refer to ViewPageItem.dart for detail for this popup button
              // This button is the same as the 'more' button there.
              PopupMenuButton(
                onSelected: (PopupSelection result) async {
                  if (result == PopupSelection.change) {
                    showDialog(
                            context: context,
                            builder: (_) {
                              Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced = fruit;
                              return NameFruitDialog();
                            })
                        .then((value) => () {
                              Provider.of<FruitModel>(context, listen: false)
                                  .refresh(Provider.of<DayModel>(context,
                                          listen: false)
                                      .currentDate);
                            });
                  } else if (result == PopupSelection.statistics) {
                  } else {
                    Provider.of<FruitModel>(context, listen: false)
                        .deleteFruit(fruit)
                        .then((value) {
                      Provider.of<FruitModel>(context, listen: false).refresh(
                          Provider.of<DayModel>(context, listen: false)
                              .currentDate);
                      Navigator.pop(context);
                    });
                  }
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<PopupSelection>>[
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.bar_chart),
                      title: Text("Information"),
                    ),
                    value: PopupSelection.statistics,
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text("Change to another"),
                    ),
                    value: PopupSelection.change,
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.clear),
                      title: Text("Remove Fruit"),
                    ),
                    value: PopupSelection.delete,
                  ),
                ],
              )
            ],
            title: Consumer<DayModel>(
              builder: (_, data, __) {
                return Text(
                    "${data.currentDate.day}/${data.currentDate.month}/${data.currentDate.year}");
              },
            ),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Information',
                ),
                Tab(
                  text: 'Statistics',
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                DetailPage(),
                Consumer<FruitModel>(
                  builder: (context, data, child) {
                    return FutureBuilder(
                      future: DatabaseQuery.db.getFruit(fruit.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                          ));

                        // Extract lists of data that needs to be displayed in
                        // the statistics page.
                        List<String> itemNumbers = [];
                        List<String> kgInItems = [];
                        List<String> mlInItems = [];

                        for (int i = 0; i < snapshot.data.mlkg.length; i++) {
                          itemNumbers.add((i+1).toString());
                          kgInItems.add(snapshot.data.mlkg[i].kg);
                          mlInItems.add(snapshot.data.mlkg[i].ml);
                        }

                        return Statistics(
                            noYValues: itemNumbers,
                            mlYValues: mlInItems,
                            kgYValues: kgInItems,
                            time: snapshot.data.time);
                        ;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}