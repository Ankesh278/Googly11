import 'Captain.dart';
import 'ViceCaptain.dart';
import 'Players.dart';

class TeamDataAll {
  TeamDataAll({
     required this.teamID,
    required  this.userID,
    required this.contestID,
    required  this.matchId,
    required  this.teamName,
    required   this.totalCreditPointsUsed,
    required   this.captain,
    required  this.viceCaptain,
    required  this.createdAt,
    required  this.updatedAt,
    required  this.players,
    required this.match_team_id1,
    required this.match_team_id2,
    required this.selectedTeamPlayer1,
    required this.selectedTeamPlayer2,
    required this.isPlayCount,
    required this.isNotPlayCount,
    required this.joinContestId
  });

  TeamDataAll.fromJson(dynamic json) {
    teamID = json['teamID'] ?? 0;
    userID = json['userID'] ?? 0;
    contestID = json['contestID'] ?? 0;
    matchId = json['match_id'] ?? 0;
    teamName = json['TeamName'] ?? '';
    totalCreditPointsUsed = json['totalCreditPointsUsed']  ?? 0;
    captain = json['captain'] != null ? Captain.fromJson(json['captain']) : null;
    viceCaptain = json['viceCaptain'] != null ? ViceCaptain.fromJson(json['viceCaptain']) : null;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    joinContestId = json['joinContestId'] ?? 0;
    match_team_id1=json['match_team_id1'] ?? 0;
    selectedTeamPlayer1=json['selectedTeamPlayer1'] ?? 0;
    match_team_id2=json['match_team_id2'] ?? 0;
    isPlayCount=json['isPlayCount'] ?? 0;
    isNotPlayCount=json['isNotPlayCount'] ?? 0;
    selectedTeamPlayer2=json['selectedTeamPlayer2'] ?? 0;
    if (json['players'] != null) {
      players = [];
      json['players'].forEach((v) {
        players!.add(Players.fromJson(v));
      });
    }
  }
  int teamID = 0;
  int userID = 0;
  dynamic contestID = 0;
  int matchId = 0;
  String teamName = '';
  int totalCreditPointsUsed = 0;
  Captain? captain;
  ViceCaptain? viceCaptain;
  String createdAt = '';
  String updatedAt = '';
  dynamic joinContestId;
  int match_team_id1=0;
  int selectedTeamPlayer1=0;
  int match_team_id2 = 0;
  int selectedTeamPlayer2=0;
  int isPlayCount = 0;
  int isNotPlayCount=0;
  List<Players>? players;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamID'] = teamID;
    map['userID'] = userID;
    map['contestID'] = contestID;
    map['match_id'] = matchId;
    map['TeamName'] = teamName;
    map['totalCreditPointsUsed'] = totalCreditPointsUsed;
    if (captain != null) {
      map['captain'] = captain!.toJson();
    }
    if (viceCaptain != null) {
      map['viceCaptain'] = viceCaptain!.toJson();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['joinContestId'] =joinContestId;
    map['match_team_id1']=match_team_id1;
    map['selectedTeamPlayer1']=selectedTeamPlayer1;
    map['match_team_id2'] = match_team_id2;
    map['selectedTeamPlayer2']=selectedTeamPlayer2;
    map['isPlayCount'] = isPlayCount;
    map['isNotPlayCount']=isNotPlayCount;
    if (players != null) {
      map['players'] = players!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}