import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/sub_name_fruit_diialog_model.dart';
import 'package:fruitapp/widgets/item_rename_mixin.dart';
import 'package:provider/provider.dart';
import '../SubNameFruit.dart';
import '../assets.dart';

class GridCardSubNameFruit extends StatefulWidget {
  final SubNameFruit subNameFruit;

  GridCardSubNameFruit(this.subNameFruit);

  @override
  _SubNameCardState createState() => _SubNameCardState();
}

class _SubNameCardState extends State<GridCardSubNameFruit>
    with ItemRenameMixin {
  bool isAdded = false;

  Future<void> onUpdate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => getRenameDialog(context, (String updatedType) {

              SubNameFruit nameFruit = new SubNameFruit(
                  name: widget.subNameFruit.name,
                  dummyName: widget.subNameFruit.dummyName,
                  dummyType: widget.subNameFruit.dummyType,
                  type: updatedType);

              var result =
                  Provider.of<SubNameFruitModel>(context, listen: false)
                      .updateSubNameFruit(nameFruit, widget.subNameFruit.type)
                      .then((value) {
                Provider.of<SubNameFruitModel>(context, listen: false)
                    .refresh();

                Navigator.of(context).pop();
              });

            }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced == null) {
              this.isAdded = !this.isAdded;
              Provider.of<SubNameFruitModel>(context, listen: false).addToSelectedList(widget.subNameFruit);
            }
            else {
              // Open show Dialog
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        child: Column(
                          children: [
                            Text("Are sure you want to update it? "),
                            RaisedButton(
                                onPressed: () async {
                                 var result = await Provider.of<FruitModel>(context,listen: false).replaceFruit(widget.subNameFruit);
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
          });

        },
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
                  basePath +
                      widget.subNameFruit.dummyName +
                      "/" +
                      details[widget.subNameFruit.dummyName]["variants"]
                          [widget.subNameFruit.dummyType] +
                      ".gif",
                  height: 130,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                GestureDetector(
                  // print("Edit Request Received");
                  child: Text(widget.subNameFruit.type),
                  onDoubleTap: () {
                    if (Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced  == null) {
                      onUpdate(context);
                    }
                  },
                )
              ],
            )),
      ),
    );
  } //Sizedbox,
}
