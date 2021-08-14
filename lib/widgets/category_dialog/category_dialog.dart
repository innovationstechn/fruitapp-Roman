import 'package:flutter/material.dart';
import 'package:fruitapp/widgets/item_grid_mixin.dart';
import 'package:fruitapp/widgets/item_rename_mixin.dart';
import 'package:provider/provider.dart';

import 'category_grid_dialog_viewmodel.dart';

class CategoryDialog extends StatefulWidget {
  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog>
    with ItemGridMixin, ItemRenameMixin {
  final CategoryDialogViewModel _viewModel = CategoryDialogViewModel();
  double dialogHorizontalWidth = 24;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryDialogViewModel>(
      create: (context) => _viewModel,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalWidth, vertical: 24.0),
        child: Consumer<CategoryDialogViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Name Fruit",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.04),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: dialogHorizontalWidth == 0
                            ? Icon(Icons.zoom_out)
                            : Icon(Icons.zoom_in),
                        onPressed: () {
                          setState(() {
                            dialogHorizontalWidth == 0
                                ? dialogHorizontalWidth = 24
                                : dialogHorizontalWidth = 0;
                          });
                        }),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: Container(
                      color: Colors.white,
                      child:
                          gridViewBuilder(viewmodel.categories, () {}, () {})),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 10),
                    child: RaisedButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
