import 'Players.dart';

class TeamDataContest {
  TeamDataContest({
     required this.teamID,
    required this.userID,
    required  this.contestID,
    required this.matchId,
    required  this.teamName,
    required  this.totalCreditPointsUsed,
    required this.createdAt,
    required this.updatedAt,
    required this.players,});

  TeamDataContest.fromJson(dynamic json) {
    teamID = json['teamID'] ?? 0;
    userID = json['userID'] ?? 0;
    contestID = json['contestID'] ?? 0;
    matchId = json['match_id'] ?? 0;
    teamName = json['TeamName'] ?? '';
    totalCreditPointsUsed = json['totalCreditPointsUsed'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    if (json['players'] != null) {
      players = [];
      json['players'].forEach((v) {
        players!.add(Players_.fromJson(v));
      });
    }
  }
  int teamID = 0;
  int userID = 0;
  int contestID = 0;
  int matchId = 0;
  String teamName = '';
  int totalCreditPointsUsed = 0;
  String createdAt = '';
  String updatedAt = '';
  List<Players_>? players;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamID'] = teamID;
    map['userID'] = userID;
    map['contestID'] = contestID;
    map['match_id'] = matchId;
    map['TeamName'] = teamName;
    map['totalCreditPointsUsed'] = totalCreditPointsUsed;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (players != null) {
      map['players'] = players!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}