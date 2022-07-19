import 'package:flutter/material.dart';

class ColorPoint extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  const ColorPoint({Key? key, this.color, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color ?? Colors.black54),
      width: width ?? 2.00,
      height: height ?? 2.00,
    );
  }
}
