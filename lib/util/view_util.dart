import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

///修改状态栏
void changeStatusBar(
    {color: Colors.transparent,
    StatusStyle statusStyle: StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
  //沉浸式状态栏样式
  Brightness brightness;
  if (kDebugMode) {
    print("修改状态栏");
  }
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.dark
        : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.light
        : Brightness.dark;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: color,
    statusBarBrightness: brightness,
    statusBarIconBrightness: brightness,
  ));
}

// 带缓存的image
Widget cacheImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (
      BuildContext context,
      String url,
    ) =>
        Container(color: Colors.grey[200]),
    errorWidget: (
      BuildContext context,
      String url,
      dynamic error,
    ) =>
        const Icon(Icons.error),
  );
}

BorderRadiusGeometry getConfigBorderRadius() {
  return const BorderRadius.all(
    Radius.circular(12),
  );
}
