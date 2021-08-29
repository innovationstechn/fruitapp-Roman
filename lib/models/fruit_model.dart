import 'package:flutter/foundation.dart';
import 'package:fruitapp/Database/DatabaseHelper.dart';
import 'package:fruitapp/Model_Classes/Fruit.dart';
import 'package:fruitapp/Model_Classes/MLKG.dart';
import 'package:fruitapp/Model_Classes/SubNameFruit.dart';


// This model holds data of the fruits of the current day
// and the operations associated with them.
class FruitModel extends ChangeNotifier {
  // Each fruit has a different list.
  Fruit fruitToBeReplaced;
  List<Fruit> fetchedList = [];
  // Load the fruits of a date.
  Future<void> refresh(DateTime currentDate) async {

    clear();
    await DatabaseQuery.db.getFruitsByDate("${currentDate.day}/${currentDate.month}/${currentDate.year}").then((nameFruitList) => {

      if(nameFruitList.isNotEmpty){
        fetchedList = nameFruitList,
        notifyListeners()
      }
    });

  }

  void clear() {
    fetchedList.clear();
  }


  Future updateFruit(Fruit fruit) {
    return DatabaseQuery.db
        .updateFruit(fruit)
        .then((_) => notifyListeners());
  }

  Future deleteFruit(Fruit fruit) {
    return DatabaseQuery.db
        .deleteFruit(fruit)
        .then((value) => notifyListeners());
  }

  Future replaceFruit(SubNameFruit newFruitDetails) async {

    fruitToBeReplaced.subCategoryId = newFruitDetails.id;

    return await DatabaseQuery.db.updateFruit(
        fruitToBeReplaced);
  }

  // Read-Update-Delete operations for Fruits
  Future addMLKG(MLKG mlkg) {
    return DatabaseQuery.db.newMLKG(mlkg).then((_) => notifyListeners());
  }

  Future updateMLKG(MLKG mlkg) {
    return DatabaseQuery.db
        .updateMLKG(mlkg, false)
        .then((_) => notifyListeners());
  }

  Future deleteMLKG(MLKG mlkg) {
    return DatabaseQuery.db.deleteMLKG(mlkg).then((value) => notifyListeners());
  }


}
