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

      await db.execute("CREATE TABLE  NameFruitDialog("
          "name TEXT PRIMARY KEY,"
          "imageSource TEXT"
          ")");

      // name is the foreign key of NameFruitDialog
      await db.execute("CREATE TABLE SubCategoryFruitDialog ("
          "name TEXT,"
          "type TEXT,"
          "imageSource TEXT"
          ")");


      // Creating table and making date as a primary key
      await db.execute("CREATE TABLE Fruit ("
          "name TEXT,"
          "type TEXT,"
          "comment TEXT,"
          "gifPath TEXT,"
          "date TEXT,"
          "time TEXT,"
          "imageSource TEXT,"
          "categorySize,"
          "id INTEGER PRIMARY KEY"
          ")");

      await db.execute("CREATE TABLE MLKG ("
          "ml TEXT,"
          "kg TEXT,"
          "comment TEXT,"
          "fid INTEGER,"
          "id INTEGER PRIMARY KEY"
          ")");
    });
  }


  //**** Name Fruit Dialog Database **********************//

 Future newNameFruitDialog(NameFruit nameFruit) async {
    final db = await database;
    try {
      // Query for inserting NameFruit
      var res = await db.insert("NameFruitDialog", nameFruit.toMap());
      return;
      Fluttertoast.showToast(msg: "Added");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Already Exists in your List");
    }
    return;
  }

  //Updating NameFruit in the database using name
