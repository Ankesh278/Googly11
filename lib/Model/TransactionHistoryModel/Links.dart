class Links {
  Links({
    required  this.url,
    required this.label,
    required this.active,});

  Links.fromJson(dynamic json) {
    url = json['url'] ?? '';
    label = json['label'] ?? '';
    active = json['active'] ?? false;
  }
  dynamic url;
  String label = '';
  bool active = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['label'] = label;
    map['active'] = active;
    return map;
  }

}