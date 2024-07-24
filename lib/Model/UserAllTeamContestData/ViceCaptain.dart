class ViceCaptain {
  ViceCaptain({
   required   this.imageId,
    required  this.roleType,
    required  this.name,
    required this.nickName,
    required this.role,
    required this.intlTeam,
    required this.image,
    required this.points,
    required this.playerId,});

  ViceCaptain.fromJson(dynamic json) {
    imageId = json['image_id'] ?? 0;
    roleType = json['role_type'] ?? '';
    name = json['name'] ?? '';
    nickName = json['nickName'] ?? '';
    role = json['role'] ?? '';
    intlTeam = json['intlTeam'] ?? '';
    image = json['image'] ?? '';
    points = json['points'] ?? 0;
    playerId = json['player_id'] ?? 0;
  }
  int imageId  = 0;
  String roleType  = '';
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