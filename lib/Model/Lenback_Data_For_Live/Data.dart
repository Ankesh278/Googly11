
import 'BatsmanStriker.dart';
import 'BatsmanNonStriker.dart';
import 'BatTeam.dart';
import 'BowlerStriker.dart';
import 'BowlerNonStriker.dart';
import 'MatchScoreDetails.dart';

class LenBack_Data_For_Live {
  LenBack_Data_For_Live({
    required  this.batsmanStriker,
    required this.batsmanNonStriker,
    required this.batTeam,
    required this.bowlerStriker,
    required this.bowlerNonStriker,
    required this.overs,
    required this.recentOvsStats,
    required this.target,
    required this.lastWicket,});

  LenBack_Data_For_Live.fromJson(dynamic json) {
    batsmanStriker = json['batsmanStriker'] != null ? BatsmanStriker.fromJson(json['batsmanStriker']) : null;
    batsmanNonStriker = json['batsmanNonStriker'] != null ? BatsmanNonStriker.fromJson(json['batsmanNonStriker']) : null;
    batTeam = json['batTeam'] != null ? BatTeam.fromJson(json['batTeam']) : null;
    bowlerStriker = json['bowlerStriker'] != null ? BowlerStriker.fromJson(json['bowlerStriker']) : null;
    bowlerNonStriker = json['bowlerNonStriker'] != null ? BowlerNonStriker.fromJson(json['bowlerNonStriker']) : null;
    matchScoreDetails = json['matchScoreDetails'] != null ? MatchScoreDetails.fromJson(json['matchScoreDetails']) : null;
    overs = json['overs'];
    recentOvsStats = json['recentOvsStats'];
    target = json['target'];
    lastWicket = json['lastWicket'];
  }
  BatsmanStriker? batsmanStriker;
  BatsmanNonStriker? batsmanNonStriker;
  BatTeam? batTeam;
  BowlerStriker? bowlerStriker;
  BowlerNonStriker? bowlerNonStriker;
  MatchScoreDetails? matchScoreDetails;
  dynamic overs= 0.0;
  dynamic recentOvsStats = '';
  dynamic target = 0;
  dynamic lastWicket = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (batsmanStriker != null) {
      map['batsmanStriker'] = batsmanStriker!.toJson();
    }
    if (batsmanNonStriker != null) {
      map['batsmanNonStriker'] = batsmanNonStriker!.toJson();
    }
    if (batTeam != null) {
      map['batTeam'] = batTeam!.toJson();
    }
    if (bowlerStriker != null) {
      map['bowlerStriker'] = bowlerStriker!.toJson();
    }
    if (bowlerNonStriker != null) {
      map['bowlerNonStriker'] = bowlerNonStriker!.toJson();
    }
    map['overs'] = overs;
    map['recentOvsStats'] = recentOvsStats;
    map['target'] = target;
    map['lastWicket'] = lastWicket;
    return map;
  }

}