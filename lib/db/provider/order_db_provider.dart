import 'package:book_keeping_app/db/base_db.dart';

class OrderDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          type integer not null,
          count text not null,
          category_id integer,
          parent_id integer,
          description text,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return "hi_order";
  }

  Future<List<Map<String, Object?>>?> getOrderListByTime(
      {required int startTime, required int endTime}) async {
    List<Map<String, Object?>> maps = await database!.query(tableName(),
        columns: null,
        where: 'create_time > ? and create_time < ?',
        whereArgs: [startTime, endTime]);
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }
}
