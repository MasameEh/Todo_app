import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task.dart';


class DBHelper {
  static Database? db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (db != null) {
      print('database not null');
      return;
    } else {
      try {
        var databasesPath = await getDatabasesPath();
        String path = join(databasesPath, 'todo.db');

        db = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) async
          {
             await db.execute(
              'CREATE TABLE $_tableName ('
                  'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                  'title STRING, note STRING, date STRING,'
                  'startTime STRING, endTime STRING,'
                  'remind INTEGER, repeat STRING,'
                  'color INTEGER, isCompleted INTEGER)',
            );
             print('database created');
          },
          onOpen: (db) {
            print('database opened');
          },
        );
      } catch (e) {
        print('Database initialization error: $e');
      }
    }
  }

   static Future<int> insert(Task? task) async
  {
    print('insert function is called');
    try
    {
       return await db!.insert(_tableName, task!.toJson());
    }catch(e)
    {
      print('We are here');
      return 9000;
    }

  }

  static Future<int> delete(Task task) async
  {
    print('delete function is called');
    return await db!.delete(_tableName, where: 'id= ?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async
  {
    print('query function is called');
    return await db!.query(_tableName);
  }

  static Future<int> update(int id) async
  {
    print('update function is called');
    return await db!.rawUpdate('UPDATE tasks SET isCompleted = ? WHERE id = ?',
        [1, id]);
  }

}
