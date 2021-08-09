import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Card/GridCard.dart';
import 'package:fruitapp/Card/GridDataModel.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/assets.dart';

import '../SubNameFruit.dart';

class SubNameFruitModel extends ChangeNotifier {
  List<GridCard> list = [];

  // Load the fruits of a date.

  Future refresh() async {
    List<String> fruitNames = ["apple", "banana", "pear", "watermelon"];

    await DatabaseQuery.db.getSubNameFruitDialog().then((nameFruitList) => {
          if (nameFruitList.isNotEmpty)
            {
              list.clear(),
              for (int i = 0; i < nameFruitList.length; i++)
                {
                  list.add(GridCard(
                    new GridCardModel(
                      nameFruitList[i].name,
                      nameFruitList[i].type,
                      nameFruitList[i].dummyName,
                      nameFruitList[i].dummyType,
                    ),
                  ))
                },
              notifyListeners(),
            }
        });
  }

  List<GridCard> searchByName(String name) {
    List<GridCard> temp = [];

    for (int i = 0; i < list.length; i++)
      if (list[i].gridCardModel.name == name) temp.add(list[i]);

    return temp;
  }

  Future updateSubNameFruit(SubNameFruit nameFruit, String oldName) {
    return DatabaseQuery.db
        .updateTypeOfSubNameFruitDialog(nameFruit, oldName)
        .then((value) async {
      if (value) {
        await DatabaseQuery.db
            .updateFruitByType(nameFruit, oldName)
            .then((value) {
          if (value) {
            refresh();
          }
        });
      }
    });
  }
}
