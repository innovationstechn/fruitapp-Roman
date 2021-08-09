class SubNameFruit {

  String name,type,dummyName,dummyType,imageSource;

  SubNameFruit({
    this.name,this.type,this.dummyName,this.dummyType, this.imageSource});

  // Conversion from json to MLKG object
  factory SubNameFruit.fromMap(Map<String, dynamic> json) => new SubNameFruit(
      name:json["name"],
      type:json["type"],
      dummyName:json["dummyName"],
      dummyType:json["dummyType"],
  );

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
    "name": name,
    "type": type,
    "dummyName": dummyName,
    "dummyType": dummyType
  };
}
