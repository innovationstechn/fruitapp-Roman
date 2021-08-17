import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:fruitapp/models/name_fruit_diialog_model.dart';
import 'package:fruitapp/widgets/item_fruit_name_decoration.dart';
import 'package:fruitapp/widgets/item_rename_mixin.dart';
import 'package:provider/provider.dart';
import '../NameFruit.dart';

class GridCardNameFruit extends StatefulWidget {
  final NameFruit nameFruit;

  GridCardNameFruit(this.nameFruit);

  @override
  _NameFruitCardState createState() => _NameFruitCardState();
}

class _NameFruitCardState extends State<GridCardNameFruit>
    with ItemRenameMixin, NameDecoration {
  Future<void> onUpdate(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => getRenameDialog(context, (String updatedName) {
              NameFruit nameFruit = new NameFruit(
                  name: updatedName,
                  dummyName: widget.nameFruit.dummyName,
                  imageSource: widget.nameFruit.imageSource);

              // Call Update Method and Refresh For Category Grid Dialog

              var result = Provider.of<NameFruitModel>(context, listen: false)
                  .updateNameFruit(nameFruit, widget.nameFruit.name)
                  .then((value) {
                Provider.of<NameFruitModel>(context, listen: false).refresh();

                // Navigator.of(context).pop();
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.nameFruit.imageSource,
                  height: 130,
                  width: 100,
                  fit: BoxFit.fill,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text(widget.nameFruit.name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.combine([]))),
                      onDoubleTap: () async {
                        // if(Provider.of<FruitModel>(context,listen: false).fruitToBeReplaced == null)
                        await onUpdate(context);
                      },
                    ),
                   IconButton(onPressed: (){
                       showDialog(context: context,
                           builder:(_) => getDecorationDialog(context,widget.nameFruit));

                   }, icon: Icon(Icons.edit))
                  ],
                ),
              ]),
        )); //Sizedbox,
  }
}
