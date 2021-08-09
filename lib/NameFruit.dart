class NameFruit {

  String name,dummyName,imageSource;

  NameFruit({
    this.name,this.dummyName, this.imageSource});

  // Conversion from json to MLKG object
  factory NameFruit.fromMap(Map<String, dynamic> json) => new NameFruit(
      name:json["name"],
      dummyName: json["dummyName"],
      imageSource:json["imageSource"]);

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
    "name": name,
    "dummyName": dummyName,
    "imageSource": imageSource
  };
}
