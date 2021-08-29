import 'package:flutter/material.dart';
import 'package:fruitapp/Dialog/NameFruitDialogComponents/NameFruitDialog.dart';
import 'package:fruitapp/models/initialize_database.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/lanuguage_model.dart';
import 'package:fruitapp/models/name_fruit_dialog_model.dart';
import 'package:fruitapp/widgets/appbar.dart';
import 'package:fruitapp/widgets/view_page_item.dart';
import 'package:provider/provider.dart';

class DayPage extends StatefulWidget {
  const DayPage();

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(),
      // Consumer for listening to any changes in the day's data.
      body: Consumer<DayModel>(
        builder: (_, data, __) {
          // Fetch the fruits that have been stored against the current day.
          Provider.of<FruitModel>(context, listen: false)
              .refresh(data.currentDate)
              .then((value) {
            Provider.of<LanguageModel>(context, listen: false)
                .setLanguage(Localizations.localeOf(context).languageCode);
          });

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

                              // Display the fruits that have been stored for
                              // the current page.
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: fruitData.fetchedList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                                      child: ViewPageItemWidget(
                                          fruit: fruitData.fetchedList[index]),
                                    );
                                  }),
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
          Provider.of<InitializeModel>(context, listen: false)
              .initializeDatabase(context)
              .then((value) => {
                    Provider.of<NameFruitModel>(context, listen: false)
                        .refresh()
                  });
          showDialog(
              context: context,
              builder: (context) {
                Provider.of<FruitModel>(context, listen: false)
                    .fruitToBeReplaced = null;

                return NameFruitDialog();
              }).then((value) => {
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
