import 'Captain.dart';
import 'ViceCaptain.dart';
import 'Players.dart';

class LiveTeamPreviewData {
  LiveTeamPreviewData({
      this.teamID, 
      this.userID, 
      this.contestID, 
      this.matchId, 
      this.teamName, 
      this.totalCreditPointsUsed, 
      this.captain, 
      this.viceCaptain, 
      this.createdAt, 
      this.updatedAt, 
      this.joinContestId, 
      this.matchTeamId1, 
      this.selectedTeamPlayer1, 
      this.matchTeamId2, 
      this.selectedTeamPlayer2, 
      this.players,});

  LiveTeamPreviewData.fromJson(dynamic json) {
    teamID = json['teamID'] ?? 0;
    userID = json['userID'] ?? 0;
    contestID = json['contestID'] ?? 0;
    matchId = json['match_id'] ?? 0;
    teamName = json['TeamName'] ?? '';
    totalCreditPointsUsed = json['totalCreditPointsUsed'] ?? 0;
    captain = json['captain'] != null ? Captain.fromJson(json['captain']) : null;
    viceCaptain = json['viceCaptain'] != null ? ViceCaptain.fromJson(json['viceCaptain']) : null;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    joinContestId = json['joinContestId'] ?? 0;
    matchTeamId1 = json['match_team_id1'] ?? 0;
    selectedTeamPlayer1 = json['selectedTeamPlayer1'] ?? 0;
    matchTeamId2 = json['match_team_id2'] ?? 0;
    selectedTeamPlayer2 = json['selectedTeamPlayer2'] ?? 0;
    if (json['players'] != null) {
      players = [];
      json['players'].forEach((v) {
        players!.add(Players_.fromJson(v));
      });
    }
  }
  int? teamID;
  int? userID;
  dynamic contestID;
  int? matchId;
  String? teamName;
  int? totalCreditPointsUsed;
  Captain? captain;
  ViceCaptain? viceCaptain;
  String? createdAt;
  String? updatedAt;
  dynamic joinContestId;
  int? matchTeamId1;
  int? selectedTeamPlayer1;
  int? matchTeamId2;
  int? selectedTeamPlayer2;
  List<Players_>? players;

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
    map['joinContestId'] = joinContestId;
    map['match_team_id1'] = matchTeamId1;
    map['selectedTeamPlayer1'] = selectedTeamPlayer1;
    map['match_team_id2'] = matchTeamId2;
    map['selectedTeamPlayer2'] = selectedTeamPlayer2;
    if (players != null) {
      map['players'] = players!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}