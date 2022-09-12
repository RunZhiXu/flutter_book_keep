class MonthOrderMo {
  List<OrderList>? orderList;
  String? day;
  String? count;

  MonthOrderMo({this.orderList, this.day, this.count});

  MonthOrderMo.fromJson(Map<String, dynamic> json) {
    if (json['orderList'] != null) {
      orderList = <OrderList>[];
      json['orderList'].forEach((v) {
        orderList!.add(OrderList.fromJson(v));
      });
    }
    day = json['day'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderList != null) {
      data['orderList'] = orderList!.map((v) => v.toJson()).toList();
    }
    data['day'] = day;
    data['count'] = count;
    return data;
  }
}

class OrderList {
  int? id;
  int? type;
  String? count;
  int? categoryId;
  int? parentId;
  String? description;
  int? createTime;
  int? updateTime;
  Category? category;

  OrderList(
      {this.id,
      this.type,
      this.count,
      this.categoryId,
      this.parentId,
      this.description,
      this.createTime,
      this.updateTime,
      this.category});

  OrderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    count = json['count'];
    categoryId = json['category_id'];
    parentId = json['parent_id'];
    description = json['description'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['count'] = count;
    data['category_id'] = categoryId;
    data['parent_id'] = parentId;
    data['description'] = description;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? nickname;
  int? iconId;
  int? parentId;
  int? type;
  int? createTime;
  int? updateTime;

  Category(
      {this.id,
      this.name,
      this.nickname,
      this.iconId,
      this.parentId,
      this.type,
      this.createTime,
      this.updateTime});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickname = json['nickname'];
    iconId = json['icon_id'];
    parentId = json['parent_id'];
    type = json['type'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nickname'] = nickname;
    data['icon_id'] = iconId;
    data['parent_id'] = parentId;
    data['type'] = type;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    return data;
  }
}
