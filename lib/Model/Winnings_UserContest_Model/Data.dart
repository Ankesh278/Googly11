class WinnersData {
  WinnersData({
    required  this.id,
    required  this.userName,
    required  this.userMapingId,
    required  this.rank,
    required  this.teamID,
    required  this.teamName,
    required this.winnings,});

  WinnersData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    userName = json['user_name'] ?? '';
    userMapingId = json['user_Maping_id'] ?? 0;
    rank = json['rank'] ?? 0;
    teamID = json['teamID'] ?? 0;
    teamName = json['TeamName'] ?? '';
    winnings = json['winnings']?? '';
  }
  int id= 0;
  String userName= '';
  int userMapingId = 0;
  int rank = 0;
  int teamID = 0 ;
  String teamName = '';
  String winnings = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_name'] = userName;
    map['user_Maping_id'] = userMapingId;
    map['rank'] = rank;
    map['teamID'] = teamID;
    map['TeamName'] = teamName;
    map['winnings'] = winnings;
    return map;
  }

}