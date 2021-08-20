import 'package:fluttertoast/fluttertoast.dart';
import 'package:fruitapp/NameFruit.dart';
import 'package:fruitapp/SubNameFruit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Fruit.dart';
import '../MLKG.dart';

class DatabaseQuery {
  DatabaseQuery._();

  static final DatabaseQuery db = DatabaseQuery._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  // Creating database and Table using initDB function
  initDB() async {
    // Creating database
    return openDatabase(join(await getDatabasesPath(), "TestDB.db"), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE NameFruitDialog("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "imageSource TEXT"
          ")");

      // name is the foreign key of NameFruitDialog
      await db.execute("CREATE TABLE SubCategoryFruitDialog ("
          "id INTEGER PRIMARY KEY,"
          "nameFruitId INTEGER,"
          "type TEXT,"
          "imageSource TEXT"
          ")");

      // Creating table and making date as a primary key
      await db.execute("CREATE TABLE Fruit ("
          "id INTEGER PRIMARY KEY,"
          "subCategoryId INTEGER,"
          "comment TEXT,"
          "date TEXT,"
          "time TEXT,"
          "categorySize"
          ")");

      await db.execute("CREATE TABLE MLKG ("
          "id INTEGER PRIMARY KEY,"
          "fid INTEGER,"
          "ml TEXT,"
          "kg TEXT,"
          "comment TEXT"
          ")");
    });
  }

  //**** Name Fruit Dialog Database **********************//

  Future<int> newNameFruitDialog(NameFruit nameFruit) async {
    final db = await database;
    try {
      // Query for inserting NameFruit
      var res = await db.insert("NameFruitDialog", nameFruit.toMap());
      return res;

    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Already Exists in your List");
      return -1;
    }

  }

  //Updating NameFruit in the database using name
  Future<bool> updateNameFruitDialog(NameFruit nameFruit) async {
    final db = await database;
    try {
      //Query for updating NameFruit
      var res = await db.rawQuery(
          'SELECT * FROM NameFruitDialog WHERE name=?', [nameFruit.name]);
      List<NameFruit> list =
          res.isNotEmpty ? res.map((c) => NameFruit.fromMap(c)).toList() : [];
      if (list.isEmpty) {
        var res = await db.update("NameFruitDialog", nameFruit.toMap(),
            where: "id = ?", whereArgs: [nameFruit.id]);
        Fluttertoast.showToast(msg: "Added");
        return true;
      }
      return false;
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "This name already exists");
      return false;
    }
  }

  Future<List<NameFruit>> getNameFruitDialog() async {
    final db = await database;
    try {
      var res = await db.rawQuery('SELECT * FROM NameFruitDialog');
      List<NameFruit> list =
          res.isNotEmpty ? res.map((c) => NameFruit.fromMap(c)).toList() : [];
      return list;
    } on DatabaseException {
      Fluttertoast.showToast(msg: StackTrace.current.toString());
    }
    return [];
  }

  // ********* SubFruitDialog Database **************//

  newSubNameFruitDialog(SubNameFruit subNameFruit) async {
    final db = await database;
    try {
      // Query for inserting MLKG
      var res = await db.insert("SubCategoryFruitDialog", subNameFruit.toMap());
      Fluttertoast.showToast(msg: "Added");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Already Exists in your List");
    }
  }

  //Updating NameFruit in the database using name
  Future<bool> updateTypeOfSubNameFruitDialog(
      SubNameFruit subNameFruit) async {
    final db = await database;

    var res = await db.rawQuery(
        'SELECT * FROM SubCategoryFruitDialog WHERE nameFruitId=? AND type=?',
        [subNameFruit.nameFruitId, subNameFruit.type]);

    List<SubNameFruit> list =
        res.isNotEmpty ? res.map((c) => SubNameFruit.fromMap(c)).toList() : [];

    if (list.isEmpty) {
      try {
        var res = await db.update(
            "SubCategoryFruitDialog", subNameFruit.toMap(),
            where: "id= ?", whereArgs: [subNameFruit.id]);
        return true;
      } on DatabaseException {
        // If exception is thrown by database
        Fluttertoast.showToast(msg: StackTrace.current.toString());
        return false;
      }
    } else {
      // Type Already Exist with this name
      return false;
    }
  }

  // //get SubNameFruit in the database using name
  Future<List<SubNameFruit>> getSubNameFruitDialog(int id) async {
    final db = await database;
    try {

      var res = await db.rawQuery(
          'Select * from SubCategoryFruitDialog where nameFruitId=?',
          [id]);


      List<SubNameFruit> list = res.isNotEmpty
          ? res.map((c) => SubNameFruit.fromMap(c)).toList()
          : [];

      var response = await db.rawQuery(
          'Select * from NameFruitDialog where id=?',
          [id]);


      List<NameFruit> nameList = response.isNotEmpty
          ? response.map((c) => NameFruit.fromMap(c)).toList()
          : [];


      for(var index=0;index<list.length;index++){
        list[index].nameFruitId = nameList[0].id;
        list[index].name = nameList[0].name;
      }

      return list;
    } on DatabaseException {
      Fluttertoast.showToast(msg: StackTrace.current.toString());
    }
    return [];
  }

  //*********************************** MLKG Database ******************************//

  newMLKG(MLKG mlkg) async {
    final db = await database;
    try {
      // Query for inserting MLKG
      var res = await db.insert("MLKG", mlkg.toMap());
      Fluttertoast.showToast(msg: "Added");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Already Exists in your List");
    }
  }

  //Updating MLKG in the database using date
  updateMLKG(MLKG mlkg, bool toastOption) async {
    print("MLKGssss:" + mlkg.id.toString());
    final db = await database;
    try {
      //Query for updating MLKG
      var res = await db
          .update("MLKG", mlkg.toMap(), where: "id = ?", whereArgs: [mlkg.id]);
      if (toastOption) Fluttertoast.showToast(msg: "Updated Successfully");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: StackTrace.current.toString());
    }
  }

  //Delete MLKG from database using date.
  Future deleteMLKG(MLKG mlkg) async {
    print("mlkg delete" + mlkg.id.toString());
    final db = await database;
    try {
      //Query for deleting MLKG from database
      db.delete("MLKG", where: "id = ?", whereArgs: [mlkg.id]);
      Fluttertoast.showToast(msg: "Deleted Successfuly");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Deleted");
    }
  }

  // ********************************** Fruit Database *************************//

  // Inserting new Fruit into the database
  Future<bool> newFruit(Fruit newFruit) async {

    final db = await database;
    try {
      var checkFruitInDatabase = await db.rawQuery(
          'Select * from Fruit where subCategoryId=? AND date=?',
          [newFruit.subCategoryId, newFruit.date]);
      if (checkFruitInDatabase.isEmpty) {
        // Query for inserting Fruit
        var res = await db.insert("Fruit", newFruit.toMap());
        return true;
      }
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Already Exists in your List");
    }
    return false;
  }

  //Updating Fruit in the database using date
  updateFruit(Fruit newFruit) async {
    final db = await database;
    try {
      //Query for updating Fruit
      var res = await db.update("Fruit", newFruit.toMap(),
          where: "id = ?", whereArgs: [newFruit.id]);
    } on DatabaseException {
      print(StackTrace.current.toString());
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Updated");
    }
  }

  //Delete Fruit from database using date.
  Future deleteFruit(Fruit item) async {
    final db = await database;
    try {
      //Query for deleting Fruit from database
      db.delete("Fruit", where: "id = ?", whereArgs: [item.id]);
      Fluttertoast.showToast(msg: "Deleted Successfuly");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Deleted");
    }
  }

  // To clear the database
  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Fruit");
  }

  // ************************** Get All Fruits ************************ //

