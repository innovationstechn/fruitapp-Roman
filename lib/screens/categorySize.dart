import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySize extends StatefulWidget {
  String selected;
  final bool clickEnable;

  CategorySize({this.selected, this.clickEnable});

  @override
  _CategorySize createState() => _CategorySize();
}

class _CategorySize extends State<CategorySize> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ElevatedButton(

          style: ButtonStyle(
            shape:MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
              )),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
                return widget.selected == "large" ? Colors.red : Colors.grey;
                },
            ),
          ),
          child: Text(
            "large",
          ),
          onPressed: widget.clickEnable? () {
            setState(() {
             widget.selected = "large";
            });
          }:null),
      SizedBox(
        width: 10,
      ),
      ElevatedButton(
          style: ButtonStyle(
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),)),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return widget.selected == "middle" ? Colors.red : Colors.grey;},)),

          child: Text("middle"),
          onPressed: widget.clickEnable? () {
            setState(() {
              widget.selected = "middle";
            });
          }:null
      ),

      SizedBox(
        width: 10,
      ),
      ElevatedButton(

      style: ButtonStyle(
      shape:MaterialStateProperty.all<RoundedRectangleBorder>(
         RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return widget.selected == "light" ? Colors.red : Colors.grey;},)),

        child: Text("light"),
        onPressed: widget.clickEnable? () {
                setState(() {
                  widget.selected = "light";
                });
              }:null
      ),

    ]);
  }
}
