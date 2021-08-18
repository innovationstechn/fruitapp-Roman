class NameFruit {
  String name, imageSource;

  NameFruit({this.name, this.imageSource});

  // Conversion from json to MLKG object
  factory NameFruit.fromMap(Map<String, dynamic> json) => new NameFruit(
      name: json["name"],
      imageSource: json["imageSource"]);

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() =>
      {"name": name, "imageSource": imageSource};
}
