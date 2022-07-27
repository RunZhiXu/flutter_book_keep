import 'package:book_keeping_app/db/base_db.dart';

class OrderIconDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name text not null,
          nickname text not null,
          icon_id integer not null,
          parent_id integer not null,
          type integer not null,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return 'order_icon';
  }
}
