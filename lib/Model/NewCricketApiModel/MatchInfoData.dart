import 'Team1Data.dart';
import 'VennueInfoData.dart';

class MatchInfoData {
  dynamic matchId;
  dynamic seriesId;
  String? seriesName;
  String? matchDesc;
  String? matchFormat;
  String? startDate;
  String? endDate;
  String? state;
  String? status;
  Team1Data? team1;
  Team1Data? team2;
  VenueInfoData? venueInfo;
  dynamic currBatTeamId;
  String? seriesStartDt;
  String? seriesEndDt;
  bool? isTimeAnnounced;
  String? stateTitle;
  bool? isFantasyEnabled;

  MatchInfoData(
      {this.matchId,
        this.seriesId,
        this.seriesName,
        this.matchDesc,
        this.matchFormat,
        this.startDate,
        this.endDate,
        this.state,
        this.status,
        this.team1,
        this.team2,
        this.venueInfo,
        this.currBatTeamId,
        this.seriesStartDt,
        this.seriesEndDt,
        this.isTimeAnnounced,
        this.stateTitle,
        this.isFantasyEnabled});

  MatchInfoData.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    seriesId = json['seriesId'];
    seriesName = json['seriesName'];
    matchDesc = json['matchDesc'];
    matchFormat = json['matchFormat'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    state = json['state'];
    status = json['status'];
    team1 = json['team1'] != null
        ? (json['team1'] is List
        ? (json['team1'] as List).map((item) => Team1Data.fromJson(item)).toList()
        : Team1Data.fromJson(json['team1'])) as Team1Data?
        : null;

    team2 = json['team2'] != null
        ? (json['team2'] is List
        ? (json['team2'] as List).map((item) => Team1Data.fromJson(item)).toList()
        : Team1Data.fromJson(json['team2'])) as Team1Data?
        : null;


    venueInfo = json['venueInfo'] != null
        ? new VenueInfoData.fromJson(json['venueInfo'])
        : null;
    currBatTeamId = json['currBatTeamId'];
    seriesStartDt = json['seriesStartDt'];
    seriesEndDt = json['seriesEndDt'];
    isTimeAnnounced = json['isTimeAnnounced'];
    stateTitle = json['stateTitle'];
    isFantasyEnabled = json['isFantasyEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = this.matchId;
    data['seriesId'] = this.seriesId;
    data['seriesName'] = this.seriesName;
    data['matchDesc'] = this.matchDesc;
    data['matchFormat'] = this.matchFormat;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['state'] = this.state;
    data['status'] = this.status;
    if (this.team1 != null) {
      data['team1'] = this.team1!.toJson();
    }
    if (this.team2 != null) {
      data['team2'] = this.team2!.toJson();
    }
    if (this.venueInfo != null) {
      data['venueInfo'] = this.venueInfo!.toJson();
    }
    data['currBatTeamId'] = this.currBatTeamId;
    data['seriesStartDt'] = this.seriesStartDt;
    data['seriesEndDt'] = this.seriesEndDt;
    data['isTimeAnnounced'] = this.isTimeAnnounced;
    data['stateTitle'] = this.stateTitle;
    data['isFantasyEnabled'] = this.isFantasyEnabled;
    return data;
  }
}