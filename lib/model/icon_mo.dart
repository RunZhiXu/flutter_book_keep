class IconMo {
  int? id;
  String? name;
  int? iconCategoryId;
  int? createTime;
  int? updateTime;

  IconMo(
      {this.id,
      this.name,
      this.iconCategoryId,
      this.createTime,
      this.updateTime});

  IconMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconCategoryId = json['icon_category_id'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['icon_category_id'] = iconCategoryId;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    return data;
  }
}
