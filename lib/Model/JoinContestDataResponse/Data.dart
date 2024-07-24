import 'JoinContestUser.dart';
import 'LeaderBoardEntry.dart';

class JoinContestData_ {
  JoinContestData_({
     required this.id,
      this.matchId,
    required this.totalTeamsAllowed,
    required this.contestName,
    required this.entryFee,
    required this.firstPrize,
    required this.status,
    required this.contestType,
    required this.contestDescription,
    required  this.winnerCriteria,
      this.scoringSystem,
    required this.userParticipant,
    required this.appCharge,
    required this.useBonus,
    required this.bonusContest,
    required this.visibility,
      this.startTime, 
      this.endTime,
    required this.guaranteed,
    required this.contestStatus,
    required this.numberOfUser,
    required this.contestLimit,
      this.joinContestUser,
    this.leaderBoard_Entry,
  });

  JoinContestData_.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    matchId = json['match_id'];
    totalTeamsAllowed = json['total_teams_allowed'] ?? 0;
    contestName = json['contest_name'] ?? '';
    entryFee = json['entry_fee'] ?? '';
    firstPrize = json['first_prize']?? '';
    status = json['status']?? '';
    contestType = json['contest_type'];
    contestDescription = json['contest_description'];
    winnerCriteria = json['winner_criteria'];
    scoringSystem = json['scoring_system'];
    userParticipant = json['user_participant'];
    appCharge = json['app_charge'];
    useBonus = json['use_bonus'];
    bonusContest = json['bonus_contest'];
    visibility = json['visibility'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    contestStatus = json['contest_status'];
    guaranteed = json['guaranteed'];
    numberOfUser = json['numberOfUser'];
    contestLimit = json['contestLimit'];
    if (json['join_contest_user'] != null) {
      joinContestUser = [];
      json['join_contest_user'].forEach((v) {
        joinContestUser!.add(JoinContestUser.fromJson(v));
      });
    }
    if (json['getlidarboard_data'] != null) {
      leaderBoard_Entry = [];
      json['getlidarboard_data'].forEach((v) {
        leaderBoard_Entry!.add(LeaderboardEntry.fromJson(v));
      });
    }
  }
  int id = 0;
  dynamic matchId;
  int totalTeamsAllowed =0;
  String contestName ='';
  String entryFee ='';
  String firstPrize ='';
  String status ='';
  String contestType ='';
  String contestDescription ='';
  int winnerCriteria = 0;
  dynamic scoringSystem;
  int userParticipant = 0;
  int appCharge = 0;
  int useBonus = 0;
  int bonusContest = 0;
  String visibility ='';
  dynamic startTime;
  dynamic endTime;
  int guaranteed=0;
  int contestStatus = 0;
  int numberOfUser = 0;
  String contestLimit ='';
  List<JoinContestUser>? joinContestUser;
  List<LeaderboardEntry>? leaderBoard_Entry;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['match_id'] = matchId;
    map['total_teams_allowed'] = totalTeamsAllowed;
    map['contest_name'] = contestName;
    map['entry_fee'] = entryFee;
    map['first_prize'] = firstPrize;
    map['status'] = status;
    map['contest_type'] = contestType;
    map['contest_description'] = contestDescription;
    map['winner_criteria'] = winnerCriteria;
    map['scoring_system'] = scoringSystem;
    map['user_participant'] = userParticipant;
    map['app_charge'] = appCharge;
    map['use_bonus'] = useBonus;
    map['bonus_contest'] = bonusContest;
    map['visibility'] = visibility;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['contest_status'] = contestStatus;
    map['guaranteed'] = guaranteed;
    map['numberOfUser'] = numberOfUser;
    map['contestLimit'] = contestLimit;
    if (joinContestUser != null) {
      map['join_contest_user'] = joinContestUser!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}