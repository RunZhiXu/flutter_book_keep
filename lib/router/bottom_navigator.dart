import 'package:book_keeping_app/page/asset_page.dart';
import 'package:book_keeping_app/page/home_page.dart';
import 'package:book_keeping_app/router/routes.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  late List<Widget> _pages;
  bool _hasBuild = false;
  static int initialPage = 0;

  @override
  Widget build(BuildContext context) {
    _pages = [
      const HomePage(),
      const AssetPage(),
    ];
    if (!_hasBuild) {
      // 页面第一次打开时，打开的时哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => _onJumpTo(index),
      selectedItemColor: _activeColor,
      items: [
        _bottomItem('null', Icons.home, 0),
        _bottomItem('资产', Icons.assessment, 1),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }

  BottomAppBar _bottomAppBar() {
    return BottomAppBar(
      color: Colors.redAccent,
      shape: CircularNotchedRectangle(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Column(
                children: const [
                  Icon(Icons.home),
                  Text('首页'),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.add)],
            ),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: const [
                  Icon(Icons.assessment),
                  Text('资产'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      label: title,
    );
  }

  void _onJumpTo(int index, {bool pageChange = false}) {
    if (!pageChange) {
      // 让pageView展示对应tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
