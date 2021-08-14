import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:fruitapp/Card/GridCard.dart';
import 'package:fruitapp/Card/GridDataModel.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/widgets/subcategory_dialog/subcategory_dialog.dart';
import 'package:fruitapp/widgets/subcategory_dialog/subcategory_persistence.dart';

import '../../Fruit.dart';
import '../../assets.dart';

class SubcategoryDialogViewModel extends ChangeNotifier {
  List<GridCard> _subCategories = [];
  List<GridCard> _selected = [];
  SubcategoryPersistence _persistence = SubcategoryPersistence();
  final String _date, _fruit;
  final SubcategoryDialog _dialog;

  UnmodifiableListView<GridCard> get subCategories =>
      UnmodifiableListView(_subCategories);

  UnmodifiableListView<GridCard> get selected =>
      UnmodifiableListView(_selected);

  SubcategoryDialogViewModel(
      {@required String date,
      @required String fruit,
      @required SubcategoryDialog dialog})
      : _fruit = fruit,
        _date = date,
        _dialog = dialog {
    _persistence.fetch().then((List<NameFruit> categories) {
      categories.forEach((element) {
        _subCategories.add(
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

  void onItemTapped(GridCard card) {
    if (_selected.contains(card)) {
      _deselectItem(card);
    } else {
      _selectItem(card);
    }
  }

  void _selectItem(GridCard card) => _selected.add(card);

  void _deselectItem(GridCard card) => _selected.removeWhere((element) =>
      element.gridCardModel.name == card.gridCardModel.name &&
      element.gridCardModel.type == card.gridCardModel.type);

  Future onAddTapped(BuildContext context) {
    List<Future> futures = [];
    String errorString = "";

    _selected.forEach((element) {
      Fruit newFruit = new Fruit(
          element.gridCardModel.name,
          element.gridCardModel.type,
          "",
          this._date,
          null,
          null,
          null,
          details[element.gridCardModel.dummyName]["variants"]
              [element.gridCardModel.dummyName.toLowerCase()],
          element.gridCardModel.dummyName,
          element.gridCardModel.dummyType);

      futures.add(_persistence.add(newFruit).then((bool value) {
        if (value) errorString = errorString + newFruit.type + "\n";
      }));
    });

    return Future.wait(futures);
  }
}
