import 'package:flutter/material.dart';

class AssetPage extends StatefulWidget {
  final String? title;
  const AssetPage({Key? key, this.title}) : super(key: key);

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text('添加分类'),
      ),
      body: Center(
        child: Text('资产'),
      ),
    );
  }
}
