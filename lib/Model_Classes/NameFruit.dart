import 'dart:convert';

class NameFruit {
  String name, imageSource;
  int id;

  NameFruit({this.id, this.name, this.imageSource});

  // Conversion from json to MLKG object
  factory NameFruit.fromMap(Map<String, dynamic> json) => new NameFruit(
      id: json["id"], name: json["name"], imageSource: json["imageSource"]);

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
    "name": name,
    "imageSource": imageSource,
    if(id!=null)
      "id": id,
  };

}
