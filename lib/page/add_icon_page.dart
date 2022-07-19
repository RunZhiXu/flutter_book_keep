import 'package:book_keeping_app/db/provider/icon_category_db_provider.dart';
import 'package:book_keeping_app/model/icon_category_mo.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:book_keeping_app/util/view_util.dart';
import 'package:flutter/material.dart';

import '../db/provider/icon_db_provider.dart';

class AddIconPage extends StatefulWidget {
  final String? title;

  const AddIconPage({Key? key, this.title}) : super(key: key);

  @override
  State<AddIconPage> createState() => _AddIconPageState();
}

class _AddIconPageState extends State<AddIconPage> {
  List<IconCategoryMo> iconCategoryList = [];
  bool switchBtn = false;

  @override
  void initState() {
    super.initState();
    _getIconList();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.title == null ? '添加分类' : widget.title!,
          style: const TextStyle(fontSize: 16),
        ),
        elevation: 0.5,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.save_outlined),
            ),
            onTap: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Column(
          children: [
            Container(
              width: width - 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: getConfigBorderRadius(),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 12,
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '填写信息',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 12, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '分类名称',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Container(),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black12),
                ),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '分类图标',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '图标可从下面的列表中选择',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('多选'),
                          Switch(
                            activeColor: primary,
                            value: switchBtn,
                            onChanged: (val) {
                              setState(() {
                                switchBtn = val;
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 78,
                    color: Colors.white,
                    child: ListView(
                      children: _categoryList(),
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

  void _getIconList() async {
    IconCategoryDbProvider iconCategoryDbProvider = IconCategoryDbProvider();
    await iconCategoryDbProvider.open();
    var list = await iconCategoryDbProvider.getList();
    if (list != null) {
      List<IconCategoryMo> iconCategoryListMo = [];
      for (var i = 0; i < list.length; i++) {
        iconCategoryListMo.add(IconCategoryMo.fromJson(list[i]));
      }
      setState(() {
        iconCategoryList = iconCategoryListMo;
      });
    }
    await iconCategoryDbProvider.close();

    var iconList = [];
    var time = DateTime.now().microsecondsSinceEpoch;
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        iconList.add({
          "icon_category_id": list[i]['id']!,
          "name": "icon_gift",
          "create_time": time,
          'update_time': time,
        });
      }
    }
    IconDbProvider iconDbProvider = IconDbProvider();
    await iconDbProvider.open();
    for (var i = 0; i < iconList.length; i++) {
      iconDbProvider.insert(iconList[i]);
    }
    var list3 = await iconDbProvider.getList();
    print('list3 length: ${list3!.length}');
    await iconDbProvider.close();
  }

  // icon分类滚动列表
  List<Widget> _categoryList() {
    if (iconCategoryList.isEmpty) {
      return [const SizedBox()];
    }
    return iconCategoryList.map(
      (category) {
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black12),
                  right: BorderSide(width: 0.5, color: Colors.black12),
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Text(category.name!),
            ),
            // const Divider(
            //   height: 1,
            // ),
          ],
        );
      },
    ).toList();
  }
}
