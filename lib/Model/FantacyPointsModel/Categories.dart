import 'Points.dart';

class Categories {
  Categories({
     required this.id,
    required  this.matchTypeId,
    required this.categoryName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.points,});

  Categories.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    matchTypeId = json['match_type_id'] ?? 0;
    categoryName = json['category_name'] ?? '';
    description = json['description'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    if (json['points'] != null) {
      points = [];
      json['points'].forEach((v) {
        points!.add(Points.fromJson(v));
      });
    }
  }
  int id = 0;
  int matchTypeId = 0;
  String categoryName = '';
  String description = '';
  String createdAt = '';
  String updatedAt = '';
  List<Points>? points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['match_type_id'] = matchTypeId;
    map['category_name'] = categoryName;
    map['description'] = description;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (points != null) {
      map['points'] = points!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}