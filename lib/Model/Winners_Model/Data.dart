class WinnersDataModel {
  WinnersDataModel({
      this.id, 
      this.name, 
      this.userName, 
      this.userImage, 
      this.rank, 
      this.winnings, 
      this.teamId, 
      this.matchId, 
      this.team1Name, 
      this.team2Name,});

  WinnersDataModel.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    userName = json['user_name'] ?? '';
    userImage = json['user_image'] ?? '';
    rank = json['rank'] ?? 0;
    winnings = json['winnings'] ?? '';
    teamId = json['team_id'] ?? 0;
    matchId = json['match_id'] ?? 0;
    team1Name = json['team1_name'] ?? '';
    team2Name = json['team2_name'] ?? '';
  }
  int? id;
  dynamic name;
  String? userName;
  dynamic userImage;
  int? rank;
  String? winnings;
  int? teamId;
  int? matchId;
  String? team1Name;
  String? team2Name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_name'] = userName;
    map['user_image'] = userImage;
    map['rank'] = rank;
    map['winnings'] = winnings;
    map['team_id'] = teamId;
    map['match_id'] = matchId;
    map['team1_name'] = team1Name;
    map['team2_name'] = team2Name;
    return map;
  }

}