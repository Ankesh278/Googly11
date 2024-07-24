class ViceCaptain {
  ViceCaptain({
      this.imageId, 
      this.playingTeamId, 
      this.roleType, 
      this.name, 
      this.nickName, 
      this.role, 
      this.intlTeam, 
      this.image, 
      this.points, 
      this.playerId,});

  ViceCaptain.fromJson(dynamic json) {
    imageId = json['image_id'] ?? 0;
    playingTeamId = json['playing_team_id'] ?? 0;
    roleType = json['role_type'] ?? '';
    name = json['name'] ?? '';
    nickName = json['nickName'] ?? '';
    role = json['role'] ?? '';
    intlTeam = json['intlTeam'] ?? '';
    image = json['image'] ?? '';
    points = json['points'] ?? 0;
    playerId = json['player_id'] ?? 0;
  }
  int? imageId;
  int? playingTeamId;
  String? roleType;
  String? name;
  String? nickName;
  String? role;
  String? intlTeam;
  String? image;
  int? points;
  int? playerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image_id'] = imageId;
    map['playing_team_id'] = playingTeamId;
    map['role_type'] = roleType;
    map['name'] = name;
    map['nickName'] = nickName;
    map['role'] = role;
    map['intlTeam'] = intlTeam;
    map['image'] = image;
    map['points'] = points;
    map['player_id'] = playerId;
    return map;
  }

}