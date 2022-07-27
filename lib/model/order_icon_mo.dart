/// 选择的icon
/// [id] 主键id
/// [name] 图标name 通过 IconFont.getIcon获取对应的图标data 如 test
/// [nickname] 图标名 如测试
/// [parentId] 上一级的图标id
/// [iconId] icon表里的icon id
/// [type] 0 支付 1 收入
class OrderIconMo {
  int? id;
  String? name;
  String? nickname;
  int? parentId;
  int? iconId;
  int? type;
  int? createTime;
  int? updateTime;

  OrderIconMo({
    this.id,
    this.name,
    this.nickname,
    this.parentId,
    this.iconId,
    this.type,
    this.createTime,
    this.updateTime,
  });

  OrderIconMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickname = json['nickname'];
    parentId = json['parent_id'];
    iconId = json['icon_id'];
    type = json['type'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nickname'] = nickname;
    data['parent_id'] = parentId;
    data['icon_id'] = iconId;
    data['type'] = type;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    return data;
  }
}
