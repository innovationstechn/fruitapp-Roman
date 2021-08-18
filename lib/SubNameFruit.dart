class SubNameFruit {
  String name, type,imageSource;

  SubNameFruit(
      {this.name, this.type,this.imageSource});

  // Conversion from json to MLKG object
  factory SubNameFruit.fromMap(Map<String, dynamic> json) => new SubNameFruit(
        name: json["name"],
        type: json["type"],
        imageSource: json["imageSource"],
      );

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
        "name": name,
        "type": type,
        "imageSource": imageSource,
      };
}
