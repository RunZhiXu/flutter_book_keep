import 'package:book_keeping_app/model/icon_mo.dart';
import 'package:book_keeping_app/page/add_icon_page.dart';
import 'package:book_keeping_app/router/bottom_navigator.dart';
import 'package:book_keeping_app/router/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<MyRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRouterPath> {
  // 默认首页
  RouteStatus _routeStatus = RouteStatus.home;
  // 页面集合
  List<MaterialPage> pages = [];
  // 添加分类页面的icon
  IconMo? icon;
  int? iconType; // icon类型 0 支出 1收入

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, _routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 打开之前的页面都出栈
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      // 跳转到首页时将其他页面出栈，因为首页不可回退
      pages.clear();
      // 重新创建首页
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.addIcon) {
      page = pageWrap(AddIconPage(
        icon: icon,
        type: iconType!,
      ));
    }
    // 重新创建数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    // 通知路由变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
      //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          // if (route.settings is MaterialPage) {
          // 登录页未登录拦截
          // if ((route.settings as MaterialPage).child is LoginPage) {
          //   if (!hasLogin) {
          //     showWarnToast("请先登录");
          //     return false;
          //   }
          // }
          // }
          // 是否可以返回上一页
          if (!route.didPop(result)) {
            return false;
          }
          var tempPages = [...pages];
          pages.removeLast();
          // 打开上一页通知路由变化
          HiNavigator.getInstance().notify(pages, tempPages);
          return true;
        },
      ),
      onWillPop: () async {
        // 某些页面不能手势退出
        // if (routeStatus == RouteStatus.detail) return false;
        return !(await navigatorKey.currentState?.maybePop() ?? false);
      },
    );
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  // 为navigator设置key，必要时可以通过navigatorKey.currentState来获取NavigatorState对象
  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      // 传递参数
      if (routeStatus == RouteStatus.addIcon) {
        icon = args!['icon'];
        iconType = args['type'];
      }
      notifyListeners();
    }));
  }

  @override
  Future<void> setNewRoutePath(MyRouterPath configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  // 拦截路由状态
  RouteStatus get routeStatus {
    print('hasLogin === $hasLogin');
    // 不是注册页 并且没有登录
    // if (_routeStatus != RouteStatus.registration &&
    //     _routeStatus != RouteStatus.article &&
    //     _routeStatus != RouteStatus.resetPassword &&
    //     !hasLogin) {
    //   return _routeStatus = RouteStatus.login;
    // } else {
    return _routeStatus;
    // }
  }

  bool get hasLogin => true;
}

class MyRouterPath {
  final String location;
  MyRouterPath.home() : location = '/';
  MyRouterPath.detail() : location = '/detail';
}
