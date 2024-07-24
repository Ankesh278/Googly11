import 'JoinContestTeam.dart';

class JoinContestUser {


  JoinContestUser.fromJson(dynamic json) {
    id = json['id'];
    contestId = json['contest_id'];
    userId = json['user_id'];
    teamId = json['team_id'];
    score = json['score'];
    rank = json['rank'];
    entryTime = json['entry_time'];
    winnings = json['winnings'];
    teamConfirmed = json['team_confirmed'];
    statusPayment = json['status_payment'];
    bonusPoints = json['bonus_points'];
    penalties = json['penalties'];
    tieBreakerPoints = json['tie_breaker_points'];
    performanceAnalysis = json['performance_analysis'];
    feedback = json['feedback'];
    matchStatus = json['match_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['join_contest_team'] != null) {
      joinContestTeam = [];
      json['join_contest_team'].forEach((v) {
        joinContestTeam!.add(JoinContestTeam.fromJson(v));
      });
    }
  }
  int id = 0;
  int contestId= 0;
  int userId= 0;
  int teamId= 0;
  int score= 0;
  int rank= 0;
  String entryTime= '';
  String winnings= '';
  int teamConfirmed= 0;
  int statusPayment= 0;
  String bonusPoints= '';
  dynamic penalties;
  dynamic tieBreakerPoints;
  dynamic performanceAnalysis;
  dynamic feedback;
  int matchStatus= 0;
  String createdAt= '';
  String updatedAt= '';
  List<JoinContestTeam>? joinContestTeam;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['contest_id'] = contestId;
    map['user_id'] = userId;
    map['team_id'] = teamId;
    map['score'] = score;
    map['rank'] = rank;
    map['entry_time'] = entryTime;
    map['winnings'] = winnings;
    map['team_confirmed'] = teamConfirmed;
    map['status_payment'] = statusPayment;
    map['bonus_points'] = bonusPoints;
    map['penalties'] = penalties;
    map['tie_breaker_points'] = tieBreakerPoints;
    map['performance_analysis'] = performanceAnalysis;
    map['feedback'] = feedback;
    map['match_status'] = matchStatus;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (joinContestTeam != null) {
      map['join_contest_team'] = joinContestTeam!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}