import 'package:flutter/widgets.dart';

class IconFont {
  static getIcon({required String name}) {
    Map<String, IconData> iconList = {
      "icon_auto": icon_auto,
      "icon_all": icon_all,
      "icon_bussiness_man": icon_bussiness_man,
      "icon_component": icon_component,
      "icon_copy": icon_copy,
      "icon_dollar": icon_dollar,
      "icon_editor": icon_editor,
      "icon_gift": icon_gift,
      "icon_integral": icon_integral,
      "icon_pic": icon_pic,
      "icon_play": icon_play,
      "icon_similar_product": icon_similar_product,
      "icon_Exportservices": icon_Exportservices,
      "icon_favorites_fill": icon_favorites_fill,
      "icon_add_cart": icon_add_cart,
      "icon_apparel": icon_apparel,
      "icon_atm": icon_atm,
      "icon_ali_clould": icon_ali_clould,
      "icon_customization": icon_customization,
      "icon_jewelry": icon_jewelry
    };

    return iconList[name];
  }

  static const String _family = 'iconfont';
  IconFont._();
  static const IconData icon_auto = IconData(0xe6eb, fontFamily: _family);
  static const IconData icon_all = IconData(0xe6ef, fontFamily: _family);
  static const IconData icon_bussiness_man =
      IconData(0xe6f0, fontFamily: _family);
  static const IconData icon_component = IconData(0xe6f2, fontFamily: _family);
  static const IconData icon_copy = IconData(0xe6f3, fontFamily: _family);
  static const IconData icon_dollar = IconData(0xe6f4, fontFamily: _family);
  static const IconData icon_editor = IconData(0xe6f6, fontFamily: _family);
  static const IconData icon_gift = IconData(0xe6f9, fontFamily: _family);
  static const IconData icon_integral = IconData(0xe6fa, fontFamily: _family);
  static const IconData icon_pic = IconData(0xe6ff, fontFamily: _family);
  static const IconData icon_play = IconData(0xe701, fontFamily: _family);
  static const IconData icon_similar_product =
      IconData(0xe707, fontFamily: _family);
  static const IconData icon_Exportservices =
      IconData(0xe702, fontFamily: _family);
  static const IconData icon_favorites_fill =
      IconData(0xe721, fontFamily: _family);
  static const IconData icon_add_cart = IconData(0xe742, fontFamily: _family);
  static const IconData icon_apparel = IconData(0xe743, fontFamily: _family);
  static const IconData icon_atm = IconData(0xe744, fontFamily: _family);
  static const IconData icon_ali_clould = IconData(0xe745, fontFamily: _family);
  static const IconData icon_customization =
      IconData(0xe74b, fontFamily: _family);
  static const IconData icon_jewelry = IconData(0xe754, fontFamily: _family);
}
