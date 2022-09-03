import 'package:flutter/widgets.dart';

class IconFont {
  static Map<String, IconData> iconList = {
    "icon_auto": icon_auto,
    'icon_bussiness_man': icon_bussiness_man,
    'icon_component': icon_component,
    'icon_dollar': icon_dollar,
    'icon_gift': icon_gift,
    'icon_integral': icon_integral,
    'icon_pic': icon_pic,
    'icon_play': icon_play,
    'icon_favorites_fill': icon_favorites_fill,
    'icon_agriculture': icon_agriculture,
    'icon_add_cart': icon_add_cart,
    'icon_apparel': icon_apparel,
    'icon_beauty': icon_beauty,
    'icon_color': icon_color,
    'icon_cut': icon_cut,
    'icon_jewelry': icon_jewelry,
    'icon_shoes': icon_shoes
  };

  static getIcon({required String name}) {
    return iconList[name];
  }

  static const String _family = 'iconfont';

  IconFont._();

  static const IconData icon_auto = IconData(0xe6eb, fontFamily: _family);
  static const IconData icon_bussiness_man =
      IconData(0xe6ef, fontFamily: _family);
  static const IconData icon_component = IconData(0xe6f2, fontFamily: _family);
  static const IconData icon_dollar = IconData(0xe6f4, fontFamily: _family);
  static const IconData icon_gift = IconData(0xe6f9, fontFamily: _family);
  static const IconData icon_integral = IconData(0xe6fa, fontFamily: _family);
  static const IconData icon_pic = IconData(0xe6ff, fontFamily: _family);
  static const IconData icon_play = IconData(0xe701, fontFamily: _family);
  static const IconData icon_favorites_fill =
      IconData(0xe721, fontFamily: _family);
  static const IconData icon_agriculture =
      IconData(0xe742, fontFamily: _family);
  static const IconData icon_add_cart = IconData(0xe743, fontFamily: _family);
  static const IconData icon_apparel = IconData(0xe744, fontFamily: _family);
  static const IconData icon_beauty = IconData(0xe745, fontFamily: _family);
  static const IconData icon_color = IconData(0xe748, fontFamily: _family);
  static const IconData icon_cut = IconData(0xe74b, fontFamily: _family);
  static const IconData icon_jewelry = IconData(0xe754, fontFamily: _family);
  static const IconData icon_shoes = IconData(0xe76c, fontFamily: _family);
}
