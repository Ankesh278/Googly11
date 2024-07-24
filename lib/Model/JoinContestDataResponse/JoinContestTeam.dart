import 'CaptainDetails.dart';
import 'ViceCaptainDetails.dart';

class JoinContestTeam {
  JoinContestTeam.fromJson(dynamic json) {
    teamID = json['teamID'] ?? 0;
    userID = json['userID'] ?? 0;
    contestID = json['contestID'] ?? 0;
    matchId = json['match_id'] ?? 0;
    teamName = json['TeamName'] ?? '';
    totalCreditPointsUsed = json['totalCreditPointsUsed']?? 0;
    captain = json['captain'] ?? 0;
    viceCaptain = json['viceCaptain'] ?? 0;
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    captainDetails = json['captainDetails'] != null ? CaptainDetails.fromJson(json['captainDetails']) : null;
    viceCaptainDetails = json['viceCaptainDetails'] != null ? ViceCaptainDetails.fromJson(json['viceCaptainDetails']) : null;
  }
  int teamID = 0;
  int userID = 0;
  int contestID = 0;
  int matchId = 0;
  String teamName = '';
  int totalCreditPointsUsed  = 0;
  int captain = 0;
  int viceCaptain = 0;

  CaptainDetails? captainDetails;
  ViceCaptainDetails? viceCaptainDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamID'] = teamID;
    map['userID'] = userID;
    map['contestID'] = contestID;
    map['match_id'] = matchId;
    map['TeamName'] = teamName;
    map['totalCreditPointsUsed'] = totalCreditPointsUsed;
    map['captain'] = captain;
    map['viceCaptain'] = viceCaptain;

    if (captainDetails != null) {
      map['captainDetails'] = captainDetails!.toJson();
    }
    if (viceCaptainDetails != null) {
      map['viceCaptainDetails'] = viceCaptainDetails!.toJson();
    }
    return map;
  }

}