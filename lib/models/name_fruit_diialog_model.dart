import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/Card/GridCard.dart';
import 'package:fruitapp/Card/GridDataModel.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/assets.dart';
import 'package:fruitapp/models/sub_name_fruit_diialog_model.dart';
import 'package:provider/provider.dart';

import '../SubNameFruit.dart';

class NameFruitModel extends ChangeNotifier {

  // Load the fruits of a date.

  List<GridCard> list=[];

  Future refresh() async {

    await DatabaseQuery.db.getNameFruitDialog().then((nameFruitList) => {
        list.clear(),
        for(int i=0;i<nameFruitList.length;i++){
          print(list.length),
          list.add(new GridCard(
              new GridCardModel(nameFruitList[i].name, "", nameFruitList[i].imageSource,""))),
        },
      }).then((value) => notifyListeners());
  }


  Future addNameFruit(NameFruit nameFruit) {
    return DatabaseQuery.db.newNameFruitDialog(nameFruit).then((_) {});
  }

  Future updateNameFruit(NameFruit nameFruit,String oldName){
    return DatabaseQuery.db.updateNameFruitDialog(nameFruit,oldName).then((value) async {
      if(value) {
        await DatabaseQuery.db.updateNameOfSubNameFruitDialog(
            oldName, nameFruit.name).then((value) async {
          if (value) {
            await DatabaseQuery.db.updateFruitByName(oldName, nameFruit.name)
                .then((value) async {
                  refresh();
                  notifyListeners();
            });
          }
        });
      }
    });
  }

  Future initializeDatabase()async {
    List<String> fruitNames = ["apple","banana","pear","watermelon"];

    await DatabaseQuery.db.getNameFruitDialog().then((nameFruitList) async => {

      if(nameFruitList.isEmpty){

        for(int i=0;i<fruitNames.length;i++){
         await addNameFruit(NameFruit(name: fruitNames[i], dummyName: fruitNames[i], imageSource: basePath + details[fruitNames[i]]["image"])).then(
                  (value) async =>{
                    await insertIntoSubName(fruitNames[i]).then((value) => print("I am here")),
                  }),
        },
        refresh(),
      },
    }).then((_) {print("Hello");notifyListeners();return;} );
  }

  Future insertIntoSubName(String name) async {

    List<String> colours = ["black","green","blue","red","yellow","orange","grey","white"];

    for(int i=0;i<colours.length;i++){

      await addSubNameFruit(SubNameFruit(name:name,type:colours[i],dummyName:name,dummyType:colours[i]) );
    }
  }


  Future addSubNameFruit(SubNameFruit subNameFruit) {
    return DatabaseQuery.db.newSubNameFruitDialog(subNameFruit).then((_){});
  }

}
