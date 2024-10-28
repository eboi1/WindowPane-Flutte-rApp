import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/image.dart';

late final Database _database;
const tableImages = 'tableImages';

////////////////////
//  INITIALIZATION
////////////////////
Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (await databaseExists(await getDatabasesPath())) {
      //await deleteDatabase(await getDatabasesPath());
      print('exist!!!');
    }

    _database = await openDatabase(
      join(await getDatabasesPath(), 'tableImages.db'),
      onCreate: (db, version) async {
        try {
          await db.execute("CREATE TABLE $tableImages(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT, location TEXT, weather TEXT, temp INTEGER, image BLOB)",);
        } catch (e) {
          print('Error creating table');
          print(e);
        }
      },
      version: 1,
    );
}

//////////////
// QUERY TABLE
//////////////
Future<List<ImageModel>> queryImages({String? title}) async {
   final List results = await _database.query(
     tableImages,
     where: 'title LIKE ?',
     orderBy: 'title',
     whereArgs: ['%${title ?? ''}%'],
   );
    return results.map((result) => ImageModel.fromMap(result)).toList();
}

////////////////////
//  INSERT ENTRY
////////////////////
Future<void> insertImageData(String title, String weather, String location, String dateTime, Uint8List imageData, int temp) async {
  print('Database path: ${join(await getDatabasesPath(), 'tableImages.db')}');

  try {
    await _database.insert(
      tableImages,
      {
        'title': title,
        'weather': weather,
        'temp': temp,
        'location': location,
        'date': dateTime,
        'image': imageData,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  } catch (e) {
    print(e);
  } 

  // Function to delete all entries in the table
  // Future<void> deleteAllEntries() async {
  //   try {
  //     await _database.delete(
  //       tableImages,
  //       where: '1', // This is a valid condition that matches all rows
  //     );
  //     print('All entries deleted from $tableImages');
  //   } catch (e) {
  //     print('Error deleting entries: $e');
  //   }
  // }

  // Example function to use the delete function
  // void clearDatabase() async {
  //   await init(); // Ensure the database is initialized
  //   await deleteAllEntries(); // Call the function to delete all entries
  // }
}