// Fetching Fruits from database
  Future<List<Fruit>> getFruitsByDate(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM Fruit WHERE date=?', [date]);

    //Fetching records from database and convert into Fruit type objects
    List<Fruit> list =
        res.isNotEmpty ? res.map((c) => Fruit.fromMap(c)).toList() : [];

    var weight;
    //Fetching MLKG for each Fruit
    for (int i = 0; i < list.length; i++) {

      if (list.isNotEmpty) {

        var subNameFruit = await db.rawQuery('SELECT * FROM SubCategoryFruitDialog WHERE id=?', [list[i].subCategoryId]);
        List<SubNameFruit> subList =  subNameFruit.isNotEmpty ? subNameFruit.map((c) => SubNameFruit.fromMap(c)).toList() : [];

        var nameFruit = await db.rawQuery('SELECT * FROM NameFruitDialog WHERE id=?', [subList[0].nameFruitId]);
        List<NameFruit> nameFruitList =  nameFruit.isNotEmpty ? nameFruit.map((c) => NameFruit.fromMap(c)).toList() : [];

        print("Name:"+nameFruitList[0].name);
        list[i].name = nameFruitList[0].name;
        list[i].type = subList[0].type;
        list[i].imageSource = subList[0].imageSource;

        weight =  await db.rawQuery('SELECT * FROM MLKG WHERE fid=?', [list[i].id]);
        // print("List return:"+weight.length.toString());
        for (var item in weight) {
          list[i].mlkg.add(new MLKG.fromMap(item));
        }
      }
    }
    return list;
  }




  // Get all UNIQUE dates that have been inserted into the databse.
  Future<List<DateTime>> getAllDates() async {
    final db = await database;
    final List<Map<String, dynamic>> rows =
        await db.query("Fruit", distinct: true, columns: ["date"]);
    final dates = <DateTime>[];

    rows.forEach((Map<String, dynamic> element) {
      // Need to split date in dd/mm/yyyy format into a list like [dd, mm, yyyy]
      // to convert it into a DateTime object.
      List<String> dayMonthYear = element["date"].split('/');

      // Datetime accepts dates in int format, with first argument being
      // the year, then the month and then the day.
      DateTime fruitDate = DateTime(int.parse(dayMonthYear[2]),
          int.parse(dayMonthYear[1]), int.parse(dayMonthYear[0]));

      dates.add(fruitDate);
    });

    return dates;
  }

  // Get a single fruit (matching the specified ID) and it's
  // associated MLKG items from the database.
  Future<Fruit> getFruit(int id) async {
    final db = await database;

    // First get the fruit
    final List<Map<String, dynamic>> row =
        await db.query("Fruit", where: "id = ?", whereArgs: [id]);

    Fruit fetched = Fruit.fromMap(row.first);

    var subNameFruit = await db.rawQuery('SELECT * FROM SubCategoryFruitDialog WHERE id=?', [fetched.subCategoryId]);
    List<SubNameFruit> subList =  subNameFruit.isNotEmpty ? subNameFruit.map((c) => SubNameFruit.fromMap(c)).toList() : [];

    var nameFruit = await db.rawQuery('SELECT * FROM NameFruitDialog WHERE id=?', [subList[0].nameFruitId]);
    List<NameFruit> nameFruitList =  nameFruit.isNotEmpty ? nameFruit.map((c) => NameFruit.fromMap(c)).toList() : [];

    print("Name:"+nameFruitList[0].name);
    fetched.name = nameFruitList[0].name;
    fetched.type = subList[0].type;
    fetched.imageSource = subList[0].imageSource;


    // And then get the MLKGs.
    final List<Map<String, dynamic>> mlkgs =
        await db.query("MLKG", where: "fid = ?", whereArgs: [id]);

    // Finally, append the MLKG items to the Fruit.
    mlkgs.forEach((element) {
      fetched.mlkg.add(new MLKG.fromMap(element));
    });

    return fetched;
  }
}
