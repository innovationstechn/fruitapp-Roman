import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruitapp/Model_Classes/Fruit.dart';
import 'package:fruitapp/Model_Classes/MLKG.dart';
import 'package:fruitapp/models/day_model.dart';
import 'package:fruitapp/models/fruit_model.dart';
import 'package:provider/provider.dart';

// The widget containing the dialog that add/edits mlkg items.
class AddUpdateMLKGDialog extends StatefulWidget {
  // The fruit that is this dialog was called on,
  final Fruit fruit;

  // OPTIONAL: This represents the MLKG item that is set to be updated.
  final MLKG mlkg;

  AddUpdateMLKGDialog({@required this.fruit, this.mlkg});

  @override
  _AddUpdateMLKGDialogState createState() => _AddUpdateMLKGDialogState();
}

class _AddUpdateMLKGDialogState extends State<AddUpdateMLKGDialog> {
  // Declare the  controllers for textfields.
  TextEditingController ml = new TextEditingController(),
      kg = TextEditingController(),
      comment = TextEditingController();

  @override
  void initState() {
    super.initState();

    // If MLKG is supplied, then the textfields are initialized from the
    // MLKG's attributes.
    if (widget.mlkg != null) {
      kg.text = widget.mlkg.kg;
      ml.text = widget.mlkg.ml;
      comment.text = widget.mlkg.comment;
    }
  }

  // OnTapped listener for + button. Increases value by 1 each time it is clicked.
  // Invalid values result the field being set to 0.
  void add(TextEditingController controller) {
    int num = 0;
    try {
      num = int.parse(controller.text);
      num++;
    } catch (e) {
      num = 0;
    }

    controller.text = num.toString();
  }

  // OnTapped listener for - button. Decreases value by 1 each time it is clicked.
  // Invalid values result the field being set to 0.
  // Field cannot be negative number, no decrease occurs when value is 0.
  void subtract(TextEditingController controller) {
    int num = 0;
    try {
      num = int.parse(controller.text);

      if (num > 0) num--;
    } catch (e) {
      num = 0;
    }

    controller.text = num.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Number"),
                if (widget.mlkg != null)
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete this MLKG item from a fruit.
                        Provider.of<FruitModel>(context, listen: false)
                            .deleteMLKG(widget.mlkg)
                            .then((value) =>
                                // After deletion, refresh the fruitlist to get the
                                // updated data.
                                Provider.of<FruitModel>(context, listen: false)
                                    .refresh(Provider.of<DayModel>(context,
                                            listen: false)
                                        .currentDate))
                            // Finally, close this dialog.
                            .then((value) => Navigator.of(context).pop());
                      }),
              ],
            ),
            Row(
              children: [
                Text("KG"),
                Expanded(
                    child: TextField(
                        controller: kg,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                      // Only 0-9 are allowed in the field,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ])),
                IconButton(icon: Icon(Icons.add), onPressed: () => add(kg)),
                IconButton(
                    icon: Icon(Icons.remove), onPressed: () => subtract(kg))
              ],
            ),
            Row(
              children: [
                Text("ML"),
                Expanded(
                    child: TextField(
                        controller: ml,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                      // Only 0-9 are allowed in the field,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ])),
                IconButton(icon: Icon(Icons.add), onPressed: () => add(ml)),
                IconButton(
                    icon: Icon(Icons.remove), onPressed: () => subtract(ml))
              ],
            ),
            Expanded(
              child: TextField(
                controller: comment,
                decoration: InputDecoration(hintText: "Comment"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("CANCEL")),
                SizedBox(
                  width: 10,
                ),
                // If no MLKG is provided, then ADD functionality is displayed.
                if (widget.mlkg == null)
                  TextButton(
                      onPressed: () {
                        String inputML = ml.text;
                        String inputKG = kg.text;
                        String inputComment = comment.text;

                        // Construct an MLKG item from the strings in the
                        // textfields to insert into the database.
                        Provider.of<FruitModel>(context, listen: false)
                            .addMLKG(new MLKG(
                                fid: widget.fruit.id,
                                ml: inputML,
                                kg: inputKG,
                                comment: inputComment))
                            .then((value) =>
                                // After addition, update the model's fields to
                                // reflect the changes in data.
                                Provider.of<FruitModel>(context, listen: false)
                                    .refresh(Provider.of<DayModel>(context,
                                            listen: false)
                                        .currentDate))
                            // Successfull insertions leads to
                            // dialog being dismissed.
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: Text("ADD"))
                // In case of MLKG being provided, update functionality is run.
                else
                  TextButton(
                      onPressed: () {
                        widget.mlkg.ml = ml.text;
                        widget.mlkg.kg = kg.text;
                        widget.mlkg.comment = comment.text;

                        // Update an exisiting MLKG item using data
                        // from the data present in the textfields.
                        Provider.of<FruitModel>(context, listen: false)
                            .updateMLKG(widget.mlkg)
                            .then((value) =>
                                // After updating, update the model's fields to
                                // reflect the changes in data.
                                Provider.of<FruitModel>(context, listen: false)
                                    .refresh(Provider.of<DayModel>(context,
                                            listen: false)
                                        .currentDate))
                            // Successfull updating leads to
                            // dialog being dismissed.
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: Text("UPDATE"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
