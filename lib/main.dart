import 'package:book_keeping_app/db/hi_cache.dart';
import 'package:book_keeping_app/db/provider/icon_category_db_provider.dart';
import 'package:book_keeping_app/db/provider/order_db_provider.dart';
import 'package:book_keeping_app/db/provider/order_icon_db_provider.dart';
import 'package:book_keeping_app/router/my_router_delegate.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:book_keeping_app/util/view_util.dart';
import 'package:book_keeping_app/widget/iconfont.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'db/provider/icon_db_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MyRouterDelegate _routerDelegate = MyRouterDelegate();
  var _futureBuilder;

  @override
  void initState() {
    super.initState();
    _futureBuilder = preInit();
    changeStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilder,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 定义route
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(routerDelegate: _routerDelegate)
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white),
        );
      },
    );
  }

  Future preInit() async {
    // 加载cache 和 数据库
    return Future.wait([HiCache.preInit(), createDb()]);
  }

  Future createDb() async {
    var time = DateTime.now().microsecondsSinceEpoch;
    // icon 分类表
    IconCategoryDbProvider iconCategoryDbProvider = IconCategoryDbProvider();
    await iconCategoryDbProvider.open();
    var iconCategoryDbProviderRes = await iconCategoryDbProvider
        .tableIsEmpty(iconCategoryDbProvider.tableName());
    if (iconCategoryDbProviderRes) {
      await iconCategoryDbProvider.createTable(); // 创建表
      await iconCategoryDbProvider.createList(); // 倒入数据
    }
    var iconCategoryList = await iconCategoryDbProvider.getList();
    await iconCategoryDbProvider.close(); // 关闭

    // icon
    IconDbProvider iconDbProvider = IconDbProvider();
    await iconDbProvider.open();
    var iconDbProviderRes =
        await iconDbProvider.tableIsEmpty(iconDbProvider.tableName());
    if (iconDbProviderRes) {
      // 创建icon表
      await iconDbProvider.createTable();
      // 倒入测试数据
      for (var iconCategory in iconCategoryList!) {
        IconFont.iconList.forEach((key, value) {
          iconDbProvider.iconList.add({
            "icon_category_id": iconCategory["id"],
            "nickname": "${iconCategory["name"]} ${iconCategory["id"]}",
            "name": key,
            "create_time": time,
            "update_time": time,
          });
        });
      }
      await iconDbProvider.createList();
    }
    var iconList = await iconDbProvider
        .getList(where: 'icon_category_id = ?', whereArgs: [1]);
    await iconDbProvider.close();
    // order icon
    OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
    await orderIconDbProvider.open();
    var orderIconDbProviderRes =
        await orderIconDbProvider.tableIsEmpty(orderIconDbProvider.tableName());
    if (orderIconDbProviderRes) {
      await orderIconDbProvider.createTable();
      // 添加测试的图标
      for (var icon in iconList!) {
        await orderIconDbProvider.insert({
          "name": icon["name"],
          "nickname": icon["nickname"],
          "icon_id": icon["id"],
          "parent_id": 0,
          "type": 0, // 支出
          "create_time": time,
          "update_time": time
        });
        await orderIconDbProvider.insert({
          "name": icon["name"],
          "nickname": icon["nickname"],
          "icon_id": icon["id"],
          "parent_id": 0,
          "type": 1, // 收入
          "create_time": time,
          "update_time": time
        });
      }
      await orderIconDbProvider.close();
    }
    // order
    OrderDbProvider orderDbProvider = OrderDbProvider();
    await orderDbProvider.open();
    var orderDbProviderRes =
        await orderDbProvider.tableIsEmpty(orderDbProvider.tableName());
    if (orderDbProviderRes) {
      await orderDbProvider.createTable();
      await orderDbProvider.close();
    }
  }
}
