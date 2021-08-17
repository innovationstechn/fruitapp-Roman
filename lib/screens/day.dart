import 'package:flutter/material.dart';
import 'package:fruitapp/Dialog/NameFruitDialog.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/name_fruit_diialog_model.dart';
import 'package:fruitapp/widgets/appbar.dart';
import 'package:fruitapp/widgets/view_page_item.dart';
import 'package:provider/provider.dart';

class DayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(),
      // Consumer for listening to any changes in the day's data.
      body: Consumer<DayModel>(
        builder: (_, data, __) {
          // Fetch the fruits that have been stored against the current day.
          Provider.of<FruitModel>(context, listen: false)
              .refresh(data.currentDate);
          // PageView allows us to scroll horizontally.
          return PageView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      // Consumer for detecting any changes to the fruits
                      // associated with the current day.
                      child: Consumer<FruitModel>(
                        builder: (context, fruitData, child) {
                          // Halfway scrolling to other pages makes a circular
                          // progress bar appear on them.
                          if (data.currentIndex != index)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          // Fully scrolling to those pages causes fruits
                          // to appear there.
                          return Column(
                            children: [
                              // Note: for all these list views, the following
                              // information is equally true:

                              // 1. physics: NeverScrollableScrollPhysics disables
                              // ListViews own scroll bar, so that the page can
                              // be scrolled instead.

                              // 2. shrinkWrap: true guards against infinite
                              // height

                              // Display the apples that have been stored for
                              // the current page.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fruitData.apple.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                      child: ViewPageItemWidget(
                                          fruit: fruitData.apple[index]),
                                    );
                                  }),

                              // Display the pears that have been stored for
                              // the current page.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fruitData.pear.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                      child: ViewPageItemWidget(
                                          fruit: fruitData.pear[index]),
                                    );
                                  }),

                              // Display the watermelons that have been stored for
                              // the current page.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fruitData.watermelon.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                      child: ViewPageItemWidget(
                                          fruit: fruitData.watermelon[index]),
                                    );
                                  }),

                              // Display the bananas that have been stored for
                              // the current page.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fruitData.banana.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                      child: ViewPageItemWidget(
                                          fruit: fruitData.banana[index]),
                                    );
                                  })
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {
                // Inform the day model that the user has scrolled to another
                // page...
                Provider.of<DayModel>(context, listen: false)
                    .pageChanged(index);

                // ... and then fetch the new day's fruits.
                Provider.of<FruitModel>(context, listen: false).refresh(
                    Provider.of<DayModel>(context, listen: false).currentDate);
              },
              controller: PageController(
                  // The initial page that the ViewPage widget is on
                  // This is a large value, see DayModel class for more details.
                  initialPage: data.currentIndex,
                  viewportFraction: 1));
        },
      ),

      // FAB for adding fruits.
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          print("Initialize Database Called");
          Provider.of<NameFruitModel>(context, listen: false)
              .initializeDatabase()
              .then((value) => {
                    Provider.of<NameFruitModel>(context, listen: false)
                        .refresh()
                  });
          showDialog(
              context: context,
              builder: (context) {
                // Open up a dialog box with the current date as it's arguments
                // Current date is required for inserting data into the database.
                Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced = null;

                return NameFruitDialog();

              }).then((value) => {
                // After the dialog has been dismissed, clear the list of all
                // selected fruits selected in the dialog.

                // // In case the user added any fruits, refresh the current
                // page's fruit lists.
                Provider.of<FruitModel>(context, listen: false).refresh(
                    Provider.of<DayModel>(context, listen: false).currentDate)
              });
        },
      ),
    );
  }
}