Future<bool> updateNameFruitDialog(NameFruit nameFruit, String oldFruitName) async {

    final db = await database;
    try {
      //Query for updating NameFruit
      var res = await db
          .rawQuery('SELECT * FROM NameFruitDialog WHERE name=?', [nameFruit.name]);
      List<NameFruit> list = res.isNotEmpty ? res.map((c) => NameFruit.fromMap(c)).toList() : [];
      if(list.isEmpty){
        var res = await db
            .update("NameFruitDialog", nameFruit.toMap(), where: "name = ?", whereArgs: [oldFruitName]);
            Fluttertoast.showToast(msg: "Added");
            return true;
      }
      return false;
      // if (toastOption) Fluttertoast.showToast(msg: "Updated Successfully");
    } on DatabaseException {
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "This name already exists");
      return false;
    }
  }


  Future<List<NameFruit>>  getNameFruitDialog() async {
    final db = await database;
    try {
      var res = await db.rawQuery('SELECT * FROM NameFruitDialog');
      List<NameFruit> list = res.isNotEmpty ? res.map((c) => NameFruit.fromMap(c)).toList() : [];
      return list;
    } on DatabaseException{
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
Future<bool>  updateTypeOfSubNameFruitDialog(SubNameFruit subNameFruit, String oldType) async {

    final db = await database;

    var res = await db
        .rawQuery('SELECT * FROM SubCategoryFruitDialog WHERE name=? AND type=?', [subNameFruit.name, subNameFruit.type]);

    List<SubNameFruit> list = res.isNotEmpty ? res.map((c) => SubNameFruit.fromMap(c)).toList() : [];

    if(list.isEmpty){
      try {
        //Query for updating MLKG
        var res = await db
            .update("SubCategoryFruitDialog", subNameFruit.toMap(), where: "name= ? AND type = ?", whereArgs: [subNameFruit.name,oldType]);
          return true;
        // if (toastOption) Fluttertoast.showToast(msg: "Updated Successfully");
      } on DatabaseException {
        // If exception is thrown by database
        Fluttertoast.showToast(msg: StackTrace.current.toString());
        return false;
      }

    }
    else{
      // Type Already Exist with this name
      return false;
    }

  }

  //Updating NameFruit in the database using name
Future<bool> updateNameOfSubNameFruitDialog(String oldName, String newName) async {

    final db = await database;
    Map<String, dynamic> row = {
      "name" : newName,
    };
    try {
      //Query for updating Fruit
      var res = await db.update("SubCategoryFruitDialog", row,
          where: "name = ?", whereArgs: [oldName]);
      // Fluttertoast.showToast(msg: "Updated SubName Successfully");
      return true;
    } on DatabaseException {
      print(StackTrace.current.toString());
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Updated");
      return false;
    }

  }



  //get SubNameFruit in the database using name
  Future<List<SubNameFruit>>  getSubNameFruitDialog() async {
    final db = await database;
    try {
      var res = await db.rawQuery('SELECT * FROM SubCategoryFruitDialog');
      List<SubNameFruit> list = res.isNotEmpty ? res.map((c) => SubNameFruit.fromMap(c)).toList() : [];
      return list;
    } on DatabaseException{
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
    print('newFruit : ' + newFruit.date);

    final db = await database;
    try {
      var checkFruitInDatabase = await db.rawQuery(
          'Select * from Fruit where name=? AND type=? AND date=?',
          [newFruit.name, newFruit.type, newFruit.date]);
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
  updateFruit(Fruit newFruit, bool toastOption) async {
    final db = await database;
    try {
      //Query for updating Fruit
      var res = await db.update("Fruit", newFruit.toMap(),
          where: "id = ?", whereArgs: [newFruit.id]);
      if (toastOption) Fluttertoast.showToast(msg: "Updated Successfully");
    } on DatabaseException {
      print(StackTrace.current.toString());
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Updated");
    }
  }

 // Updating Fruit by name

  updateFruitByName(String oldName,String newName) async {
    final db = await database;
    Map<String, dynamic> row = {
      "name" : newName,
    };
    try {
      //Query for updating Fruit
      var res = await db.update("Fruit", row,
          where: "name = ?", whereArgs: [oldName]);
    } on DatabaseException {
      print(StackTrace.current.toString());
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Updated");
    }
  }


 Future<bool> updateFruitByType(SubNameFruit nameFruit,String oldType) async {
    final db = await database;
    Map<String, dynamic> row = {
      "type" : nameFruit.type
    };
    try {
      //Query for updating Fruit
      // var res = await db
      //     .rawQuery('SELECT * FROM Fruit WHERE name=? AND type=?', [nameFruit.name, oldType]);
      var res = await db.update("Fruit", row,
          where: "name=? AND type = ?", whereArgs: [nameFruit.name,oldType]);
      return true;
    } on DatabaseException {
      print(StackTrace.current.toString());
      // If exception is thrown by database
      Fluttertoast.showToast(msg: "Not Updated");
      return false;
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
  Future<List<Fruit>> getAllFruits(String name, String date) async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM Fruit WHERE name=? AND date=?', [name, date]);

    //Fetching records from database and convert into Fruit type objects
    List<Fruit> list =
        res.isNotEmpty ? res.map((c) => Fruit.fromMap(c)).toList() : [];

    var weight;
    //Fetching MLKG for each Fruit
    for (int i = 0; i < list.length; i++) {
      print("Fid:" + list[i].id.toString());

      weight =
          await db.rawQuery('SELECT * FROM MLKG WHERE fid=?', [list[i].id]);
      // print("List return:"+weight.length.toString());
      for (var item in weight) {
        list[i].mlkg.add(new MLKG.fromMap(item));
      }

      print("Fid:" +
          list[i].id.toString() +
          "  Mlkg : " +
          list[i].mlkg.length.toString());
    }
    return list;
  }

  Future<List<Fruit>> getFruitsByDate(String date) async {
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM Fruit WHERE date=?', [date]);

    //Fetching records from database and convert into Fruit type objects
    List<Fruit> list =
    res.isNotEmpty ? res.map((c) => Fruit.fromMap(c)).toList() : [];

    var weight;
    //Fetching MLKG for each Fruit
    for (int i = 0; i < list.length; i++) {
      print("Fid:" + list[i].id.toString());

      if(list.isNotEmpty) {
        weight =
        await db.rawQuery('SELECT * FROM MLKG WHERE fid=?', [list[i].id]);
        // print("List return:"+weight.length.toString());
        for (var item in weight) {
          list[i].mlkg.add(new MLKG.fromMap(item));
        }

        print("Fid:" +
            list[i].id.toString() +
            "  Mlkg : " +
            list[i].mlkg.length.toString());
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
