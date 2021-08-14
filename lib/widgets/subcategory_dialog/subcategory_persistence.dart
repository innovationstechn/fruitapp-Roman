import 'package:fruitapp/Database/DatabaseHelper.dart';

import '../../Fruit.dart';
import '../../NameFruit.dart';

class SubcategoryPersistence {
  final List<String> subcategories = ["apple", "banana", "pear", "watermelon"];

  Future<List<NameFruit>> fetch() {
    return DatabaseQuery.db.getNameFruitDialog();
  }

  Future<bool> add(Fruit fruit) {
    return DatabaseQuery.db.newFruit(fruit);
  }

  Future update(NameFruit nameFruit, String oldName) {
    return DatabaseQuery.db
        .updateNameFruitDialog(nameFruit, oldName)
        .then((_) => DatabaseQuery.db
            .updateNameOfSubNameFruitDialog(oldName, nameFruit.name))
        .then(
            (_) => DatabaseQuery.db.updateFruitByName(oldName, nameFruit.name));
  }
}
