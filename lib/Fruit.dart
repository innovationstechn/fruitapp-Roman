import 'dart:convert';

import 'MLKG.dart';

class Fruit {
  String name, type,date,description,imageSource,time, categorySize, comment;
  int id,subCategoryId;
  List<MLKG> mlkg = [];

  Fruit(this.comment,this.date, this.id,this.subCategoryId, this.time,
      this.categorySize);

  // Conversion from json to Fruit object
  factory Fruit.fromMap(Map<String, dynamic> json) => new Fruit(
      json["comment"],
      json["date"],
      json["id"],
      json["subCategoryId"],
      json["time"],
      json["categorySize"],
  );
  // Mapping Fruit for database.
  Map<String, dynamic> toMap() => {
        "subCategoryId": subCategoryId,
        "date": date,
        "comment": comment,
    if (time == null) "time": "00:00:00" else "time": time,
        if (categorySize != null)
          "categorySize": categorySize
        else
          "categorySize": "None",
        if (id != null) "id": id,
      };

}
