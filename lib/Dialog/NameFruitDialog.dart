import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Card/GridCard.dart';
import 'package:fruitapp/assets.dart';
import 'package:fruitapp/models/name_fruit_diialog_model.dart';

import 'package:provider/provider.dart';
import '../Fruit.dart';

class NameFruitDialog extends StatefulWidget {
  static String date;
  static bool updated = false;
  static Fruit previousFruit;


  NameFruitDialog(String date) {
    NameFruitDialog.date = date;
  }

  NameFruitDialog.forUpdate(Fruit fruit) {
    updated = true;
    previousFruit = fruit;
  }

  @override
  _nameFruitDialog createState() => _nameFruitDialog();
}

class _nameFruitDialog extends State<NameFruitDialog> {

  double dialogHorizontalWidth = 24;

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

  @override
  Widget build(BuildContext context) {
    // print("List Length" + widget.list.length.toString());
    return Dialog(
        insetPadding:  EdgeInsets.symmetric(horizontal: dialogHorizontalWidth, vertical: 24.0),
        child: Consumer<NameFruitModel>(builder: (context, data, child) {
      return Column(mainAxisSize: MainAxisSize.max, children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*0.6,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Name Fruit",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04),
                ),
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
            child:gridViewBuilder(data.list)
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 10),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 15),
                )),
          ),
        )
      ]);
    })); // Diloag ending
  }
}
