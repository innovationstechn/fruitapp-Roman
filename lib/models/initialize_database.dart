import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/assets.dart';
import '../SubNameFruit.dart';

class InitializeModel extends ChangeNotifier {
  // Load the fruits of a date.

  final Map initial = {
    "fruits": ["apple"],
    "data": [
      {
        "apple": {
          "name": r'''{"en": "Apple","ru":"Hello"}''',
          "imagePath": "assets/fruits/apple/1.png",
          "subtypes": [
            {
              "type": "red",
              "image": "assets/fruits/apple/1.gif",
              "description":  r'''{"en": "Very nutritious", "ru": "питательный"}'''
            },
            {
              "type": "black",
              "image": "assets/fruits/apple/2.gif",
              "description": r'''{"en": "Very nutritious", "ru": "питательный"}'''
            }
          ]
        }
      }
    ]
  };

  List<String> fruitNames;

  Future initializeDatabase() async {
    fruitNames  = initial["fruits"];
    String raw;
    await DatabaseQuery.db
        .getNameFruitDialog()
        .then((nameFruitList) async => {
              if (nameFruitList.isEmpty)
                {

                  for (int i = 0; i < fruitNames.length; i++)
                    {
                      await addNameFruit(NameFruit(
                              name: (initial["data"][i][fruitNames[i]]["name"]),
                              imageSource:
                              initial["data"][i][fruitNames[i]]["imagePath"]),initial["data"][i][fruitNames[i]]["subtypes"])
                    },
                },
            })
        .then((_) {
      return;
    });
  }

  Future insertIntoSubName(int id,var subCatItems) async {
    for (int i = 0; i < subCatItems.length; i++) {
      await addSubNameFruit(SubNameFruit(
          nameFruitId: id,
          type: subCatItems[i]["type"],
          imageSource: subCatItems[i]["image"],
          description: subCatItems[i]["description"],
      ));
    }
  }

  Future addSubNameFruit(SubNameFruit subNameFruit) {
    return DatabaseQuery.db.newSubNameFruitDialog(subNameFruit).then((_) {});
  }

  Future addNameFruit(NameFruit nameFruit,var subCat) async {
    await DatabaseQuery.db.newNameFruitDialog(nameFruit).then((value) async {
      await insertIntoSubName(value,subCat);
    });
  }
}
