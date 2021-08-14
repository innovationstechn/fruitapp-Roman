import 'package:flutter/material.dart';
import 'package:fruitapp/widgets/item_grid_mixin.dart';
import 'package:fruitapp/widgets/subcategory_dialog/subcategory_viewmodel.dart';
import 'package:provider/provider.dart';

class SubcategoryDialog extends StatefulWidget {
  final String fruit, date;

  SubcategoryDialog({@required this.fruit, @required this.date});

  Future<Widget> showErrorDialog(BuildContext context, String error) async {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          children: [
            Text("Following types already exists:"),
            Text(error),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        ),
      ),
    );
  }

  @override
  _SubcategoryDialogState createState() => _SubcategoryDialogState();
}

class _SubcategoryDialogState extends State<SubcategoryDialog>
    with ItemGridMixin {
  double dialogHorizontalWidth = 24;
  SubcategoryDialogViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SubcategoryDialogViewModel(
        date: widget.date, fruit: widget.fruit, dialog: widget);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _viewModel,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: dialogHorizontalWidth, vertical: 24.0),
        child: Consumer<SubcategoryDialogViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            child: Icon(Icons.arrow_back),
                            onTap: () {
                              Navigator.of(context).pop();
                            })),
                    Center(
                      child: Text(
                        viewmodel.selected[0].gridCardModel.name,
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.04),
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
                      child: gridViewBuilder(viewmodel.selected, () {}, () {})),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "CANCEL",
                          style: TextStyle(fontSize: 15),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: RaisedButton(
                        color: Colors.lightGreen,
                        onPressed: () {
                          viewmodel
                              .onAddTapped(context)
                              .then((_) => Navigator.of(context).pop());
                        },
                        child: Text(
                          "ADD",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
