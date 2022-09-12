import 'package:book_keeping_app/db/base_db.dart';
import 'package:book_keeping_app/db/provider/order_icon_db_provider.dart';
import 'package:book_keeping_app/model/hi_order_mo.dart';
import 'package:book_keeping_app/model/month_order_mo.dart';

import '../../util/format_util.dart';

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

  // 获取某个时间段的订单
  Future<List<Map<String, Object?>>?> getOrderListByTime(
      {required int startTime, required int endTime}) async {
    List<Map<String, Object?>> maps = await database!.query(tableName(),
        columns: null,
        where: 'create_time >= ? and create_time <= ?',
        whereArgs: [startTime, endTime]);
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  // 将订单按日分组
  Future<List<MonthOrderMo>> getOrderListGroupDay(List<HiOrderMo> orderList,
      {int? type}) async {
    Map<String, List> orderMap = {};
    List<MonthOrderMo> monthOrderList = [];
    for (HiOrderMo order in orderList) {
      var hiOrderList = [];
      var dateString =
          DateTime.fromMillisecondsSinceEpoch(order.createTime!).toString();
      var strArg = dateString.split(' '); // [2022-09-03, 20:49:48.539]
      var dayArg = strArg[0].split('-'); // [2022, 09, 03]
      var day = dayArg[1] + '.' + dayArg[2]; // 09.03
      if (orderMap.containsKey(day)) {
        hiOrderList = orderMap[day]!;
        var orderJson = {};
        if (type != null && order.type == type) {
          orderJson = order.toJson();
        } else {
          orderJson = order.toJson();
        }
        // 获取order icon的信息
        OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
        await orderIconDbProvider.open();
        var res =
            await orderIconDbProvider.getOne(orderJson['category_id'], null);
        orderJson["category"] = res;
        hiOrderList.add(orderJson);
        orderMap[day] = hiOrderList;
      } else {
        var orderJson = {};
        if (type != null && order.type == type) {
          orderJson = order.toJson();
        } else {
          orderJson = order.toJson();
        }
        // 获取order icon的信息
        OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
        await orderIconDbProvider.open();
        var res =
            await orderIconDbProvider.getOne(orderJson['category_id'], null);
        orderJson["category"] = res;
        hiOrderList.add(orderJson);
        orderMap[day] = hiOrderList;
      }
    }

    orderMap.forEach((day, orderList) {
      num count = 0;
      for (var order in orderList) {
        order = HiOrderMo.fromJson(order);
        count = (count * 100 + stringToNum(order.count!) * 100) / 100;
      }
      monthOrderList.add(MonthOrderMo.fromJson(
          {"day": day, "orderList": orderList, "count": "$count"}));
    });

    return monthOrderList;
  }

  /// 获取本周的支出
  Future<List<Map<String, dynamic>>> getWeekExpensesOrderList() async {
    List<Map<String, dynamic>> list = [];
    List<String> weekDays = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
    var nowTime = DateTime.now();
    var weekDay = nowTime.weekday;
    var year = nowTime.year;
    var month = nowTime.month;
    var day = nowTime.day;

    var startTime = DateTime(year, month, day)
        .subtract(Duration(days: weekDay - 1))
        .millisecondsSinceEpoch;
    var endTime = DateTime(year, month, day)
        .add(Duration(days: 8 - weekDay))
        .subtract(const Duration(milliseconds: 1))
        .millisecondsSinceEpoch;

    OrderDbProvider orderDbProvider = OrderDbProvider();
    await orderDbProvider.open();
    var res = await orderDbProvider.getOrderListByTime(
        startTime: startTime, endTime: endTime);
    var week = getWeekDays();
    if (res != null) {
      List<HiOrderMo> orderList = [];
      for (var order in res) {
        orderList.add(HiOrderMo.fromJson(order));
      }
      List<MonthOrderMo> orderListGroupList =
          await getOrderListGroupDay(orderList, type: 0);
      await orderDbProvider.close();
      for (var i = 0; i < weekDays.length; i++) {
        list.add({"name": weekDays[i], "count": 0.0});
        for (var orderListGroupListItem in orderListGroupList) {
          num count = 0;
          if (orderListGroupListItem.day == week[i]) {
            for (var order in orderListGroupListItem.orderList!) {
              count = (count * 100 + stringToNum(order.count!) * 100) / 100;
            }
            list[i] = {"name": weekDays[i], "count": count};
            break;
          }
        }
      }
    } else {
      for (var i = 0; i < weekDays.length; i++) {
        list.add({"name": weekDays[i], "count": 0.0});
      }
    }
    return list;
  }

  List<String> getWeekDays() {
    var nowTime = DateTime.now();
    var weekDay = nowTime.weekday;
    var year = nowTime.year;
    var month = nowTime.month;
    var day = nowTime.day;
    var monthMaxDay = DateTime(year, month + 1)
        .subtract(const Duration(days: 1))
        .day; // 本个月最后一天
    List<String> week = [];
    var startDay = day - weekDay + 1;
    for (var i = 0; i < 7; i++) {
      // 说明月份没变
      if (startDay + i >= 1 && startDay + i <= monthMaxDay) {
        var weekMonth = month >= 10 ? "$month" : "0$month";
        var dayString =
            startDay + i >= 10 ? "${startDay + i}" : "0${startDay + i}";
        week.add("$weekMonth.$dayString");
      } else {
        // 下一月
        var weekMonth = month + 1 >= 10 ? "${month + 1}" : "0${month + 1}";
        var dayString = startDay + i - monthMaxDay >= 10
            ? "${startDay + i - monthMaxDay}"
            : "0${startDay + i - monthMaxDay}";
        week.add("$weekMonth.$dayString");
      }
    }
    return week;
  }
}
