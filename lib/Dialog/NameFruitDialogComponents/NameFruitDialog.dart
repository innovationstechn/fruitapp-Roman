import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/name_fruit_dialog_model.dart';
import 'package:fruitapp/models/sub_name_fruit_dialog_model.dart';
import 'package:fruitapp/widgets/item_grid_mixin.dart';
import 'package:provider/provider.dart';
import '../SubCategoryFruitDialogComponents/SubCategoryFruitDialog.dart';

class NameFruitDialog extends StatefulWidget {

  NameFruitDialog();

  @override
  _nameFruitDialog createState() => _nameFruitDialog();
}

class _nameFruitDialog extends State<NameFruitDialog> with ItemGridMixin {
  double dialogHorizontalWidth = 24;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalWidth, vertical: 24.0),
        child: Consumer<NameFruitModel>(builder: (context, data, child) {
          return Column(mainAxisSize: MainAxisSize.max, children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Name Fruit",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04),
                    ),
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
                  child: gridViewBuilder(data.list, (index) async {

                    Provider.of<SubNameFruitModel>(context,
                        listen: false)
                        .searchById(
                        data.list[index].nameFruit.id);


                    await showDialog(
                        context: context,
                        builder: (_) => Consumer<SubNameFruitModel>(
                                builder: (context, list, child) {

                              return SubNameFruitDialog(
                                  list: list.list);
                            })).then((value) => {
                          Provider.of<FruitModel>(context, listen: false)
                              .refresh(
                                  Provider.of<DayModel>(context, listen: false)
                                      .currentDate)
                        });
                  }, null)),
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
        }));
  }
}
