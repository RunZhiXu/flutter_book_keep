/// 记账数据
/// [type] 类型 1-收入 0-支出 2-报销 3-退款
/// [categoryId] 分类 就是 [OrderIconMo]的id
/// [parentId] 通常是退款类型使用，用来定位原账单
class HiOrderMo {
  int? id;
  int? type;
  double? count;
  String? description;
  int? categoryId;
  int? createTime;
  int? updateTime;
  int? parentId;

  HiOrderMo(
      {this.id,
      this.type,
      this.count,
      this.categoryId,
      this.description,
      this.createTime,
      this.updateTime,
      this.parentId});

  HiOrderMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    count = json['count'];
    description = json['description'];
    categoryId = json['category_id'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['count'] = count;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    data['parent_id'] = parentId;
    return data;
  }
}
