import 'package:flutter/material.dart';
import 'package:fruitapp/Dialog/NameFruitDialog.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/screens/categorySize.dart';
import 'package:fruitapp/widgets/mlkg.dart';
import 'package:provider/provider.dart';

import '../Fruit.dart';
import 'mlkg_dialog.dart';

// The selections a user can make when they click on the option button
// present at the right side of ViewPageItemWidget.
enum PopupSelection { information, change, delete }

// This widget is shown in the ListViews present on the Day page.
class ViewPageItemWidget extends StatelessWidget {
  // The fruit that is shown.
  final Fruit fruit;
  // Controller for comment field.
  final TextEditingController commentController = new TextEditingController();

  ViewPageItemWidget({@required this.fruit});

  @override
  Widget build(BuildContext context) {
    commentController.text = fruit.comment == null ? "" : fruit.comment;

    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 50,
                    height: 150,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      // Image of the fruits is fruit is obtained by stitching
                      // together paths present in the assets page.


                      child: Image.asset(fruit.imageSource),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              fruit.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(fruit.type,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18))
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  final TextEditingController
                                      dialogEditingController =
                                      new TextEditingController();

                                  dialogEditingController.text = fruit.comment;

                                  return AlertDialog(
                                    content: Container(
                                        child: TextField(
                                      maxLines: 5,
                                      minLines: 1,
                                      controller: dialogEditingController,
                                      decoration: InputDecoration(
                                        labelText: 'Fruit Comment',
                                        labelStyle: TextStyle(
                                          color: Color(0xFF6200EE),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFF6200EE)),
                                        ),
                                      ),
                                    )),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            fruit.comment =
                                                dialogEditingController.text;

                                            Provider.of<FruitModel>(context,
                                                    listen: false)
                                                .updateFruit(fruit)
                                                .then((value) => Navigator.of(
                                                        context,
                                                        rootNavigator: true)
                                                    .pop());
                                          },
                                          child: Text('Update')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop(context);
                                          },
                                          child: Text('Cancel')),
                                    ],
                                  );
                                });
                          },
                          child: TextField(
                            enabled: false,
                            controller: commentController,
                            decoration:
                                const InputDecoration(hintText: "comments"),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: fruit.mlkg.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddUpdateMLKGDialog(
                                              fruit: fruit,
                                              mlkg: fruit.mlkg[index]);
                                        });
                                  },
                                  child: MLKGWidget(
                                    kg: fruit.mlkg[index].kg != null
                                        ? fruit.mlkg[index].kg
                                        : "-",
                                    ml: fruit.mlkg[index].ml != null
                                        ? fruit.mlkg[index].ml
                                        : "-",
                                    no: index + 1,
                                  ),
                                );
                                // else
                                //   return IconButton(
                                //       alignment: Alignment.centerLeft,
                                //       icon: Icon(Icons.add),
                                //       onPressed: () {
                                //         showDialog(
                                //             context: context,
                                //             builder: (context) {
                                //               return AddMLKGDialog(fruit: fruit);
                                //             });
                                //       });
                              }),
                        ),
                      ],
                    ),
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: Container(
                    width: 55,
                    height: 150,
                    alignment: Alignment.center,
                    // More button opens up a popup with several options.
                    child: PopupMenuButton(
                      onSelected: (PopupSelection result) async {
                        if (result == PopupSelection.change) {
                          // If the user wants to change the fruit type, then
                          // a dialog is shown to the user.
                          showDialog(
                                  context: context,
                                  builder: (_){
                                    Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced = fruit;
                                    return NameFruitDialog();
                                  });
                        } else if (result == PopupSelection.information) {
                          Navigator.of(context)
                              // If the user wants to get more information about
                              // a page then the detail page is opened.
                              .pushNamed('/detail', arguments: fruit);
                        } else {
                          // Else if the user wants to delete the current fruit,
                          // then delete is called on the Fruit model and then
                          // the fruits list is refreshed.
                          Provider.of<FruitModel>(context, listen: false)
                              .deleteFruit(fruit)
                              .then((value) {
                            Provider.of<FruitModel>(context, listen: false)
                                .refresh(Provider.of<DayModel>(context,
                                        listen: false)
                                    .currentDate);
                          });
                        }
                      },
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<PopupSelection>>[
                        const PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text("Information"),
                          ),
                          value: PopupSelection.information,
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
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AddUpdateMLKGDialog(fruit: fruit);
                        });
                  }),
              CategorySize(selected: fruit.categorySize, clickEnable: false),
            ],
          ),
        ],
      ),
    );
  }
}
