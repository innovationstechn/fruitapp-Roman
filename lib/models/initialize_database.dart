import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/assets.dart';
import '../SubNameFruit.dart';

class InitializeModel extends ChangeNotifier {
  // Load the fruits of a date.

  List<String> fruitNames = ["apple", "banana", "pear", "watermelon"];
  List<String> colours = [
    "black",
    "green",
    "blue",
    "red",
    "yellow",
    "orange",
    "grey",
    "white"
  ];

  Future initializeDatabase() async {
    await DatabaseQuery.db
        .getNameFruitDialog()
        .then((nameFruitList) async => {
              if (nameFruitList.isEmpty)
                {
                  for (int i = 0; i < fruitNames.length; i++)
                    {
                      await addNameFruit(NameFruit(
                              name: fruitNames[i],
                              imageSource:
                                  basePath + details[fruitNames[i]]["image"]))
                    },
                },
            })
        .then((_) {
      return;
    });
  }

  Future insertIntoSubName(int id,String name) async {
    print("Fruit Id"+id.toString());
    for (int i = 0; i < colours.length; i++) {
      await addSubNameFruit(SubNameFruit(
          nameFruitId: id,
          type: colours[i],
          imageSource: basePath +
              name.toLowerCase() +
              "/" +
              details[name.toLowerCase()]['variants'][colours[i]] +
              ".gif"));
    }
  }

  Future addSubNameFruit(SubNameFruit subNameFruit) {
    return DatabaseQuery.db.newSubNameFruitDialog(subNameFruit).then((_) {});
  }

  Future addNameFruit(NameFruit nameFruit) async {
    await DatabaseQuery.db.newNameFruitDialog(nameFruit).then((value) async {
      await insertIntoSubName(value,nameFruit.name);
    });
  }
}
