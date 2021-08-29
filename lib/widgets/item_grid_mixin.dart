import 'package:flutter/material.dart';

class ItemGridMixin {
  // This widget build the Grid View for NameFruitDialog,SubNameFruitDialog and calls the onTap Function when item is clicked

  Widget gridViewBuilder(
      List<Widget> list, Function(int) onTap, Function onDoubleTap) {
    return GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 / 1.3),
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () async {
              return await onTap(index);
            },
            onDoubleTap: onDoubleTap,
            child: list[index]);
      },
    );

  }
}
