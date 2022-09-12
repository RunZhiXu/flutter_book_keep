import 'package:flutter/material.dart';

class AssetPage extends StatefulWidget {
  final String? title;
  const AssetPage({Key? key, this.title}) : super(key: key);

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  late int month;
  num budget = 5000.00; // 预算
  num expenses = 300.50; // 支出

  @override
  void initState() {
    var nowMonth = DateTime.now().month;
    setState(() {
      month = nowMonth;
    });
    print("百分比 ${((budget * 100 - expenses * 100) / budget * 100) / 100}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: _title(),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "总预算",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "总额$budget | 预算内支出$expenses",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation(Colors.blue),
                          value:
                              ((budget * 100 - expenses * 100) / budget * 100) /
                                  10000,
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "剩余",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 10),
                              ),
                              Text(
                                "${(budget * 100 - expenses * 100) / 100}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$month月预算',
          style: const TextStyle(fontSize: 16),
        ),
        const Icon(Icons.keyboard_arrow_down_outlined)
      ],
    );
  }
}
