import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Dialog/SubCategoryFruitDialogComponents/SubNameFruitGridCard.dart';
import 'package:fruitapp/Model_Classes/Fruit.dart';
import 'package:fruitapp/Model_Classes/SubNameFruit.dart';


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

  // This function helps in adding and removing the item from list which is pressed on SubNameDialog( Fruit Types)
  // It helps in multi selection of items.
  void addToSelectedList(SubNameFruit subNameFruit){
    if(this.selectedElementForAddition.contains(subNameFruit))
      this.selectedElementForAddition.remove(subNameFruit);
    else
      this.selectedElementForAddition.add(subNameFruit);
  }

  // This function is used to insert selected fruit types to Database
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

  // It helps in updating the type of fruit.
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
