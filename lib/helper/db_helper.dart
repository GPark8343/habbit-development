import 'package:habbit/models/folder.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> storyDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'story.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE users_story(id TEXT PRIMARY KEY, title TEXT, image TEXT, description TEXT, created_at TEXT, category TEXT, folder_id TEXT)');
    }, version: 1);
  }

  static Future<void> insertStory(String table, Map<String, Object> data) async {
    final db = await DBHelper.storyDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getStoryData(String table) async {
    final db = await DBHelper.storyDatabase();
    return db.query(table);
  }

//   Future update(String table, Map<String, Object> data, String title) async {
//   final db = await DBHelper.database();
//   await db.update(
//     table,  // table name
//     {
//     title:
//     },  // update post row data
//     where: 'id = ?',
//     whereArgs: [data['']],
//   );
// }

  static Future deleteStory(String table, String id) async {
    final db = await DBHelper.storyDatabase();
    await db.delete(
      table, // table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }


   static Future<Database> folderDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'folder.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_folder(id TEXT PRIMARY KEY, title TEXT, description TEXT, created_at TEXT, category TEXT, days INTEGER)');
    }, version: 1);
  }

  static Future<void> insertFolder(String table, Map<String, Object> data) async {
    final db = await DBHelper.folderDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getFolderData(String table) async {
    final db = await DBHelper.folderDatabase();
    return db.query(table);
  }

 static Future updateFolder(String table, Folder folder) async {
  final db = await DBHelper.folderDatabase();
  await db.update(
    table,  // table name
    folder.toMap()
    ,  // update post row data
    where: 'id = ?',
    whereArgs: [folder.id],
  );
}

  static Future deleteFolder(String table, String id) async {
    final db = await DBHelper.folderDatabase();
    await db.delete(
      table, // table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
