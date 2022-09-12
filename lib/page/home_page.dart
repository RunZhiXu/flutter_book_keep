import 'package:book_keeping_app/db/hi_cache.dart';
import 'package:book_keeping_app/db/provider/order_db_provider.dart';
import 'package:book_keeping_app/util/view_util.dart';
import 'package:book_keeping_app/widget/date_picker.dart';
import 'package:book_keeping_app/widget/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../model/hi_order_mo.dart';
import '../model/month_order_mo.dart';
import '../util/format_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final imgUrl = 'assets/images/avatar.png';
  String selectDate = ''; // 选择的年月份
  num monthIncome = 0; // 月收入
  num monthExpenditure = 0; // 月支出
  void Function() get _popDrawer => () => Navigator.pop(context);
  int? year; // 年份
  int? month; // 月份
  List<MonthOrderMo> monthOrderList = [];
  List<Map<String, dynamic>> weekChartList = [
    {"name": "周一", "count": 0.0},
    {"name": "周2", "count": 0.0},
    {"name": "周3", "count": 0.0},
    {"name": "周4", "count": 0.0},
    {"name": "周5", "count": 0.0},
    {"name": "周6", "count": 0.0},
    {"name": "周1", "count": 0.0},
  ];

  @override
  void initState() {
    super.initState();
    var date = DateTime.now();
    var cacheYear = HiCache.getInstance().get('year') ?? date.year;
    var cacheMonth = HiCache.getInstance().get('month') ?? date.month;
    setState(() {
      year = cacheYear;
      month = cacheMonth;
      selectDate =
          "$cacheYear-${cacheMonth >= 10 ? cacheMonth : "0$cacheMonth"}";
    });
    getMonthOrder(month!);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: _title(),
        elevation: 0.5,
      ),
      drawer: _drawer(),
      body: ListView(
        children: [
          _banner(), // banner
          _dateChart(), // 最近七天汇总
          _list(),
        ],
      ),
    );
  }

  Widget _title() {
    return GestureDetector(
      onTap: () {
        _handleDatePicker();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectDate,
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(Icons.keyboard_arrow_down_outlined)
        ],
      ),
    );
  }

  // 顶部banner
  Widget _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 16,
          right: 16,
        ),
        height: 150,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: getConfigBorderRadius(),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '月结余',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      ((monthIncome * 100 - monthExpenditure * 100) / 100)
                          .toStringAsFixed(2),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
                RoundButton(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: const Text(
                    '默认账本',
                    style: TextStyle(fontSize: 12),
                  ),
                  callback: () {
                    if (kDebugMode) {
                      print('点解切换账本');
                    }
                  },
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    '月收入: ${monthIncome.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Text(
                  '月支出: ${monthExpenditure.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 左侧抽屉
  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            // drawer的头部控件
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: UnconstrainedBox(
              // 解除父级的大小限制
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  imgUrl,
                ),
              ),
            ),
          ),
          ListTile(
            // 子项
            leading: Icon(Icons.settings),
            title: Text("设置"),
            onTap: _popDrawer,
          ),
          ListTile(
            // 子项
            leading: Icon(Icons.person),
            title: Text("个人"),
            onTap: _popDrawer,
          ),
          ListTile(
            // 子项
            leading: Icon(Icons.feedback),
            title: Text("反馈"),
            onTap: _popDrawer,
          ),
        ],
      ),
    );
  }

  // 图表
  _dateChart() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Container(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 16,
          right: 16,
        ),
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '本周支出',
                  style: TextStyle(fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print('点击切换时间');
                    }
                  },
                  child: const Icon(
                    Icons.more_horiz_outlined,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Expanded(
              child: Chart(
                data: weekChartList,
                variables: {
                  'name': Variable(
                    accessor: (Map map) => map['name'] as String,
                  ),
                  'count': Variable(
                    accessor: (Map map) => map['count'] as num,
                  ),
                },
                elements: [IntervalElement()],
                axes: [
                  AxisGuide(
                    label: LabelStyle(
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xff808080),
                      ),
                      offset: const Offset(0, 7.5),
                    ),
                  ),
                  AxisGuide(
                    label: LabelStyle(
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xff808080),
                      ),
                      offset: const Offset(0, 7.5),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: monthOrderList.isNotEmpty
                ? _orderListItemWidget()
                : [const SizedBox()],
          ),
        ),
      ],
    );
  }

  // 获取某个月份的订单数据
  void getMonthOrder(int month) async {
    OrderDbProvider orderDbProvider = OrderDbProvider();
    await orderDbProvider.open();
    DateTime lastDateTime = DateTime(year!, month + 1);
    var lastDay = lastDateTime
        .subtract(const Duration(milliseconds: 1))
        .millisecondsSinceEpoch; // 本月最后一日的毫秒
    var firstDay = DateTime(year!, month).millisecondsSinceEpoch;
    var res = await orderDbProvider.getOrderListByTime(
        startTime: firstDay, endTime: lastDay);
    if (kDebugMode) {
      print("res === $res");
    }
    var weekRes = await orderDbProvider.getWeekExpensesOrderList();
    setState(() {
      weekChartList = weekRes;
    });
    if (res != null) {
      List<HiOrderMo> orderList = [];
      setState(() {
        monthOrderList = [];
      });
      for (var e in res) {
        orderList.add(HiOrderMo.fromJson(e));
      }
      var orderListGroupDay =
          await orderDbProvider.getOrderListGroupDay(orderList);
      await orderDbProvider.close();
      if (orderListGroupDay.isNotEmpty) {
        num income = 0; // 月收入
        num expenses = 0; // 月支出
        for (var orderData in orderListGroupDay) {
          var list = orderData.orderList!;
          for (var order in list) {
            if (order.type == 0) {
              // 支出
              expenses =
                  (stringToNum(order.count!) * 100 + expenses * 100) / 100;
            }
            if (order.type == 1) {
              // 收入
              income = (stringToNum(order.count!) * 100 + income * 100) / 100;
            }
          }
        }

        setState(() {
          monthOrderList = orderListGroupDay;
          monthExpenditure = monthExpenditure + expenses;
          monthIncome = monthIncome + income;
        });
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  List<Widget> _orderListItemWidget() {
    List<Widget> widgetList = []; // header
    for (var monthOrder in monthOrderList) {
      List<Widget> widgetChildList = []; // item list
      num expenses = 0; // 支出
      num income = 0; // 收入

      widgetChildList.add(
        const Divider(),
      );

      for (var i = 0; i < monthOrder.orderList!.length; i++) {
        var order = monthOrder.orderList![i];
        if (order.type == 0) {
          // 支出
          expenses = (income * 100 + stringToNum(order.count!) * 100) / 100;
        }
        if (order.type == 1) {
          // 收入
          income = (income * 100 + stringToNum(order.count!) * 100) / 100;
        }
        widgetChildList.add(
          InkWell(
            onTap: () {
              _handleOrder(order);
            },
            child: Container(
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            color: getOrderColor(order.type!)),
                      ),
                      Text("${order.category!.nickname}")
                    ],
                  ),
                  Text(
                    getOrderCountText(
                        type: order.type!, text: "${order.count}"),
                    style: TextStyle(color: getOrderColor(order.type!)),
                  )
                ],
              ),
            ),
          ),
        );
        if (i != monthOrder.orderList!.length - 1) {
          widgetChildList.add(
            const Divider(),
          );
        }
      }

      widgetList.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(bottom: 12, top: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: widgetChildList,
          ),
        ),
      );

      // header
      widgetChildList.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthOrder.day!),
              Row(
                children: [
                  expenses != 0
                      ? Text("支:${expenses.toStringAsFixed(2)}")
                      : const SizedBox(),
                  income != 0
                      ? Text(" 收:${income.toStringAsFixed(2)}")
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
    }
    return widgetList;
  }

  // 获取记账订单的颜色
  getOrderColor(int type) {
    switch (type) {
      case 0:
        return Colors.redAccent; // 0 支出
      case 1:
        return Colors.green; // 1收入
    }
  }

  // 获取订单的金额
  getOrderCountText({required int type, required String text}) {
    switch (type) {
      case 0:
        return "-$text"; // 0 支出
      case 1:
        return "+$text"; // 1收入
    }
  }

  void _handleOrder(OrderList order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 12, bottom: 20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "账单详情",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool? delete = await showDeleteConfirmDialog();
                              if (delete == true) {
                                // 选择了删除
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text(
                              "删除",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "金额",
                          ),
                          Text(
                            "${getOrderCountText(type: order.type!, text: order.count!)}",
                            style: TextStyle(
                              color: getOrderColor(order.type!),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "分类",
                          ),
                          Text(
                            order.category!.nickname!,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "创建时间",
                          ),
                          Text(
                            getTimeFromMilliseconds(order.createTime!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _handleDatePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: DatePicker(
              saveDateCallback: ({required int year, required int month}) {
                HiCache.getInstance().setInt("year", year);
                HiCache.getInstance().setInt("month", month);
                var monthStr = month >= 10 ? "$month" : "0$month";
                setState(() {
                  selectDate = "$year-$monthStr";
                });
                Navigator.of(context).pop();
              },
            ),
          );
        },
        isScrollControlled: true,
        backgroundColor: Colors.transparent);
  }

  Future<bool?> showDeleteConfirmDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("您确定要删除当前文件吗?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
              TextButton(
                child: const Text(
                  "删除",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  //关闭对话框并返回true
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
}
