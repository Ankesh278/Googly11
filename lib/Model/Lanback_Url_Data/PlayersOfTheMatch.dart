class PlayersOfTheMatch {
  PlayersOfTheMatch({
     required this.id,
    required this.name,
    required this.fullName,
    required this.nickName,
    required this.captain,
    required this.keeper,
    required this.substitute,
    required this.teamName,
    required  this.faceImageId,});

  PlayersOfTheMatch.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    fullName = json['fullName'] ?? '';
    nickName = json['nickName'] ?? '';
    captain = json['captain'] ?? false;
    keeper = json['keeper'] ?? false;
    substitute = json['substitute'] ?? false;
    teamName = json['teamName'] ?? '';
    faceImageId = json['faceImageId'] ?? 0;
  }
  int id = 0;
  String name = '';
  String fullName = '';
  String nickName = '';
  bool captain = false;
  bool keeper = false;
  bool substitute = false;
  String teamName = '';
  int faceImageId = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['fullName'] = fullName;
    map['nickName'] = nickName;
    map['captain'] = captain;
    map['keeper'] = keeper;
    map['substitute'] = substitute;
    map['teamName'] = teamName;
    map['faceImageId'] = faceImageId;
    return map;
  }

}