class Points {
  Points({
    required  this.id,
    required this.categoryId,
    required  this.pointName,
    required  this.value,
    required  this.createdAt,
    required  this.updatedAt,});

  Points.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    pointName = json['point_name'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int id = 0;
  int categoryId = 0;
  String pointName = '';
  int value = 0;
  String createdAt = '';
  String updatedAt = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['point_name'] = pointName;
    map['value'] = value;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}