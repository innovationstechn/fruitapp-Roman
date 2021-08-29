import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Model_Classes/NameFruit.dart';
import 'package:fruitapp/Model_Classes/SubNameFruit.dart';
import 'package:provider/provider.dart';

import 'name_fruit_dialog_model.dart';

class InitializeModel extends ChangeNotifier {
  // Load the fruits of a date.

  Map initial;
  List<dynamic> fruitNames;

  Future initializeDatabase(BuildContext context) async {
    DefaultAssetBundle.of(context)
        .loadString("assets/data.json")
        .then((String encodedJson) async {

      initial = jsonDecode(encodedJson);
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
                                    .encode(initial["data"][i][fruitNames[i]]
                                        ["name"])
                                    .toString(),
                                imageSource: initial["data"][i][fruitNames[i]]
                                    ["imagePath"]),
                            initial["data"][i][fruitNames[i]]["subtypes"])
                      },
                  },
              }).then((value) => {
                  Provider.of<NameFruitModel>(context, listen: false)
                      .refresh()
      });
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
