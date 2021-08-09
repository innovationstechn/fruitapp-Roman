class MLKG {

  String ml, kg, comment;
  int fid,id;

  MLKG({
    this.ml, this.kg, this.comment, this.fid, this.id});

  // Conversion from json to MLKG object
  factory MLKG.fromMap(Map<String, dynamic> json) => new MLKG(
      ml:json["ml"],
      kg:json["kg"],
      comment:json["comment"],
      fid:json["fid"],
      id:json["id"]);

  // Mapping MLKG for database.
  Map<String, dynamic> toMap() => {
    "ml": ml,
    "kg": kg,
    "comment": comment,
    "fid": fid,
    if(id!=null)
      "id": id
  };
}
