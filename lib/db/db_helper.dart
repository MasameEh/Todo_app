import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      print('database not null');
      return;
    } else {
      try {
        var databasesPath = await getDatabasesPath();

        openDatabase(
          databasesPath,
          version: _version,
          onCreate: (db, version) async
          {
             await db.execute(
              'CREATE TABLE $_tableName ('
                  'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                  'title STRING '
                  'note TEXT, date STRING'
                  'endTime STRING, startTime STRING'
                  'remind INTEGER, repeat INTEGER '
                  'color INTEGER, isCompleted INTEGER)',
            );
             print('database created');
          },
          onOpen: (db) {
            print('database opened');
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }
}
