import 'TossResults.dart';
import 'Result.dart';
import 'RevisedTarget.dart';
import 'PlayersOfTheMatch.dart';
import 'MatchTeamInfoData.dart';
import 'Team1.dart';
import 'Team2.dart';

class MatchHeader {
  MatchHeader({
    required this.matchId,
    required this.matchDescription,
    required this.matchFormat,
    required this.matchType,
    required this.complete,
    required this.domestic,
    required this.matchStartTimestamp,
    required  this.matchCompleteTimestamp,
    required  this.dayNight,
    required  this.year,
    required  this.state,
    required  this.status,
    required  this.tossResults,
    required  this.result,
    required  this.revisedTarget,
    required  this.playersOfTheMatch,
    required  this.playersOfTheSeries,
    required  this.matchTeamInfo,
    required  this.isMatchNotCovered,
    required this.team1,
    required this.team2,
    required  this.seriesDesc,
    required this.seriesId,
    required this.seriesName,
    required this.alertType,
    required this.livestreamEnabled,});

  MatchHeader.fromJson(dynamic json) {
    matchId = json['matchId']?.toInt() ?? 0;
    matchDescription = json['matchDescription'] ?? '';
    matchFormat = json['matchFormat'] ?? '';
    matchType = json['matchType'] ?? '';
    complete = json['complete'] ?? false;
    domestic = json['domestic'] ?? false;
    matchStartTimestamp = json['matchStartTimestamp'] ?? 0;
    matchCompleteTimestamp = json['matchCompleteTimestamp'] ?? 0;
    dayNight = json['dayNight'] ?? false;
    year = json['year'] ?? 0;
    state = json['state'] ?? '';
    status = json['status'] ?? '';
    tossResults = json['tossResults'] != null ? TossResults.fromJson(json['tossResults']) : null;
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
    revisedTarget = json['revisedTarget'] != null ? RevisedTarget.fromJson(json['revisedTarget']) : null;
    if (json['playersOfTheMatch'] != null) {
      playersOfTheMatch = [];
      json['playersOfTheMatch'].forEach((v) {
        playersOfTheMatch!.add(PlayersOfTheMatch.fromJson(v));
      });
    }
    playersOfTheSeries = json['playersOfTheSeries'] ?? 0.0; // Change to double
    if (json['matchTeamInfo'] != null) {
      matchTeamInfo = [];
      json['matchTeamInfo'].forEach((v) {
        matchTeamInfo!.add(MatchTeamInfo.fromJson(v));
      });
    }
    isMatchNotCovered = json['isMatchNotCovered'] ?? false;
    team1 = json['team1'] != null ? Team1.fromJson(json['team1']) : null;
    team2 = json['team2'] != null ? Team2.fromJson(json['team2']) : null;
    seriesDesc = json['seriesDesc'] ?? '';
    seriesId = json['seriesId'] ?? 0;
    seriesName = json['seriesName'] ?? '';
    alertType = json['alertType'] ?? '';
    livestreamEnabled = json['livestreamEnabled'] ?? false;
  }

  int matchId =0;
  String matchDescription = '';
  String matchFormat = '';
  String matchType = '';
  bool complete = false;
  bool domestic = false;
  int matchStartTimestamp = 0;
  int matchCompleteTimestamp = 0;
  bool dayNight = false;
  int year = 0;
  String state = '';
  String status = '';
  TossResults? tossResults;
  Result? result;
  RevisedTarget? revisedTarget;
  List<PlayersOfTheMatch>? playersOfTheMatch;
  dynamic playersOfTheSeries = 0;
  List<MatchTeamInfo>? matchTeamInfo;
  bool isMatchNotCovered = false;
  Team1? team1;
  Team2? team2;
  String seriesDesc = '';
  int seriesId = 0;
  String seriesName = '';
  String alertType = '';
  bool livestreamEnabled = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['matchId'] = matchId;
    map['matchDescription'] = matchDescription;
    map['matchFormat'] = matchFormat;
    map['matchType'] = matchType;
    map['complete'] = complete;
    map['domestic'] = domestic;
    map['matchStartTimestamp'] = matchStartTimestamp;
    map['matchCompleteTimestamp'] = matchCompleteTimestamp;
    map['dayNight'] = dayNight;
    map['year'] = year;
    map['state'] = state;
    map['status'] = status;
    if (tossResults != null) {
      map['tossResults'] = tossResults!.toJson();
    }
    if (result != null) {
      map['result'] = result!.toJson();
    }
    if (revisedTarget != null) {
      map['revisedTarget'] = revisedTarget!.toJson();
    }
    if (playersOfTheMatch != null) {
      map['playersOfTheMatch'] = playersOfTheMatch!.map((v) => v.toJson()).toList();
    }
    map['playersOfTheSeries'] = playersOfTheSeries;
    if (matchTeamInfo != null) {
      map['matchTeamInfo'] = matchTeamInfo!.map((v) => v.toJson()).toList();
    }
    map['isMatchNotCovered'] = isMatchNotCovered;
    if (team1 != null) {
      map['team1'] = team1!.toJson();
    }
    if (team2 != null) {
      map['team2'] = team2!.toJson();
    }
    map['seriesDesc'] = seriesDesc;
    map['seriesId'] = seriesId;
    map['seriesName'] = seriesName;
    map['alertType'] = alertType;
    map['livestreamEnabled'] = livestreamEnabled;
    return map;
  }

}