import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Card/SubNameFruitGridCard.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import '../Fruit.dart';
import '../SubNameFruit.dart';

class SubNameFruitModel extends ChangeNotifier {
  List<GridCardSubNameFruit> list = [];
  List<SubNameFruit> selectedElementForAddition= [];

  Future searchById(int nameFruitId) async {

    await DatabaseQuery.db.getSubNameFruitDialog(nameFruitId).then((nameFruitList) => {

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
          "",
          date,
          null,
          selectedElementForAddition[i].id,
          null,
          null);
      var result = await DatabaseQuery.db.newFruit(newFruit);
    }
    return fruitTypes;

  }

  Future updateSubNameFruit(SubNameFruit nameFruit) {
    return DatabaseQuery.db
        .updateTypeOfSubNameFruitDialog(nameFruit)
        .then((value) async {
      if (value) {
        searchById(nameFruit.id);
      }
    });
  }
}
