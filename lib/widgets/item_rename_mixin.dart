import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemRenameMixin {

  // Get Rename dialog return the dialog for getting input from user. And calls function which is passed from Dialogs
  // (NameFruitGridCard or SubNameFruitGridCard)
  Widget getRenameDialog(BuildContext context, Function(String) onUpdateTap) {
    final textEditingController = TextEditingController();

    return AlertDialog(
      content: Container(
        child: TextField(
          maxLines: 5,
          minLines: 1,
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: 'Rename',
            labelStyle: TextStyle(
              color: Color(0xFF6200EE),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF6200EE)),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => onUpdateTap(textEditingController.text),
          child: Text('UPDATE'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
