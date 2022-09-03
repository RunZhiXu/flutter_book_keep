import 'package:book_keeping_app/db/base_db.dart';

class IconDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          icon_category_id integer not null,
          nickname text not null,
          name text not null,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return 'icon';
  }

  /// 通过icon分类id获取对应icon列表
  Future<List<Map<String, Object?>>?> getListByCategoryId(
      int categoryId) async {
    List<Map<String, Object?>> maps = await database!.query(tableName(),
        columns: null, where: 'icon_category_id = ?', whereArgs: [categoryId]);
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  Future createList() async {
    for (var i = 0; i < iconList.length; i++) {
      await insert(iconList[i]);
    }
  }

  // TODO 最后完善完整的icon
  List<Map<String, dynamic>> iconList = [];
}
