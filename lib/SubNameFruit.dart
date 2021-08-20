class SubNameFruit {
  String name, type,imageSource;
  int id,nameFruitId;

  SubNameFruit(
      {this.id,this.nameFruitId, this.type,this.imageSource});

  // Conversion from json to MLKG object
  factory SubNameFruit.fromMap(Map<String, dynamic> json) => new SubNameFruit(
        id: json["id"],
        nameFruitId: json["nameFruitId"],
        type: json["type"],
        imageSource: json["imageSource"],
      );

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
        if(id!=null)
          "id": id,
        "nameFruitId":nameFruitId,
        "type": type,
        "imageSource": imageSource,
      };
}
