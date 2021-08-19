import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Card/SubNameFruitGridCard.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/assets.dart';
import '../Fruit.dart';
import '../SubNameFruit.dart';

class SubNameFruitModel extends ChangeNotifier {
  List<GridCardSubNameFruit> list = [];
  List<SubNameFruit> selectedElementForAddition= [];


  Future refresh() async {

    await DatabaseQuery.db.getSubNameFruitDialog().then((nameFruitList) => {
          if (nameFruitList.isNotEmpty)
            {
              list.clear(),
              for (int i = 0; i < nameFruitList.length; i++)
                {
                  list.add(GridCardSubNameFruit(nameFruitList[i]))
                },
              notifyListeners(),
            }
        });
  }

  List<GridCardSubNameFruit> searchByName(String name) {
    List<GridCardSubNameFruit> temp = [];

    for (int i = 0; i < list.length; i++)
      if (list[i].subNameFruit.name == name) temp.add(list[i]);

    return temp;
  }

  void addToSelectedList(SubNameFruit subNameFruit){
    if(this.selectedElementForAddition.contains(subNameFruit))
      this.selectedElementForAddition.remove(subNameFruit);
    else
      this.selectedElementForAddition.add(subNameFruit);
  }

  Future<String> addSelectedListToDB(String date)async{

    String fruitTypes = "";
    print("Selected Item: "+selectedElementForAddition.length.toString());

    for (int i = 0; i < selectedElementForAddition.length; i++) {
      Fruit newFruit = new Fruit(
          selectedElementForAddition[i].name,
          selectedElementForAddition[i].type,
          "",
          date,
          null,
          null,
          null,
          selectedElementForAddition[i].imageSource,
          selectedElementForAddition[i].imageSource,);
      var result = await DatabaseQuery.db.newFruit(newFruit);
      if (!result) {
        fruitTypes = fruitTypes + newFruit.type + "\n";
      }
    }
    return fruitTypes;

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
