import 'FirstTeam.dart';
import 'SecondTeam.dart';

class CricketMatchData {
  CricketMatchData({
     required this.id,
    required this.match_id,
    required this.seriesId,
    required this.seriesName,
    required this.matchDesc,
    required  this.matchFormat,
    required this.startDate,
    required this.endDate,
    required this.state,
    required  this.status,
    required this.team1Id,
    required this.team2Id,
    required this.venueId,
    required this.seriesStartDt,
    required this.seriesEndDt,
    required this.isTimeAnnounced,
    required this.stateTitle,
    required this.team1Score,
    required this.team2Score,
    required this.firstTeam,
    required this.secondTeam,});

  CricketMatchData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    match_id=json['match_id'] ?? 0;
    seriesId = json['series_id'] ?? 0;
    seriesName = json['series_name'] ?? '';
    matchDesc = json['match_desc']?? '';
    matchFormat = json['match_format']?? '';
    startDate = json['start_date']?? '';
    endDate = json['end_date']?? '';
    state = json['state'] ?? '';
    status = json['status'] ?? '';
    team1Id = json['team1_id'] ?? 0;
    team2Id = json['team2_id']  ?? 0;
    venueId = json['venue_id']  ?? 0;
    seriesStartDt = json['series_start_dt'] ?? '' ;
    seriesEndDt = json['series_end_dt'] ?? '';
    isTimeAnnounced = json['is_time_announced'] ?? '';
    stateTitle = json['state_title'] ?? '';
    team1Score = json['team1_score'] ?? '';
    team2Score = json['team2_score'] ?? '';
    firstTeam = json['first_team'] != null ? FirstTeam.fromJson(json['first_team']) : null;
    secondTeam = json['second_team'] != null ? SecondTeam.fromJson(json['second_team']) : null;
  }
  int id=0;
  int match_id=0;
  int seriesId=0;
  String seriesName='';
  String matchDesc='';
  String matchFormat='';
  String startDate='';
  String endDate='';
  String state='';
  String status='';
  int team1Id=0;
  int team2Id=0;
  dynamic venueId=0;
  String seriesStartDt='';
  String seriesEndDt='';
  String isTimeAnnounced='';
  String stateTitle='';
  dynamic team1Score='';
  dynamic team2Score='';
  FirstTeam? firstTeam;
  SecondTeam? secondTeam;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['match_id']= match_id;
    map['series_id'] = seriesId;
    map['series_name'] = seriesName;
    map['match_desc'] = matchDesc;
    map['match_format'] = matchFormat;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['state'] = state;
    map['status'] = status;
    map['team1_id'] = team1Id;
    map['team2_id'] = team2Id;
    map['venue_id'] = venueId;
    map['series_start_dt'] = seriesStartDt;
    map['series_end_dt'] = seriesEndDt;
    map['is_time_announced'] = isTimeAnnounced;
    map['state_title'] = stateTitle;
    map['team1_score'] = team1Score;
    map['team2_score'] = team2Score;
    if (firstTeam != null) {
      map['first_team'] = firstTeam!.toJson();
    }
    if (secondTeam != null) {
      map['second_team'] = secondTeam!.toJson();
    }
    return map;
  }

}