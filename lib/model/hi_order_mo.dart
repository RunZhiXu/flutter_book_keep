/// 记账数据
/// [type] 类型 income-收入 expenditure-支出 reimbursement-报销 refund-退款
/// [categoryId] 分类
/// [parentId] 通常是退款类型使用，用来定位原账单
class HiOrderMo {
  int? id;
  String? type;
  double? count;
  int? categoryId;
  int? createTime;
  int? updateTime;
  int? parentId;

  HiOrderMo(
      {this.id,
      this.type,
      this.count,
      this.categoryId,
      this.createTime,
      this.updateTime,
      this.parentId});

  HiOrderMo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    count = json['count'];
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
    data['category_id'] = categoryId;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    data['parent_id'] = parentId;
    return data;
  }
}
