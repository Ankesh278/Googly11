import 'InningsScoreList.dart';
import 'TossResults.dart';
import 'MatchTeamInfoData.dart';

class MatchScoreDetails {
  dynamic matchId;
  List<InningsScoreList>? inningsScoreList;
  TossResults? tossResults;
  List<MatchTeamInfo>? matchTeamInfo;
  bool? isMatchNotCovered;
  String? matchFormat;
  String? state;
  String? customStatus;
  dynamic highlightedTeamId;

  MatchScoreDetails(
      {this.matchId,
        this.inningsScoreList,
        this.tossResults,
        this.matchTeamInfo,
        this.isMatchNotCovered,
        this.matchFormat,
        this.state,
        this.customStatus,
        this.highlightedTeamId});

  MatchScoreDetails.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId']?.toInt();
    if (json['inningsScoreList'] != null) {
      inningsScoreList = <InningsScoreList>[];
      json['inningsScoreList'].forEach((v) {
        inningsScoreList!.add(new InningsScoreList.fromJson(v));
      });
    }
    tossResults = json['tossResults'] != null
        ? new TossResults.fromJson(json['tossResults'])
        : null;
    if (json['matchTeamInfo'] != null) {
      matchTeamInfo = <MatchTeamInfo>[];
      json['matchTeamInfo'].forEach((v) {
        matchTeamInfo!.add(new MatchTeamInfo.fromJson(v));
      });
    }
    isMatchNotCovered = json['isMatchNotCovered'] ?? false;
    matchFormat = json['matchFormat'] ?? '';
    state = json['state'] ?? '';
    customStatus = json['customStatus'] ?? '';
    highlightedTeamId = json['highlightedTeamId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = this.matchId;
    if (this.inningsScoreList != null) {
      data['inningsScoreList'] =
          this.inningsScoreList!.map((v) => v.toJson()).toList();
    }
    if (this.tossResults != null) {
      data['tossResults'] = this.tossResults!.toJson();
    }
    if (this.matchTeamInfo != null) {
      data['matchTeamInfo'] =
          this.matchTeamInfo!.map((v) => v.toJson()).toList();
    }
    data['isMatchNotCovered'] = this.isMatchNotCovered;
    data['matchFormat'] = this.matchFormat;
    data['state'] = this.state;
    data['customStatus'] = this.customStatus;
    data['highlightedTeamId'] = this.highlightedTeamId;
    return data;
  }
}