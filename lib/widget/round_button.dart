import 'package:flutter/material.dart';

/// 圆角按钮
/// [color] 按钮背景色
/// [padding] 按钮内边距
/// [child] child
/// [callback] 回调函数
class RoundButton extends StatefulWidget {
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final VoidCallback? callback;
  const RoundButton(
      {Key? key, this.color, this.padding, required this.child, this.callback})
      : super(key: key);

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback ?? widget.callback!();
      },
      child: Container(
        padding: widget.padding ?? const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(999),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
