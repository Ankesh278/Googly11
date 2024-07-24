import 'Categories.dart';

class MatchTypes {
  MatchTypes({
     required this.id,
    required this.name,
    required  this.createdAt,
    required this.updatedAt,
    required this.categories,});

  MatchTypes.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }
  int id = 0;
  String name = '';
  String createdAt = '';
  String updatedAt = '';
  List<Categories> categories = [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (categories != null) {
      map['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}