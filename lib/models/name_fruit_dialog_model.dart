import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Dialog/NameFruitDialogComponents/NameFruitGridCard.dart';
import 'package:fruitapp/Model_Classes/NameFruit.dart';

class NameFruitModel extends ChangeNotifier {
  // Load the fruits of a date.

  List<NameFruitGridCard> list = [];

  // Getting list from database and notifies to application.
  Future refresh() async {
    await DatabaseQuery.db
        .getNameFruitDialog()
        .then((nameFruitList) => {
              list.clear(),
              for (int i = 0; i < nameFruitList.length; i++)
                {
                  list.add(new NameFruitGridCard(nameFruitList[i])),
                },
            })
        .then((value) => notifyListeners());
  }

  Future updateNameFruit(NameFruit nameFruit) {
    return DatabaseQuery.db
        .updateNameFruitDialog(nameFruit)
        .then((value) async {
      refresh();
      notifyListeners();
    });
  }
}
