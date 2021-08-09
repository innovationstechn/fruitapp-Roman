import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Card/GridCard.dart';
import '../Card/GridDataModel.dart';
import '../Database/DatabaseHelper.dart';
import '../Fruit.dart';
import '../assets.dart';
import 'NameFruitDialog.dart';

class SubNameFruitDialog extends StatefulWidget {
  final List<GridCard> list;
  static List<GridCardModel> selectedList = new List<GridCardModel>();
  static GridCardModel newFruitSelectedForUpdate;

  SubNameFruitDialog({this.list});

  @override
  _SnameFruitDialog createState() => _SnameFruitDialog();
}

class _SnameFruitDialog extends State<SubNameFruitDialog> {
  @override
  void initState() {
    super.initState();
    SubNameFruitDialog.selectedList.clear();
  }

  Widget gridViewBuilder(List<GridCard> list){

    return GridView.builder(
      itemCount:list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 / 1.3),
      ),
      itemBuilder: (context,index,) {
        return GestureDetector(
            onTap:(){
              // Navigator.of(context).pushNamed(RouteName.GridViewCustom);
            },
            child:list[index]
        );
      },
    );

  }

  double dialogHorizontalWidth = 24;
  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding:  EdgeInsets.symmetric(horizontal: dialogHorizontalWidth, vertical: 24.0),
      child: Column(mainAxisSize: MainAxisSize.max, children: [
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
                widget.list[0].gridCardModel.name,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04),
              ),
            ),
            IconButton(
                icon:  dialogHorizontalWidth == 0 ? Icon(Icons.zoom_out):Icon(Icons.zoom_in),
                onPressed: (){
                  setState(() {
                    dialogHorizontalWidth == 0 ? dialogHorizontalWidth = 24 : dialogHorizontalWidth = 0;
                  });
                }
            ),

          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.68,
          child: Container(
            color: Colors.white,
            child: gridViewBuilder(widget.list)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
                color: Colors.red,
                onPressed: () {
                  SubNameFruitDialog.selectedList.clear();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 15),
                )),
            NameFruitDialog.updated
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: RaisedButton(
                        color: Colors.lightGreen,
                        onPressed: () async {
                          String fruitColors = "";
                          for (int i = 0;
                              i < SubNameFruitDialog.selectedList.length;
                              i++) {
                            print(SubNameFruitDialog.selectedList[i].type);

                            Fruit newFruit = new Fruit(
                                SubNameFruitDialog.selectedList[i].name,
                                SubNameFruitDialog.selectedList[i].type,
                                "",
                                NameFruitDialog.date,
                                null,
                                null,
                                null,
                                details[SubNameFruitDialog.selectedList[i].dummyName]["variants"]
                                [SubNameFruitDialog.selectedList[i].dummyType.toLowerCase()],
                                SubNameFruitDialog.selectedList[i].dummyName,
                                SubNameFruitDialog.selectedList[i].dummyType
                            );
                            var result =
                                await DatabaseQuery.db.newFruit(newFruit);
                            if (!result) {
                              fruitColors = fruitColors + newFruit.type + "\n";
                            }
                          }

                          if (fruitColors != "") {
                            final result = await showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                        child: Column(
                                      children: [
                                        Text("Following types already exists:"),
                                        Text(fruitColors),
                                        RaisedButton(
                                          onPressed: () {
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
      ]),
    );
  }
}
