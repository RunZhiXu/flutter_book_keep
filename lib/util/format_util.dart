//数字转万
String countFormat(int count, {fixed = 2}) {
  String views = "";
  if (count > 9999) {
    views = '${(count / 10000).toStringAsFixed(fixed)}万';
  } else {
    views = count.toString();
  }
  return views;
}

/// 字符串转浮点数
num stringToNum(String text, {fixed = 2}) {
  return num.parse(double.parse(text).toStringAsFixed(fixed));
}

/// 字符串是加法或者减法的表达式
bool stringIsAddOrReduce(String text) {
  RegExp regExp = RegExp("\\+|\\-");
  return regExp.hasMatch(text);
}

//时间转换成分钟秒
String durationTransform(int seconds) {
  int m = (seconds ~/ 60);
  int s = (seconds % 60);
  if (s < 10) {
    return '$m:0$s';
  }
  return '$m:$s';
}

List<List<T>> splitList<T>(List<T> list, int len) {
  if (len <= 1) {
    return [list];
  }

  List<List<T>> result = <List<T>>[];
  int index = 1;

  while (true) {
    if (index * len < list.length) {
      List<T> temp = list.skip((index - 1) * len).take(len).toList();
      result.add(temp);
      index++;
      continue;
    }
    List<T> temp = list.skip((index - 1) * len).toList();
    result.add(temp);
    break;
  }
  return result;
}
