import 'package:fruitapp/Database/DatabaseHelper.dart';

import '../../NameFruit.dart';

class CategoryPersistence {
  Future<List<NameFruit>> fetch() {
    return DatabaseQuery.db.getNameFruitDialog();
  }

  Future update(NameFruit nameFruit, String oldName) {
    return DatabaseQuery.db
        .updateNameFruitDialog(nameFruit, oldName)
        .then((_) => DatabaseQuery.db
            .updateNameOfSubNameFruitDialog(oldName, nameFruit.name))
        .then(
            (_) => DatabaseQuery.db.updateFruitByName(oldName, nameFruit.name));
  }

  // Mock functions for UI testing.
  Future<List<NameFruit>> mockFetch() {
    List<NameFruit> fruits = [
      NameFruit(name: "apple", dummyName: "apple", imageSource: "apple/1.png"),
      NameFruit(
          name: "banana", dummyName: "banana", imageSource: "banana/1.png")
    ];

    return Future.sync(() => fruits);
  }

  Future mockUpdate(NameFruit nameFruit, String oldName) {}
}
