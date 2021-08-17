import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../NameFruit.dart';

class NameDecoration {
  Widget getDecorationDialog(BuildContext context,NameFruit nameFruit) {
    final textEditingController = TextEditingController();
    return AlertDialog(
      content: Container(child: Column(
        children: [
          Text("Font size:"),
          TextField(
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
          )
        ],
      ),),
    );
  }
}
