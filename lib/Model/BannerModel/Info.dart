class Info {
  Info({
     required this.id,
     required this.title,
    required this.image,
    required this.createdAt,
    required this.updatedAt,});

  Info.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int id=0;
  String title="";
  String image="";
  String createdAt="";
  String updatedAt="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}