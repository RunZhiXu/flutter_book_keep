import 'package:book_keeping_app/db/hi_cache.dart';
import 'package:book_keeping_app/db/provider/order_db_provider.dart';
import 'package:book_keeping_app/util/view_util.dart';
import 'package:book_keeping_app/widget/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final imgUrl = 'https://api.lamwityee.com/static/images/avatar.jpeg';
  String selectDate = '2020-07'; // 选择的年月份
  double income = 2000.01; // 收入
  double expenditure = 0.01; // 支出
  void Function() get _popDrawer => () => Navigator.pop(context);
  int? year; // 年份
  int? month; // 月份

  @override
  void initState() {
    super.initState();
    var cacheYear = HiCache.getInstance().get('year');
    var cacheMonth = HiCache.getInstance().get('month');
    var date = DateTime.now();
    setState(() {
      year = cacheYear ?? date.year;
      month = cacheMonth ?? date.month;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('点击日历视图');
                }
              },
              child: const Icon(Icons.calendar_month_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print('点击图表');
                }
              },
              child: const Icon(Icons.assessment_outlined),
            ),
          ),
        ],
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
        if (kDebugMode) {
          print('点击日期');
        }
      },
      child: Text(
        selectDate,
        style: TextStyle(color: Colors.grey[600]),
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
                      (income - expenditure).toStringAsFixed(2),
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
                    '月收入: ${income.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Text(
                  '月支出: ${expenditure.toStringAsFixed(2)}',
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
                backgroundImage: NetworkImage(
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
    const data = [
      {'category': '周一', 'sales': 5},
      {'category': '周二', 'sales': 20},
      {'category': '周三', 'sales': 36},
      {'category': '周四', 'sales': 10},
      {'category': '周五', 'sales': 10},
      {'category': '周六', 'sales': 20},
      {'category': '周日', 'sales': 300},
    ];

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
                  '最近7日汇总',
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
              data: data,
              variables: {
                'category': Variable(
                  accessor: (Map map) => map['category'] as String,
                ),
                'sales': Variable(
                  accessor: (Map map) => map['sales'] as num,
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
            )),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    const order = <String, dynamic>{
      'time': 12000000,
      'count': 100.00,
      'list': [
        {
          'id': 0,
          'type': 'expenditure', // expenditure 支出 income 收入
          'count': 33.33,
          'category_id': 1,
          'refund_id': 1,
          'refund': {
            'id': 0,
            'fund': 22.22,
            'create_time': 100000,
            'account_id': 1,
          },
          'create_time': 10000000,
          'update_time': 10000000,
        },
      ]
    };
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('07.07'),
                    Text('支出:55.00'),
                  ],
                ),
              ),
            ],
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
    print('lastDay $lastDay');
    print('firstDay $firstDay');
    var res = await orderDbProvider.getOrderListByTime(
        startTime: firstDay, endTime: lastDay);
    print("res === $res");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
