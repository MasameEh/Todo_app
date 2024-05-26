import 'package:sqflite/sqflite.dart';

import '../models/task.dart';


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

  static Future<int> insert(Task? task) async
  {
    print('insert function is called');
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async
  {
    print('delete function is called');
    return await _db!.delete(_tableName, where: 'id: ?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async
  {
    print('query function is called');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async
  {
    print('update function is called');
    return await _db!.rawUpdate('UPDATE tasks SET isCompleted = ? WHERE id = ?',
        [1, id]);
  }

}
