import 'package:book_keeping_app/db/base_db.dart';

class IconCategoryDbProvider extends BaseDatabase {
  @override
  Future createTable() async {
    await database!.execute('''
        create table ${tableName()} (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name text not null,
          create_time integer,
          update_time integer)
      ''');
  }

  @override
  String tableName() {
    return 'icon_category';
  }

  Future createList() async {
    for (var i = 0; i < iconCategoryList.length; i++) {
      await insert(iconCategoryList[i]);
    }
  }

  List<Map<String, dynamic>> iconCategoryList = [
    {"name": "收入", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "理财", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "餐饮", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "日常", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "购物", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "服饰", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "护肤", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "数码", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "电商", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "娱乐", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "运动", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "家庭", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "育儿", "create_time": 1661930954000, "update_time": 1661930954000},
    {"name": "汽车", "create_time": 1661930954000, "update_time": 1661930954000},
  ];
}
