import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../util/color.dart';

class IconInput extends StatefulWidget {
  final String hint; // 提示文案
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged; // 获取光标
  final bool lineStretch; // 横线是否占满
  final bool obscureText; // 密码输入
  final TextInputType? keyboardType; // 输入框接受的类型输入
  final int? maxLength;

  const IconInput(
      {Key? key,
      required this.hint,
      this.onChanged,
      this.focusChanged,
      required this.lineStretch,
      required this.obscureText,
      this.keyboardType,
      this.maxLength})
      : super(key: key);

  @override
  State<IconInput> createState() => _IconInputState();
}

class _IconInputState extends State<IconInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 是否获取到光标
    _focusNode.addListener(() {
      if (kDebugMode) {
        print('Has focus ${_focusNode.hasFocus}');
      }
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _input(),
      alignment: Alignment.centerRight,
    );
  }

  _input() {
    return TextField(
      textAlign: TextAlign.right,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      cursorColor: primary,
      maxLength: widget.maxLength,
      style: const TextStyle(
          fontSize: 16, color: primary, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        border: InputBorder.none,
        hintText: widget.hint,
        counterText: '',
        hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }
}
