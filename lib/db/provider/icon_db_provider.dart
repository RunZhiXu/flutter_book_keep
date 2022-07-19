import 'package:book_keeping_app/db/base_db.dart';

class IconDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          icon_category_id integer not null,
          name text not null,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return 'icon';
  }
}
