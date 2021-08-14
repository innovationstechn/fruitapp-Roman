import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Card/GridCard.dart';
import 'package:fruitapp/Card/GridDataModel.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/widgets/category_dialog/category_persistence.dart';

class CategoryDialogViewModel extends ChangeNotifier {
  List<GridCard> _categories = [];
  CategoryPersistence _persistence = CategoryPersistence();

  UnmodifiableListView<GridCard> get categories =>
      UnmodifiableListView(_categories);

  CategoryDialogViewModel() {
    _persistence.fetch().then((List<NameFruit> categories) {
      categories.forEach((element) {
        _categories.add(
            GridCard(GridCardModel(element.name, "", element.imageSource, "")));
      });
      notifyListeners();
    });

    // Testing
    // _persistence.mockFetch().then((List<NameFruit> categories) {
    //   categories.forEach((element) {
    //     _categories.add(
    //         GridCard(GridCardModel(element.name, "", element.imageSource, "")));
    //   });
    //   notifyListeners();
    // });
  }

  void onItemClicked() {}

  void onItemDoubleClicked(String oldName, String newName) {
    _persistence.update(
        NameFruit(name: newName, imageSource: "", dummyName: newName), oldName);
  }
}
