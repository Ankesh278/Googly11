import 'PlayerDetails.dart';

class Players_ {
  Players_({
      this.teamPlayerID, 
      this.teamID, 
      this.playerID, 
      this.captain, 
      this.viceCaptain, 
      this.batting, 
      this.bowling, 
      this.fielding, 
      this.other, 
      this.strikeRate, 
      this.bowlingFigures, 
      this.economyRate, 
      this.playerOfTheMatch, 
      this.totalMatchPoints, 
      this.dismissalMethod, 
      this.playerDetails,
  });

  Players_.fromJson(dynamic json) {
    teamPlayerID = json['teamPlayerID'] ?? 0;
    teamID = json['teamID'] ?? 0;
    playerID = json['playerID'] ?? 0;
    captain = json['captain'] ?? 0;
    viceCaptain = json['viceCaptain'] ?? 0;
    batting = json['batting'] ?? 0;
    bowling = json['bowling'] ?? 0;
    fielding = json['fielding'] ?? 0;
    other = json['other'] ?? 0;
    strikeRate = json['strike_rate'] ?? '';
    bowlingFigures = json['bowling_figures'] ?? '';
    economyRate = json['economy_rate'] ?? '';
    playerOfTheMatch = json['player_of_the_match'] ?? '';
    totalMatchPoints = json['total_match_points'] ?? 0;
    dismissalMethod = json['dismissal_method'] ?? '';
    playerDetails = json['playerDetails'] != null ? PlayerDetails.fromJson(json['playerDetails']) : null;
  }
  int? teamPlayerID;
  int? teamID;
  int? playerID;
  int? captain;
  int? viceCaptain;
  int? batting;
  int? bowling;
  int? fielding;
  int? other;
  String? strikeRate;
  dynamic bowlingFigures;
  String? economyRate;
  dynamic playerOfTheMatch;
  int? totalMatchPoints;
  dynamic dismissalMethod;
  PlayerDetails? playerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamPlayerID'] = teamPlayerID;
    map['teamID'] = teamID;
    map['playerID'] = playerID;
    map['captain'] = captain;
    map['viceCaptain'] = viceCaptain;
    map['batting'] = batting;
    map['bowling'] = bowling;
    map['fielding'] = fielding;
    map['other'] = other;
    map['strike_rate'] = strikeRate;
    map['bowling_figures'] = bowlingFigures;
    map['economy_rate'] = economyRate;
    map['player_of_the_match'] = playerOfTheMatch;
    map['total_match_points'] = totalMatchPoints;
    map['dismissal_method'] = dismissalMethod;
    if (playerDetails != null) {
      map['playerDetails'] = playerDetails!.toJson();
    }
    return map;
  }

}