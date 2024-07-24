class LeaderBoardData {
  LeaderBoardData({
    required  this.id,
    required  this.userName,
    required  this.rank,
    required  this.teamID,
    required  this.isCurrentUser,
    required  this.teamName,
    required  this.winningZone,
    required  this.winnings,
    required this.total_player_points,
    required  this.userId,});

  LeaderBoardData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    userName = json['user_name'] ?? '';
    rank = json['rank'] ?? 0;
    teamID = json['teamID'] ?? 0;
    isCurrentUser = json['isCurrentUser'] ?? false;
    teamName = json['TeamName'] ?? '';
    userId = json['user_id'] ?? 0;
    total_player_points = json['total_player_points'] ?? 0;
    winningZone = json['winningZone'] ?? 0;
    winnings=json['winnings'] ?? '';
  }
  int id = 0;
  String userName = '';
  int rank = 0;
  int teamID = 0;
  bool isCurrentUser=false;
  String teamName= '';
  int userId = 0;
  int total_player_points=0;
  int winningZone=0;
  String winnings='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_name'] = userName;
    map['rank'] = rank;
    map['teamID'] = teamID;
    map['isCurrentUser'] = isCurrentUser;
    map['TeamName'] = teamName;
    map['user_id'] = userId;
    map['total_player_points'] = total_player_points;
    map['winningZone'] = winningZone;
    map['winnings'] = winnings;
    return map;
  }

}