import 'package:book_keeping_app/router/routes.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
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
      ),
    );
  }
}
