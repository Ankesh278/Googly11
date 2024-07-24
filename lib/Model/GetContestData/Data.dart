import 'package:world11/Model/GetContestData/PrizeDistribution.dart';

class ContestData {
  ContestData({
    required  this.id,
    required this.matchId,
    required this.contestName,
    required this.totalTeamsAllowed,
    required this.entryFee,
    required this.firstPrize,
    required this.status,
    required  this.contestType,
    required  this.contestDescription,
    required this.winnerCriteria,
    required this.scoringSystem,
    required this.userParticipant,
    required  this.appCharge,
    required this.discounts,
    required this.useBonus,
    required this.bonusContest,
    required this.visibility,
    required this.startTime,
    required this.endTime,
    required this.contestStatus,
    required this.numberOfUser,
    required this.createdAt,
    required  this.updatedAt,
    required this.guaranteed,
    required this.lineOut,
    required this.contestLimit
  });

  ContestData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    matchId = json['match_id'] ?? 0;
    contestName = json['contest_name'] ?? '';
    totalTeamsAllowed = json['total_teams_allowed'] ?? 0;
    entryFee = json['entry_fee'] ?? 0;
    discounts = json['discounts'] ?? 0;
    firstPrize = json['first_prize'] ?? '';
    status = json['status'] ?? '';
    contestType = json['contest_type'] ?? '';
    contestDescription = json['contest_description'] ?? '';
    winnerCriteria = json['winner_criteria'] ?? 0;
    scoringSystem = json['scoring_system'] ?? 0;
    userParticipant = json['user_participant'] ?? 0;
    appCharge = json['app_charge'] ?? 0;
    useBonus = json['use_bonus'] ?? 0;
    bonusContest = json['bonus_contest'] ?? 0;
    visibility = json['visibility'] ?? '';
    startTime = json['start_time'] ?? 0;
    endTime = json['end_time'] ?? 0;
    guaranteed = json['guaranteed'] ?? 0;
    contestStatus = json['contest_status'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    contest_full_aur_not_full = json['contest_full_aur_not_full'] ?? '';
    number_of_full_contest = json['number_of_full_contest'] ?? 0;
    numberOfUser=json['numberOfUser'] ?? 0;
    lineOut=json['lineOut'] ?? '';
    contestLimit=json['contestLimit'] ?? "";
    if (json['prize_distributions'] != null) {
      prizeDistribution = [] ;
      json['prize_distributions'].forEach((v) {
        prizeDistribution!.add(PrizeDistribution.fromJson(v));
      });
    }
  }
  int id = 0;
  int matchId = 0;
  String contestName = "";
  int totalTeamsAllowed =0;
  String entryFee ="";
  int discounts= 0;
  dynamic firstPrize;
  String status ="";
  String contestType ="";
  String contestDescription ="";
  int winnerCriteria =0;
  dynamic scoringSystem;
  int userParticipant= 0;
  int appCharge= 0;
  int useBonus= 0;
  dynamic bonusContest;
  String visibility= "";
  dynamic startTime;
  dynamic endTime;
  int numberOfUser=0;
  String contest_full_aur_not_full='';
  int number_of_full_contest = 0;
  int contestStatus= 0;
  int guaranteed=0;
  String createdAt= "";
  String updatedAt= "";
  String lineOut='';
  String contestLimit='';
  List<PrizeDistribution>? prizeDistribution;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['match_id'] = matchId;
    map['contest_name'] = contestName;
    map['total_teams_allowed'] = totalTeamsAllowed;
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
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['numberOfUser'] = numberOfUser;
    map['lineOut'] = lineOut;
    map['contestLimit'] = contestLimit;
    // if (prizeDistribution != null) {
    //   map['data'] = prizeDistribution!.map((v) => v.toJson()).toList();
    // }
    return map;
  }

}