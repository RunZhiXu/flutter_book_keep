import 'package:book_keeping_app/db/provider/order_db_provider.dart';
import 'package:book_keeping_app/db/provider/order_icon_db_provider.dart';
import 'package:book_keeping_app/model/order_icon_mo.dart';
import 'package:book_keeping_app/router/routes.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:book_keeping_app/widget/app_keyboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/iconfont.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({Key? key}) : super(key: key);

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage>
    with SingleTickerProviderStateMixin {
  final List tabs = [
    {
      "name": "支出",
      "type": 0,
    },
    {
      "name": "收入",
      "type": 1,
    },
  ];
  late TabController _tabController;
  int? selectIconId;
  List<OrderIconMo> orderIconList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _getIconList(0); // 获取支出icon list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBar(),
        elevation: 0.5,
        actions: [
          GestureDetector(
            onTap: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.addIcon);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _iconList(),
          ),
          AppKeyboard(
            resetCallback: resetBtn,
            saveCallback: (int iconId, String numString,
                {String? description}) {
              saveBtnCallback(
                  iconId: iconId,
                  numString: numString,
                  description: description);
            },
            selectIconId: selectIconId,
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: TabBar(
        controller: _tabController,
        tabs: tabs.map((e) => Tab(text: e["name"])).toList(),
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        onTap: (index) {
          _getIconList(index);
        },
      ),
    );
  }

  void resetBtn() {
    setState(() {
      selectIconId = 0;
    });
  }

  // 获取支出的icon列表
  void _getIconList(int type) async {
    OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
    await orderIconDbProvider.open();
    var res = await orderIconDbProvider.getListByType(type, null);
    if (kDebugMode) {
      print("list: res $res");
    }
    setState(() {
      if (res != null) {
        orderIconList = [];
        for (var item in res) {
          orderIconList.add(OrderIconMo.fromJson(item));
        }
      }
    });
  }

  saveBtnCallback(
      {required int iconId,
      required String numString,
      String? description}) async {
    OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
    await orderIconDbProvider.open();
    var res = await orderIconDbProvider.getOne(iconId, null);
    await orderIconDbProvider.close();
    var orderIcon = OrderIconMo.fromJson(res!);
    OrderDbProvider orderDbProvider = OrderDbProvider();
    await orderDbProvider.open();
    var time = DateTime.now().millisecondsSinceEpoch;
    // 转化numString为double
    await orderDbProvider.insert({
      "type": orderIcon.type,
      "count": numString,
      "category_id": orderIcon.id,
      "parent_id": null, // 不是退款没有上级订单id
      "description": description,
      "create_time": time,
      "update_time": time
    });
    await orderDbProvider.close();
    HiNavigator.getInstance().onJumpTo(RouteStatus.home);
  }

  // icon列表
  _iconList() {
    var width = MediaQuery.of(context).size.width;
    width = (width - 24) / 5;
    if (orderIconList.isEmpty) {
      return const SizedBox();
    }
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: width,
        mainAxisExtent: width + 12,
      ),
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
      children: orderIconList.map((icon) {
        return SizedBox(
          width: width,
          child: GestureDetector(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    width: width - 30,
                    height: width - 30,
                    decoration: BoxDecoration(
                      color: _iconBgColor(icon.id!),
                      borderRadius:
                          BorderRadius.all(Radius.circular(width - 30)),
                    ),
                    child: Icon(
                      IconFont.getIcon(name: icon.name!),
                      color: _iconColor(icon.id!),
                    ),
                  ),
                ),
                Text(icon.nickname!)
              ],
            ),
            onTap: () {
              _clickIcon(icon);
            },
          ),
        );
      }).toList(),
    );
  }

  // icon背景色
  Color _iconBgColor(int id) {
    var check = selectIconId == id;
    return check ? primary : Colors.black12;
  }

  Color _iconColor(int id) {
    var inList = selectIconId == id;
    if (inList) {
      return Colors.white;
    }
    return Colors.black45;
  }

  void _clickIcon(OrderIconMo icon) {
    setState(() {
      selectIconId = icon.id;
    });
  }
}
