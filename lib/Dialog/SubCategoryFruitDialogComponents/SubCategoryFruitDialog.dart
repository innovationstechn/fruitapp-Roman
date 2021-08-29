import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/lanuguage_model.dart';
import 'package:fruitapp/models/sub_name_fruit_dialog_model.dart';
import 'package:fruitapp/widgets/item_grid_mixin.dart';
import 'package:provider/provider.dart';

import 'SubNameFruitGridCard.dart';

class SubNameFruitDialog extends StatefulWidget {
  final List<GridCardSubNameFruit> list;

  SubNameFruitDialog({this.list});

  @override
  _SnameFruitDialog createState() => _SnameFruitDialog();
}

class _SnameFruitDialog extends State<SubNameFruitDialog> with ItemGridMixin {
  double dialogHorizontalWidth = 24;

  @override
  void initState() {
    Provider.of<SubNameFruitModel>(context, listen: false)
        .selectedElementForAddition = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalWidth, vertical: 24.0),
        child: Consumer<LanguageModel>(builder: (_, language, __) {
          return Column(mainAxisSize: MainAxisSize.max, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Navigator.of(context).pop();
                        })),
                Center(
                  child: Text(
                    widget.list.length > 0
                        ? language.translate(widget.list[0].subNameFruit.name)
                        : "",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04),
                  ),
                ),
                IconButton(
                    icon: dialogHorizontalWidth == 0
                        ? Icon(Icons.zoom_out)
                        : Icon(Icons.zoom_in),
                    onPressed: () {
                      setState(() {
                        dialogHorizontalWidth == 0
                            ? dialogHorizontalWidth = 24
                            : dialogHorizontalWidth = 0;
                      });
                    }),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: Container(
                  color: Colors.white,
                  child: gridViewBuilder(widget.list, (index) {}, () {})),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 15),
                    )),
                Provider.of<FruitModel>(context, listen: false)
                            .fruitToBeReplaced !=
                        null
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: RaisedButton(
                            color: Colors.lightGreen,
                            onPressed: () async {
                              DateTime currentDate =
                                  Provider.of<DayModel>(context, listen: false)
                                      .currentDate;

                              String fruitTypesRejected = await Provider.of<
                                      SubNameFruitModel>(context, listen: false)
                                  .addSelectedListToDB(
                                      "${currentDate.day}/${currentDate.month}/${currentDate.year}");

                              if (fruitTypesRejected != "") {
                                final result = await showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                            child: Column(
                                          children: [
                                            Text(
                                                "Following types already exists:"),
                                            Text(fruitTypesRejected),
                                            RaisedButton(
                                              onPressed: () {
                                                Provider.of<SubNameFruitModel>(
                                                        context,
                                                        listen: false)
                                                    .selectedElementForAddition = [];
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Ok"),
                                            )
                                          ],
                                        )));
                              }
                              Navigator.of(context).pop();
                              //After adding food in database clear the selected List and pop out
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(fontSize: 15),
                            )),
                      ),
              ],
            )
          ]);
        })
    );
  }
}
