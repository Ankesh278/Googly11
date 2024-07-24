class JoinContestData {
  JoinContestData({
    required  this.id,
    required this.contestId,
    required this.userId,
    required this.teamId,
    required  this.contestName,
    required  this.totalTeamsAllowed,
    required  this.entryFee,
    required  this.firstPrize,
    required  this.status,
    required  this.winnerCriteria,
    required  this.userParticipant,
    required  this.useBonus,
    required  this.bonusContest,
    required  this.matchId,
    required  this.numberOfUser,
    required  this.app_charge,
    required  this.contestLimit
  });

  JoinContestData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    contestId = json['contest_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    teamId = json['team_id'] ?? 0;
    contestName = json['contest_name'] ?? '';
    totalTeamsAllowed = json['total_teams_allowed'] ?? 0;
    entryFee = json['entry_fee'] ?? '';
    firstPrize = json['first_prize'] ?? '';
    status = json['status'] ?? '';
    winnerCriteria = json['winner_criteria'] ?? 0;
    userParticipant = json['user_participant'] ?? 0;
    useBonus = json['use_bonus'] ?? 0;
    bonusContest = json['bonus_contest'] ?? 0;
    matchId = json['match_id'] ?? 0;
    numberOfUser = json['numberOfUser'] ?? 0;
    app_charge = json['app_charge'] ?? 0;
    contestLimit = json['contestLimit'] ?? '';
  }
  int id = 0;
  int contestId = 0;
  int userId = 0;
  int teamId = 0;
  String contestName = '';
  int totalTeamsAllowed = 0;
  String entryFee = '';
  String firstPrize = '';
  String status = '';
  int winnerCriteria = 0;
  int userParticipant = 0;
  int useBonus = 0;
  int app_charge = 0;
  int numberOfUser = 0;
  int bonusContest = 0;
  int matchId = 0;
  String contestLimit = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['contest_id'] = contestId;
    map['user_id'] = userId;
    map['team_id'] = teamId;
    map['contest_name'] = contestName;
    map['total_teams_allowed'] = totalTeamsAllowed;
    map['entry_fee'] = entryFee;
    map['first_prize'] = firstPrize;
    map['status'] = status;
    map['winner_criteria'] = winnerCriteria;
    map['user_participant'] = userParticipant;
    map['use_bonus'] = useBonus;
    map['bonus_contest'] = bonusContest;
    map['match_id'] = matchId;
    map['app_charge'] = app_charge;
    map['numberOfUser'] = numberOfUser;
    map['contestLimit'] = contestLimit;
    return map;
  }

}