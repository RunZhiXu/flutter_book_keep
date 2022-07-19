class IconCategoryMo {
  int? id;
  String? name;
  int? createTime;
  int? updateTime;

  IconCategoryMo({this.id, this.name, this.createTime, this.updateTime});

  IconCategoryMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    return data;
  }
}
