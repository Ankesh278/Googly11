import 'PlayerDetails.dart';

class Players_ {
  Players_({
     required this.teamPlayerID,
    required this.teamID,
    required this.playerID,
    required this.captain,
    required  this.viceCaptain,
    required  this.playerDetails,});

  Players_.fromJson(dynamic json) {
    teamPlayerID = json['teamPlayerID'] ?? 0;
    teamID = json['teamID'] ?? 0;
    playerID = json['playerID'] ?? 0;
    captain = json['captain'] ?? 0;
    viceCaptain = json['viceCaptain'] ?? 0;
    playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }
  int teamPlayerID = 0;
  int teamID = 0;
  int playerID = 0;
  int captain = 0;
  int viceCaptain = 0;
  PlayerDetails? playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamPlayerID'] = teamPlayerID;
    map['teamID'] = teamID;
    map['playerID'] = playerID;
    map['captain'] = captain;
    map['viceCaptain'] = viceCaptain;
    if (playerDetails != null) {
      map['playerDetails'] = playerDetails!.toJson();
    }
    return map;
  }

}