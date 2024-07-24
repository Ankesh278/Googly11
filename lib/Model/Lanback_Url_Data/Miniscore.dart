import 'BatsmanStriker.dart';
import 'BatTeam.dart';
import 'BowlerStriker.dart';
import 'BowlerNonStriker.dart';
import 'PartnerShip.dart';
import 'MatchScoreDetails.dart';
import 'PpData.dart';

class Miniscore {
  Miniscore({
    required this.inningsId,
    required  this.batsmanStriker,
    required  this.batsmanNonStriker,
    required  this.batTeam,
    required  this.bowlerStriker,
    required  this.bowlerNonStriker,
    required  this.overs,
    required  this.recentOvsStats,
    required  this.target,
    required  this.partnerShip,
    required  this.currentRunRate,
    required  this.requiredRunRate,
    required this.lastWicket,
    required  this.matchScoreDetails,
    required this.latestPerformance,
    required  this.ppData,
    required  this.overSummaryList,
    required  this.lastWicketScore,
    required  this.remRunsToWin,
    required  this.responseLastUpdated,
    required  this.event,});

  Miniscore.fromJson(dynamic json) {
    inningsId = json['inningsId'] ?? 0;
    batsmanStriker = json['batsmanStriker'] != null ? BatsmanStriker.fromJson(json['batsmanStriker']) : null;
    batsmanNonStriker = json['batsmanNonStriker'] != null ? BatsmanStriker.fromJson(json['batsmanNonStriker']) : null;
    batTeam = json['batTeam'] != null ? BatTeam.fromJson(json['batTeam']) : null;
    bowlerStriker = (json['bowlerStriker'] != null ? BowlerStriker.fromJson(json['bowlerStriker']) : null)!;
    bowlerNonStriker = (json['bowlerNonStriker'] != null ? BowlerNonStriker.fromJson(json['bowlerNonStriker']) : null)!;
    overs = json['overs'] ?? 0.0; // Change to double
    recentOvsStats = json['recentOvsStats'] ?? '';
    target = json['target'] ?? 0;
    partnerShip = (json['partnerShip'] != null ? PartnerShip.fromJson(json['partnerShip']) : null)!;
    currentRunRate = json['currentRunRate'] ?? 0.0; // Change to double
    requiredRunRate = json['requiredRunRate'] ?? 0;
    lastWicket = json['lastWicket'] ?? '';
    matchScoreDetails = json['matchScoreDetails'] != null ? MatchScoreDetails.fromJson(json['matchScoreDetails']) : null;
    latestPerformance = json['latestPerformance'] ?? 0.0; // Change to double
    ppData = json['ppData'] != null ? PpData.fromJson(json['ppData']) : null;
    overSummaryList = json['overSummaryList'] ?? 0.0; // Change to double
    lastWicketScore = json['lastWicketScore'] ?? 0;
    remRunsToWin = json['remRunsToWin'] ?? 0;
    responseLastUpdated = json['responseLastUpdated'] ?? 0;
    event = json['event'] ?? '';
  }

  int inningsId = 0;
  BatsmanStriker? batsmanStriker;
  BatsmanStriker? batsmanNonStriker;
  BatTeam? batTeam;
  BowlerStriker? bowlerStriker;
  BowlerNonStriker? bowlerNonStriker;
  dynamic overs =0;
  String recentOvsStats ='';
  int target =0;
  PartnerShip? partnerShip;
  dynamic currentRunRate =0;
  int requiredRunRate =0;
  String lastWicket ='';
  MatchScoreDetails? matchScoreDetails;
  dynamic latestPerformance =0;
  PpData? ppData;
  dynamic overSummaryList=0;
  int lastWicketScore =0;
  int remRunsToWin =0;
  int responseLastUpdated =0;
  String event ='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inningsId'] = inningsId;
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
    if (partnerShip != null) {
      map['partnerShip'] = partnerShip!.toJson();
    }
    map['currentRunRate'] = currentRunRate;
    map['requiredRunRate'] = requiredRunRate;
    map['lastWicket'] = lastWicket;
    if (matchScoreDetails != null) {
      map['matchScoreDetails'] = matchScoreDetails!.toJson();
    }
    map['latestPerformance'] = latestPerformance;
    if (ppData != null) {
      map['ppData'] = ppData!.toJson();
    }
    map['overSummaryList'] = overSummaryList;
    map['lastWicketScore'] = lastWicketScore;
    map['remRunsToWin'] = remRunsToWin;
    map['responseLastUpdated'] = responseLastUpdated;
    map['event'] = event;
    return map;
  }

}