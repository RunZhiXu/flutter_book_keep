import 'package:book_keeping_app/db/provider/icon_category_db_provider.dart';
import 'package:book_keeping_app/db/provider/order_icon_db_provider.dart';
import 'package:book_keeping_app/model/icon_category_mo.dart';
import 'package:book_keeping_app/model/icon_mo.dart';
import 'package:book_keeping_app/model/order_icon_mo.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:book_keeping_app/util/view_util.dart';
import 'package:book_keeping_app/widget/icon_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../db/provider/icon_db_provider.dart';
import '../widget/iconfont.dart';

class AddIconPage extends StatefulWidget {
  final IconMo? icon;
  final int type;

  const AddIconPage({Key? key, this.icon, required this.type})
      : super(key: key);

  @override
  State<AddIconPage> createState() => _AddIconPageState();
}

class _AddIconPageState extends State<AddIconPage> {
  List<IconCategoryMo> iconCategoryList = [];
  List<IconMo> iconList = [];
  bool switchBtn = false;
  int? selectCategoryId; // 点击的分类id
  List<int> selectIconId = []; // 选择的icon id
  List<IconMo> selectIconList = []; // 选择的icon
  String? iconName; // 单选时的icon name
  String? inputText; // icon的nickname

  @override
  void initState() {
    super.initState();
    _getIconCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.icon == null ? '添加分类' : '添加二级分类',
          style: const TextStyle(fontSize: 16),
        ),
        elevation: 0.5,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.save_outlined),
            ),
            onTap: () {
              _save();
            },
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
              child: switchBtn
                  ? const SizedBox()
                  : Column(
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
                        parentIcon(),
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
                                  SizedBox(
                                    width: 150,
                                    child: IconInput(
                                      text: inputText,
                                      hint: '请输入分类名称',
                                      lineStretch: false,
                                      obscureText: false,
                                      maxLength: 4,
                                      onChanged: (text) {
                                        setState(() {
                                          inputText = text;
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.black12),
                                    child: iconName == null
                                        ? const SizedBox()
                                        : Container(
                                            width: 40,
                                            height: 40,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Icon(
                                              IconFont.getIcon(name: iconName!),
                                              color:
                                                  _iconColor(selectIconId[0]),
                                            ),
                                          ),
                                  )
                                ],
                              ),
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
                                if (val == false && selectIconId.isNotEmpty) {
                                  selectIconId = [];
                                  selectIconList = [];
                                }
                                switchBtn = val;
                                iconName = null;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 78,
                    color: Colors.white,
                    child: ListView(
                      children: _categoryList(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _iconListWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 获取icon 分类列表
  void _getIconCategoryList() async {
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
        selectCategoryId = list[0]['id'] as int;
      });
      var categoryId = list[0]['id'] as int;
      await getIconListByCategory(categoryId);
    }
    await iconCategoryDbProvider.close();

    // var iconList = [];
    // var time = DateTime.now().microsecondsSinceEpoch;
    // if (list != null) {
    //   for (var i = 0; i < list.length; i++) {
    //     iconList.add({
    //       "icon_category_id": list[i]['id']!,
    //       "name": "icon_gift",
    //       "nickname": "测试",
    //       "create_time": time,
    //       'update_time': time,
    //     });
    //   }
    // }
    // IconDbProvider iconDbProvider = IconDbProvider();
    // await iconDbProvider.open();
    // for (var i = 0; i < iconList.length; i++) {
    //   iconDbProvider.insert(iconList[i]);
    // }
    // var list3 = await iconDbProvider.getList();
    // if (kDebugMode) {
    //   print('list3 length: ${list3!.length}');
    // }
    // await iconDbProvider.close();
  }

  // 获取icon列表
  getIconListByCategory(int categoryId) async {
    IconDbProvider iconDbProvider = IconDbProvider();
    await iconDbProvider.open();
    var list = await iconDbProvider.getListByCategoryId(categoryId);
    if (kDebugMode) {
      print('icon list = $list');
    }
    if (list != null) {
      List<IconMo> iconMoList = [];
      for (var i = 0; i < list.length; i++) {
        iconMoList.add(IconMo.fromJson(list[i]));
      }
      setState(() {
        iconList = iconMoList;
      });
    }
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
            GestureDetector(
              onTap: () {
                _clickCategory(category.id!);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: const Border(
                    bottom: BorderSide(width: 0.5, color: Colors.black12),
                    right: BorderSide(width: 0.5, color: Colors.black12),
                  ),
                  color: category.id == selectCategoryId ? Colors.blue : null,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(category.name!),
              ),
            ),
          ],
        );
      },
    ).toList();
  }

  Widget _iconListWidget() {
    double width = MediaQuery.of(context).size.width;
    if (iconList.isEmpty) {
      return const SizedBox();
    }
    return GridView(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: (width - 78 - 24) / 4,
        mainAxisExtent: (width - 78 - 24) / 4 + 12,
      ),
      padding: const EdgeInsets.only(top: 0, bottom: 12),
      children: iconList.map((icon) {
        return SizedBox(
          width: (width - 78 - 24) / 4,
          child: GestureDetector(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _iconBgColor(icon.id!),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Icon(
                      IconFont.getIcon(name: icon.name!),
                      color: _iconColor(icon.id!),
                    ),
                  ),
                ),
                Text(icon.nickName!)
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

  // 点击分类
  _clickCategory(int categoryId) async {
    await getIconListByCategory(categoryId);
    setState(() {
      selectCategoryId = categoryId;
    });
  }

  Color _iconColor(int id) {
    var inList = selectIconId.contains(id);
    if (inList) {
      return Colors.white;
    }
    return Colors.black45;
  }

  // 点击icon
  void _clickIcon(IconMo icon) {
    var check = selectIconId.contains(icon.id!);
    // icon 未点击过
    if (!check) {
      var list = selectIconId;
      var iconList = selectIconList;
      if (switchBtn) {
        list.add(icon.id!);
        iconList.add(icon);
      } else {
        list = [icon.id!];
        iconList = [icon];
        setState(() {
          iconName = icon.name!;
        });
      }
      setState(() {
        selectIconId = list;
        selectIconList = iconList;
      });
    } else {
      var index = selectIconId.indexOf(icon.id!);
      var list = selectIconId;
      var iconList = selectIconList;
      if (switchBtn) {
        list.removeAt(index);
        iconList.removeAt(index);
      }
      setState(() {
        selectIconId = list;
        selectIconList = iconList;
      });
    }
  }

  // icon背景色
  Color _iconBgColor(int id) {
    var check = selectIconId.contains(id);
    return check ? primary : Colors.black12;
  }

  // 保存
  void _save() async {
    if (selectIconList.isNotEmpty) {
      OrderIconDbProvider orderIconDbProvider = OrderIconDbProvider();
      await orderIconDbProvider.open();
      var res = await orderIconDbProvider
          .tableIsEmpty(orderIconDbProvider.tableName());
      if (res) {
        await orderIconDbProvider.createTable();
      }
      for (var i = 0; i < selectIconList.length; i++) {
        var iconJson = selectIconList[i].toJson();
        var time = DateTime.now().microsecondsSinceEpoch;
        iconJson['id'] = null;
        iconJson['parent_id'] = widget.icon != null ? widget.icon!.id : null;
        iconJson['icon_id'] = selectIconList[i].id;
        iconJson['create_time'] = time;
        iconJson['update_time'] = time;
        iconJson['type'] = widget.type;
        if (inputText != null) {
          iconJson['nickname'] = inputText;
        }
        OrderIconMo orderIcon = OrderIconMo.fromJson(iconJson);
        await orderIconDbProvider.insert(orderIcon.toJson());
        Navigator.of(context).pop();
      }
      await orderIconDbProvider.close();
    }
  }

  // 父级icon
  Widget parentIcon() {
    if (widget.icon == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '一级分类',
            style: TextStyle(fontSize: 16),
          ),
          Text(widget.icon!.nickName!),
        ],
      ),
    );
  }
}
