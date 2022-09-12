import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../util/color.dart';
import '../util/format_util.dart';

class AppKeyboard extends StatefulWidget {
  final String? hint; // 提示文案
  final SaveBtnCallback? saveCallback; // 保存按钮的回调函数
  final VoidCallback? resetCallback; // 重置按钮的回调函数
  final int? selectIconId;

  const AppKeyboard(
      {Key? key,
      this.hint = '点击添加备注...',
      this.saveCallback,
      this.resetCallback,
      this.selectIconId})
      : super(key: key);

  @override
  State<AppKeyboard> createState() => _AppKeyboardState();
}

class _AppKeyboardState extends State<AppKeyboard> {
  String orderNum = '0.00';
  String? inputText;
  String? calculate;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottom = MediaQuery.of(context).padding.bottom; // 底部安全距离
    return Container(
      padding: EdgeInsets.only(bottom: bottom),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _input(),
              ),
              Container(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  orderNum,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                btn(
                    child: textChild('1'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('1');
                    }),
                btn(
                    child: textChild('2'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('2');
                    }),
                btn(
                    child: textChild('3'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('3');
                    }),
                btn(
                    child: iconChild(Icons.close_outlined),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('del');
                    }),
                btn(
                    child: textChild('4'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('4');
                    }),
                btn(
                    child: textChild('5'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('5');
                    }),
                btn(
                    child: textChild('6'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('6');
                    }),
                btn(
                    child: textChild('—'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('reduce');
                    }),
                btn(
                    child: textChild('7'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('7');
                    }),
                btn(
                    child: textChild('8'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('8');
                    }),
                btn(
                    child: textChild('9'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('9');
                    }),
                btn(
                    child: iconChild(Icons.add_outlined),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('add');
                    }),
                btn(
                    child: textChild('重置', fontSize: 16),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('reset');
                    }),
                btn(
                    child: textChild('0'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('0');
                    }),
                btn(
                    child: textChild('.'),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('.');
                    }),
                btn(
                    child:
                        textChild("保存", fontSize: 16, color: Colors.redAccent),
                    width: (width - 46) / 4,
                    height: 50,
                    callback: () {
                      handleBtn('save');
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  _input() {
    return TextField(
      controller: _textController,
      keyboardType: TextInputType.multiline,
      textAlign: TextAlign.left,
      onChanged: (val) {
        _inputOnChanged(val);
      },
      cursorColor: primary,
      minLines: 1,
      maxLines: 5,
      style: const TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        border: InputBorder.none,
        hintText: widget.hint,
        counterText: '',
        hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }

  void _inputOnChanged(String val) {
    setState(() {
      inputText = val;
    });
  }

  Widget btn(
      {required Widget child,
      VoidCallback? callback,
      required double width,
      required double height}) {
    return InkWell(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }

  // 文字按钮的child
  Widget textChild(String number,
      {Color? color, bool bold = true, double? fontSize}) {
    return Text(
      number,
      style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize ?? 18,
          color: color),
    );
  }

  // 图标按钮的child
  Widget iconChild(IconData iconData) {
    return Icon(
      iconData,
      size: 24,
    );
  }

  // 键盘按钮事件
  void handleBtn(String text) {
    print("text :$text");
    // 规则 不能为负数 不能超过8位数
    switch (text) {
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        if (orderNum == '0.00' || orderNum == '0') {
          setState(() {
            orderNum = text;
          });
          return;
        }
        // 只能两位小数点
        bool isCalculate = stringIsAddOrReduce(orderNum); // 判断是否为计算表达式
        if (!isCalculate) {
          var argStr = orderNum.split('.');
          if (argStr.length > 1 && argStr[1].length >= 2) {
            // 存在小数点且超过2位
            return;
          }
        } else {
          var calculateStr = calculate == 'reduce' ? '-' : '+';
          var arg = orderNum.split(calculateStr);
          if (arg.length > 1 && arg[1].isNotEmpty) {
            var argStr = arg[1].split('.');
            var newNum = stringToNum(arg[1]);

            if (argStr.length > 1 && argStr[1].length >= 2 && newNum > 0) {
              // 存在小数点且超过2位
              return;
            }
          }
        }
        setState(() {
          orderNum = orderNum + text;
        });
        break;
      case '0':
        if (orderNum == '0' || orderNum == '0.00') {
          setState(() {
            orderNum = '0';
          });
          return;
        }
        bool isCalculate = stringIsAddOrReduce(orderNum); // 判断是否为计算表达式
        if (isCalculate) {
          var calculateStr = calculate == 'reduce' ? '-' : '+';
          var arg = orderNum.split(calculateStr);
          if (arg.length > 1) {
            var arg2 = arg[1].split('.');
            if (arg2.length > 1 && arg2[1].length >= 2) {
              // 超过2位不能够添加
              return;
            }
          }
        } else {
          var arg = orderNum.split('.');
          if (arg.length > 1 && arg[1].length >= 2) {
            // 超过2位不能够添加
            return;
          }
        }
        setState(() {
          orderNum = orderNum + text;
        });
        break;
      case '.':
        var lastString = orderNum[orderNum.length - 1];
        var argStr = orderNum.split('.');
        bool isCalculate =
            stringIsAddOrReduce(orderNum); // 判断是否为计算表达式 如果是 xx-xx最后一位可以为0
        if (argStr.length > 1 && !isCalculate) {
          return;
        }
        if (lastString != '.') {
          setState(() {
            orderNum = orderNum + '.';
          });
        }
        break;
      case 'reset':
        if (widget.resetCallback != null) {
          widget.resetCallback!();
        }
        _textController.text = '';
        setState(() {
          orderNum = '0.00';
        });
        break;
      case 'del':
        // var newNum = num.parse(double.parse(orderNum).toStringAsFixed(2));
        if (orderNum != '0') {
          var newStr = orderNum.substring(0, orderNum.length - 1);
          var lastString = orderNum.substring(orderNum.length - 1);
          if (lastString == '-' || lastString == '+') {
            setState(() {
              calculate = null;
            });
          }
          setState(() {
            orderNum = newStr;
          });
        }
        break;
      case 'reduce':
        var arg = orderNum.split('-');
        if (arg.length > 1 && arg[1].isNotEmpty) {
          // 需要计算
          var resNum = stringToNum(arg[0]) * 100 - stringToNum(arg[1]) * 100;
          setState(() {
            calculate = 'reduce'; // 当前做减法
            orderNum = resNum > 0 ? '${resNum / 100}-' : '0';
          });
        } else {
          var newNum = stringToNum(orderNum);
          if (newNum > 0) {
            setState(() {
              orderNum = orderNum + '-';
              calculate = 'reduce'; // 当前做减法
            });
          }
        }
        break;
      case 'add':
        var arg = orderNum.split('+');
        if (arg.length > 1 && arg[1].isNotEmpty) {
          // 需要计算
          var resNum = stringToNum(arg[0]) * 100 + stringToNum(arg[1]) * 100;
          setState(() {
            calculate = 'add'; // 当前做加法
            orderNum = '${resNum / 100}+';
          });
        } else {
          var newNum = stringToNum(orderNum);
          if (newNum > 0) {
            setState(() {
              orderNum = orderNum + '+';
              calculate = 'add'; // 当前做减法
            });
          }
        }
        break;
      case 'save':
        if (widget.selectIconId == null) {
          EasyLoading.showError('你需要选择一个分类');
          return;
        }
        bool isCalculate = stringIsAddOrReduce(orderNum);
        num numString = 0;
        if (widget.saveCallback != null) {
          if (isCalculate) {
            var calculateStr = calculate == 'reduce' ? '-' : '+';
            var arg = orderNum.split(calculateStr);
            if (arg.length > 1) {
              // 计算得到最终的结果
              if (arg[1].isNotEmpty) {
                numString = calculate == 'reduce'
                    ? (stringToNum(arg[0]) * 100 - stringToNum(arg[1]) * 100) /
                        100
                    : (stringToNum(arg[0]) * 100 + stringToNum(arg[1]) * 100) /
                        100;
              } else {
                numString = stringToNum(arg[0]);
              }
            }
          } else {
            numString = stringToNum(orderNum);
            if (numString <= 0) {
              EasyLoading.showToast('请填写金额');
              return;
            }
          }

          // 整理格式为 xx.xx
          var str = '$numString';
          var strArg = str.split('.');
          if (strArg.length > 1) {
            for (var i = 0; i < 2 - strArg[1].length; i++) {
              strArg[1] = strArg[1] + '0';
            }
            str = strArg[0] + '.' + strArg[1];
          } else {
            str = strArg[0] + '.00';
          }
          print('str $str');
          widget.saveCallback!(widget.selectIconId!, str,
              description: inputText);
        }
        break;
    }
  }
}

/// 保存按钮的回调方法
/// [iconId] 图标icon id
/// [numString] 计算的字符串 可以是计算表达式 或者 数字字符串
typedef SaveBtnCallback = Function(int iconId, String numString,
    {String? description});
