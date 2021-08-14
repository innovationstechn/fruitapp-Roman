import 'package:flutter/material.dart';
import 'package:fruitapp/Card/GridCard.dart';

class ItemGridMixin {
  Widget gridViewBuilder(
      List<GridCard> list, Function onTap, Function onDoubleTap) {
    return GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (1 / 1.3),
      ),
      itemBuilder: (
        context,
        index,
      ) {
        return GestureDetector(
            onTap: onTap, onDoubleTap: onDoubleTap, child: list[index]);
      },
    );
  }
}
