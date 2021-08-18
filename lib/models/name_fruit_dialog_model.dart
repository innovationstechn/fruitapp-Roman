import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Card/NameFruitGridCard.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/NameFruit.dart';

class NameFruitModel extends ChangeNotifier {
  // Load the fruits of a date.

  List<GridCardNameFruit> list = [];

  Future refresh() async {
    await DatabaseQuery.db
        .getNameFruitDialog()
        .then((nameFruitList) => {
              list.clear(),
              for (int i = 0; i < nameFruitList.length; i++){
                  list.add(new GridCardNameFruit(nameFruitList[i])),
                },
            })
        .then((value) => notifyListeners());
  }

  Future updateNameFruit(NameFruit nameFruit, String oldName) {
    return DatabaseQuery.db
        .updateNameFruitDialog(nameFruit, oldName)
        .then((value) async {
      if (value) {
        await DatabaseQuery.db
            .updateNameOfSubNameFruitDialog(oldName, nameFruit.name)
            .then((value) async {
          if (value) {
            await DatabaseQuery.db
                .updateFruitByName(oldName, nameFruit.name)
                .then((value) async {
              refresh();
              notifyListeners();
            });
          }
        });
      }
    });
  }

}
