class PlayerDetails {
  PlayerDetails({
   required   this.imageId,
    required  this.roleType,
    required  this.name,
    required this.nickName,
    required this.role,
    required this.intlTeam,
    required  this.image,
    required  this.points,
    required  this.playerId,
    required this.playing_team_id,
    required this.isPlay
  });

  PlayerDetails.fromJson(dynamic json) {
    imageId = json['image_id'] ?? 0;
    playing_team_id = json['playing_team_id'] ?? 0;
    roleType = json['role_type'] ?? '';
    name = json['name'] ?? '';
    nickName = json['nickName'] ?? '';
    role = json['role'] ?? '';
    intlTeam = json['intlTeam'] ?? '';
    image = json['image'] ?? '';
    isPlay = json['isPlay'] ?? 0;
    points = json['points'] ?? 0;
    playerId = json['player_id']  ?? 0;
  }
  int imageId = 0;
  int playing_team_id = 0;
  String roleType = '';
  int isPlay=0;
  String name = '';
  String nickName = '';
  String role = '';
  String intlTeam = '';
  String image = '';
  int points = 0;
  int playerId = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_id'] = imageId;
    map['playing_team_id'] = playing_team_id;
    map['role_type'] = roleType;
    map['name'] = name;
    map['nickName'] = nickName;
    map['role'] = role;
    map['intlTeam'] = intlTeam;
    map['image'] = image;
    map['points'] = points;
    map['isPlay'] = isPlay;
    map['player_id'] = playerId;
    return map;
  }

}