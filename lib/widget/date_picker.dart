import 'package:flutter/material.dart';

import '../db/hi_cache.dart';

class DatePicker extends StatefulWidget {
  final SaveDateCallback saveDateCallback;
  const DatePicker({Key? key, required this.saveDateCallback})
      : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<int> yearList = [];
  List<int> monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  late int selectYear;
  late int selectMonth;

  @override
  void initState() {
    super.initState();
    _getYearList();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 350,
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: ListView(
                  children: _yearWidgetList(),
                ),
              ),
              Container(
                color: Colors.black12,
                width: 1,
                height: 350,
              ),
              Expanded(
                child: Wrap(
                  children: monthList.map((month) {
                    return InkWell(
                      onTap: () {
                        widget.saveDateCallback(year: selectYear, month: month);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            left: 12, right: 12, bottom: 15, top: 15),
                        width: (width - 126) / 2,
                        child: Text(
                          "$month月",
                          style: TextStyle(
                            color: month == selectMonth
                                ? Colors.blueAccent
                                : Colors.black,
                            fontWeight:
                                month == selectMonth ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _getYearList() {
    var date = DateTime.now();
    var year = date.year + 2;
    List<int> list = [];
    for (var i = 1; i <= 20; i++) {
      var y = year - i;
      list.add(y);
    }

    var cacheYear = HiCache.getInstance().get('year') ?? date.year;
    var cacheMonth = HiCache.getInstance().get('month') ?? date.month;
    setState(() {
      yearList = list;
      selectYear = cacheYear;
      selectMonth = cacheMonth;
    });
  }

  List<Widget> _yearWidgetList() {
    if (yearList.isEmpty) {
      return [const SizedBox()];
    }
    return yearList.map((year) {
      return InkWell(
        onTap: () {
          setState(() {
            selectYear = year;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Text(
            "$year年",
            style: TextStyle(
              color: year == selectYear ? Colors.blueAccent : Colors.black,
              fontWeight: year == selectYear ? FontWeight.bold : null,
            ),
          ),
        ),
      );
    }).toList();
  }
}

typedef SaveDateCallback = Function({required int year, required int month});
