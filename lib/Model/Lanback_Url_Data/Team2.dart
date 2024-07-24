class Team2 {
  Team2({
    required  this.id,
    required  this.name,
    required  this.playerDetails,
    required this.shortName,});

  Team2.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    playerDetails = json['playerDetails'] ?? '';
    shortName = json['shortName'] ?? '';
  }
  int id =0;
  String name = '';
  dynamic playerDetails = 0;
  String shortName = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['playerDetails'] = playerDetails;
    map['shortName'] = shortName;
    return map;
  }

}