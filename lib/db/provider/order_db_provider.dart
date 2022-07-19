import 'package:book_keeping_app/db/base_db.dart';

class OrderDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          type text not null,
          count REAL not null,
          category_id integer,
          parent_id integer,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return "hi_order";
  }
}
