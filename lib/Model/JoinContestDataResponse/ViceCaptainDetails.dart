class ViceCaptainDetails {


  ViceCaptainDetails.fromJson(dynamic json) {
    playerId = json['player_id'];
    imageId = json['image_id'];
    playingTeamId = json['playing_team_id'];
    roleType = json['role_type'];
    name = json['name'];
    nickName = json['nickName'];
    role = json['role'];
    intlTeam = json['intlTeam'];
    image = json['image'];
    points = json['points'];
  }
  int playerId  = 0;
  int imageId  = 0;
  int playingTeamId = 0;
  String roleType = '';
  String name = '';
  String nickName = '';
  String role = '';
  String intlTeam = '';
  String image = '';
  int points = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['player_id'] = playerId;
    map['image_id'] = imageId;
    map['playing_team_id'] = playingTeamId;
    map['role_type'] = roleType;
    map['name'] = name;
    map['nickName'] = nickName;
    map['role'] = role;
    map['intlTeam'] = intlTeam;
    map['image'] = image;
    map['points'] = points;
    return map;
  }

}