// 基础datebase
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDatabase {
  Database? database;

  static const String dbName = 'book_keep_app.db';

  String tableName();

  Future<Database> open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    database = await openDatabase(
      path,
      version: 1,
    );
    return database!;
  }

  Future createTable();

  Future<int> insert(Map<String, dynamic> json) async {
    var id = await database!.insert(tableName(), json);
    return id;
  }

  Future<int> update(Map<String, dynamic> json, int id) async {
    return await database!
        .update(tableName(), json, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, Object?>?> getOne(int id, List<String>? columns) async {
    List<Map<String, Object?>> maps = await database!
        .query(tableName(), columns: columns, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, Object?>>?> getList({List<String>? columns}) async {
    List<Map<String, Object?>> maps = await database!.query(
      tableName(),
      columns: columns,
    );
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await database!
        .delete(tableName(), where: 'id = ?', whereArgs: [id]);
  }

  Future close() async => database!.close();
}