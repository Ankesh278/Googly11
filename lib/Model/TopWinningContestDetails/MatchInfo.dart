class MatchInfo {
  MatchInfo({
      this.contestId, 
      this.winnings, 
      this.rank, 
      this.contestName, 
      this.matchId, 
      this.totalAmountDis, 
      this.contestEntryFee,});

  MatchInfo.fromJson(dynamic json) {
    contestId = json['contest_id'] ?? 0;
    winnings = json['winnings'] ?? '';
    rank = json['rank'] ?? 0;
    contestName = json['contest_name'] ?? '';
    matchId = json['match_id'] ?? 0;
    totalAmountDis = json['total_amount_dis'] ?? '';
    contestEntryFee = json['contest_entry_fee'] ?? '';
  }
  int? contestId;
  String? winnings;
  int? rank;
  String? contestName;
  int? matchId;
  String? totalAmountDis;
  String? contestEntryFee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contest_id'] = contestId;
    map['winnings'] = winnings;
    map['rank'] = rank;
    map['contest_name'] = contestName;
    map['match_id'] = matchId;
    map['total_amount_dis'] = totalAmountDis;
    map['contest_entry_fee'] = contestEntryFee;
    return map;
  }

}