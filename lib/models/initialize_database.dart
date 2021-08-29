import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Model_Classes/NameFruit.dart';
import 'package:fruitapp/Model_Classes/SubNameFruit.dart';

class InitializeModel extends ChangeNotifier {
  // Load the fruits of a date.

  final Map initial = {
    "fruits": ["apple"],
    "data": [
      {
        "apple": {
          "name": {"en": "Apple", "ru": "Hello"},
          "imagePath": "assets/fruits/apple/1.png",
          "subtypes": [
            {
              "type": {"en": "red", "ru": "питательный"},
              "image": "assets/fruits/apple/1.gif",
              "description": {"en": "Very nutritious", "ru": "питательный"}
            },
            {
              "type": {"en": "black", "ru": "питательный"},
              "image": "assets/fruits/apple/2.gif",
              "description": {"en": "Very nutritious", "ru": "питательный"}
            }
          ]
        }
      }
    ]
  };

  List<String> fruitNames;

  Future initializeDatabase() async {
    fruitNames = initial["fruits"];

    await DatabaseQuery.db
        .getNameFruitDialog()
        .then((nameFruitList) async => {
              if (nameFruitList.isEmpty)
                {
                  for (int i = 0; i < fruitNames.length; i++)
                    {
                      await addNameFruit(
                          NameFruit(
                              name: json
                                  .encode(
                                      initial["data"][i][fruitNames[i]]["name"])
                                  .toString(),
                              imageSource: initial["data"][i][fruitNames[i]]
                                  ["imagePath"]),
                          initial["data"][i][fruitNames[i]]["subtypes"])
                    },
                },
            })
        .then((_) {
      return;
    });
  }

  Future addNameFruit(NameFruit nameFruit, var subCat) async {
    await DatabaseQuery.db.newNameFruitDialog(nameFruit).then((value) async {
      await insertIntoSubName(value, subCat);
    });
  }

  Future insertIntoSubName(int id, var subCatItems) async {
    for (int i = 0; i < subCatItems.length; i++) {
      await addSubNameFruit(SubNameFruit(
        nameFruitId: id,
        type: json.encode(subCatItems[i]["type"]).toString(),
        imageSource: subCatItems[i]["image"],
        description: json.encode(subCatItems[i]["description"]).toString(),
      ));
    }
  }

  Future addSubNameFruit(SubNameFruit subNameFruit) {
    return DatabaseQuery.db.newSubNameFruitDialog(subNameFruit).then((_) {});
  }
}
