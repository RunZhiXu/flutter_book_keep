import 'package:flutter/material.dart';

class AddBillPage extends StatefulWidget {
  const AddBillPage({Key? key}) : super(key: key);

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('添加账单'),
      ),
    );
  }
}
