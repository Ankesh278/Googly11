class PrizeDistributions {
  PrizeDistributions({
     required this.prizeId,
    required this.contestId,
    required  this.rankFrom,
    required this.rankUpto,
    required this.prizeAmount,});

  PrizeDistributions.fromJson(dynamic json) {
    prizeId = json['prize_id'] ?? 0;
    contestId = json['contest_id'] ?? 0;
    rankFrom = json['rank_from'] ?? 0;
    rankUpto = json['rank_upto'] ?? 0;
    prizeAmount = json['prize_amount'] ?? '';
  }
  int prizeId = 0 ;
  int contestId = 0;
  int rankFrom = 0;
  int rankUpto = 0;
  dynamic prizeAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['prize_id'] = prizeId;
    map['contest_id'] = contestId;
    map['rank_from'] = rankFrom;
    map['rank_upto'] = rankUpto;
    map['prize_amount'] = prizeAmount;
    return map;
  }

}