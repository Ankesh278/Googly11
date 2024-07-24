class LiveMatch_Players_Image_Data {
  LiveMatch_Players_Image_Data({
    required  this.id,
    required this.name,
    required  this.fullName,
    required  this.nickName,
    required  this.captain,
    required  this.role,
    required  this.keeper,
    required  this.substitute,
    required  this.teamId,
    required  this.battingStyle,
    required  this.bowlingStyle,
    required  this.teamName,
    required  this.faceImageId,
    required this.points,
    required this.byUser,
    required this.playing_Status
  });

  LiveMatch_Players_Image_Data.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    fullName = json['fullName'] ?? '';
    nickName = json['nickName'] ?? '';
    captain = json['captain'] ?? false;
    role = json['role'] ?? '';
    keeper = json['keeper'] ?? false;
    substitute = json['substitute'] ?? false;
    teamId = json['teamId'] ?? 0;
    battingStyle = json['battingStyle'] ?? '';
    bowlingStyle = json['bowlingStyle'] ?? '';
    teamName = json['teamName'] ?? '';
    faceImageId = json['faceImageId'] ?? '';
    points = json['points'] ?? '';
    byUser = json['byUser'] ?? 0;
    byUser = json['playing_Status'] ?? 0;
  }
  int id = 0;
  String name = '';
  String fullName = '';
  String nickName = '';
  bool captain = false;
  String role = '';
  bool keeper = false;
  bool substitute = false;
  int teamId = 0;
  String battingStyle = '';
  String bowlingStyle = '';
  String teamName = '';
  String faceImageId = '';
  String points = '';
  int byUser = 0;
  int playing_Status = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['fullName'] = fullName;
    map['nickName'] = nickName;
    map['captain'] = captain;
    map['role'] = role;
    map['keeper'] = keeper;
    map['substitute'] = substitute;
    map['teamId'] = teamId;
    map['battingStyle'] = battingStyle;
    map['bowlingStyle'] = bowlingStyle;
    map['teamName'] = teamName;
    map['faceImageId'] = faceImageId;
    map['playing_Status'] = playing_Status;
    return map;
  }

}