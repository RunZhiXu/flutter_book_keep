import 'package:sqflite/sqflite.dart';

Future<int> tableExists(Database database, String tableName) async {
  var res = await database
      .query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);

  return res.length;
}
