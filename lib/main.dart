import 'package:book_keeping_app/db/hi_cache.dart';
import 'package:book_keeping_app/router/my_router_delegate.dart';
import 'package:book_keeping_app/util/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MyRouterDelegate _routerDelegate = MyRouterDelegate();

  var _futureBuilder;

  @override
  void initState() {
    super.initState();
    _futureBuilder = preInit();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilder,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 定义route
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(routerDelegate: _routerDelegate)
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white),
        );
      },
    );
  }

  Future preInit() async {
    return Future.wait([HiCache.preInit()]);
  }
}
