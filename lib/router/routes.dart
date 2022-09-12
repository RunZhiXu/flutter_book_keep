import 'package:book_keeping_app/page/add_bill_page.dart';
import 'package:book_keeping_app/page/add_icon_page.dart';
import 'package:book_keeping_app/page/asset_page.dart';
import 'package:book_keeping_app/page/home_page.dart';
import 'package:book_keeping_app/router/bottom_navigator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 自定义路由状态
enum RouteStatus {
  home, // 主页
  asset, // 资产页
  addBill, // 添加账单
  addIcon, // 添加分类
  unknown,
}

typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo pre);

/// 创建页面
pageWrap(Widget child, {LocalKey? key}) {
  return MaterialPage(child: child, key: key ?? ValueKey(child.hashCode));
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    // 如果page是打开的路由状态
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 通过page获取路由状态
getStatus(MaterialPage page) {
  if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is AssetPage) {
    return RouteStatus.asset;
  } else if (page.child is AddBillPage) {
    return RouteStatus.addBill;
  } else if (page.child is AddIconPage) {
    return RouteStatus.addIcon;
  } else {
    return RouteStatus.unknown;
  }
}

/// 监听路由页面的跳转
/// 感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _routeJumpListener;
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;
  RouteStatusInfo? _bottomTab;
  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  // 首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  // 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJumpListener = routeJumpListener;
  }

  // 监听页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  // 移除监听
  void removeListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    // 创建当前打开的页面
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  // 通知页面更新
  void _notify(RouteStatusInfo current) {
    // 如果是首页且是 切换tab的操作
    if (current.page is BottomNavigator && _bottomTab != null) {
      // 如果打开的首页，则明确到首页的具体tab
      current = _bottomTab!;
    }
    if (kDebugMode) {
      print("hi_navigator:current :${current.page}");
      print("hi_navigator:pre :${_current?.page}");
    }

    for (var listener in _listeners) {
      listener(current, _current!);
    }
    _current = current;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJumpListener?.onJumpTo!(routeStatus, args: args);
  }
}

// 抽象类
abstract class _RouteJumpListener {
  // 跳转的页面和值
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

// 定义路由跳转逻辑
class RouteJumpListener {
  final OnJumpTo? onJumpTo;

  RouteJumpListener({this.onJumpTo});
}
