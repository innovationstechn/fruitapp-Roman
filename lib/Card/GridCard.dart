import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Dialog/NameFruitDialog.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/name_fruit_diialog_model.dart';
import 'package:fruitapp/models/sub_name_fruit_diialog_model.dart';
import 'package:provider/provider.dart';

import '../Card/GridDataModel.dart';
import '../Dialog/SubCategoryFruitDialog.dart';
import '../NameFruit.dart';
import '../SubNameFruit.dart';
import '../assets.dart';

class GridCard extends StatefulWidget {
  final GridCardModel gridCardModel;

  GridCard(this.gridCardModel);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<GridCard> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () async {
      if (widget.gridCardModel.type != "") {
        if (!NameFruitDialog.updated) {
          if (isAdded) {
            SubNameFruitDialog.selectedList.remove(widget.gridCardModel);
            setState(() {
              isAdded = false;
            });
          } else {
            SubNameFruitDialog.selectedList.add(widget.gridCardModel);
            setState(() {
              isAdded = true;
            });
          }
        } else {
          SubNameFruitDialog.newFruitSelectedForUpdate = widget.gridCardModel;
          showDialog(
              context: context,
              builder: (_) => Dialog(
                    child: Column(
                      children: [
                        Text("Are sure you want to update it? "),
                        RaisedButton(
                            onPressed: () async {
                              NameFruitDialog.previousFruit.name =
                                  SubNameFruitDialog
                                      .newFruitSelectedForUpdate.name;
                              NameFruitDialog.previousFruit.type =
                                  SubNameFruitDialog
                                      .newFruitSelectedForUpdate.type;
                              var result = await DatabaseQuery.db.updateFruit(
                                  NameFruitDialog.previousFruit, false);
                              Navigator.of(context).pop();
                            },
                            child: Text("Yes")),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        )
                      ],
                    ),
                  ));
        }
      } else {

        Provider.of<SubNameFruitModel>(context, listen: false).refresh();

        await showDialog(
            context: context,
            builder: (_) =>
                Consumer<SubNameFruitModel>(builder: (context, data, child) {
                  return SubNameFruitDialog(
                      list:
                          Provider.of<SubNameFruitModel>(context, listen: false)
                              .searchByName(widget.gridCardModel.name));
                })).then((value) => {
              NameFruitDialog.updated = false,
              Provider.of<FruitModel>(context, listen: false).refresh(
                  Provider.of<DayModel>(context, listen: false).currentDate)
            });
      }
    }, child:  SizedBox(
        height: double.infinity,
        child: Card(
            shape: isAdded
                ? new RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0))
                : new RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(4.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.gridCardModel.type == ""
                      ? widget.gridCardModel.dummyName
                      : basePath +
                          widget.gridCardModel.dummyName +
                          "/" +
                          details[widget.gridCardModel.dummyName]["variants"]
                              [widget.gridCardModel.dummyType] +
                          ".gif",
                  height: 130,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                widget.gridCardModel.type == ""
                    ? GestureDetector(
                        onDoubleTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                final name_controller = TextEditingController();
                                return AlertDialog(
                                  content: Container(
                                      child: TextField(
                                    maxLines: 5,
                                    minLines: 1,
                                    controller: name_controller,
                                    decoration: InputDecoration(
                                      labelText: 'Rename',
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
                                          print(widget.gridCardModel.dummyName);
                                          NameFruit nameFruit = new NameFruit(
                                              name: name_controller.text,
                                              dummyName:
                                                  widget.gridCardModel.name,
                                              imageSource: widget
                                                  .gridCardModel.dummyName);
                                          var result =
                                              Provider.of<NameFruitModel>(
                                                      context,
                                                      listen: false)
                                                  .updateNameFruit(nameFruit,
                                                      widget.gridCardModel.name)
                                                  .then((value) {
                                            Provider.of<NameFruitModel>(context,
                                                    listen: false)
                                                .refresh();
                                            Navigator.of(context).pop();
                                          });
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
                          print("Edit Request Recieved");
                        },
                        child: Text(widget.gridCardModel.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.combine([]))),
                      )
                    : Container(),
                widget.gridCardModel.type != ""
                    ? GestureDetector(
                        child: Text(widget.gridCardModel.type),
                        onDoubleTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                final typeController = TextEditingController();
                                return AlertDialog(
                                  content: Container(
                                      child: TextField(
                                    maxLines: 5,
                                    minLines: 1,
                                    controller: typeController,
                                    decoration: InputDecoration(
                                      labelText: 'Rename',
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
                                          SubNameFruit nameFruit =
                                              new SubNameFruit(
                                                  name:
                                                      widget.gridCardModel.name,
                                                  dummyName: widget
                                                      .gridCardModel.dummyName,
                                                  dummyType: widget
                                                      .gridCardModel.dummyType,
                                                  type: typeController.text);
                                          var result =
                                              Provider.of<SubNameFruitModel>(
                                                      context,
                                                      listen: false)
                                                  .updateSubNameFruit(nameFruit,
                                                      widget.gridCardModel.type)
                                                  .then((value) {
                                            Provider.of<SubNameFruitModel>(
                                                    context,
                                                    listen: false)
                                                .refresh();
                                            Navigator.of(context).pop();
                                          });
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
                          print("Edit Request Recieved");
                        },
                      )
                    : Container(),
              ],
            )),
      ) //Sizedbox,
    );
  }
}
