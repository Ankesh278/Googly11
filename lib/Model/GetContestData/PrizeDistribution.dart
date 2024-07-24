class PrizeDistribution {
  final int prizeId;
  final int contestId;
  final int rankFrom;
  final int rankUpto;
  final String prizeAmount;
  final String amountInPercent;


  PrizeDistribution({
    required this.prizeId,
    required this.contestId,
    required this.rankFrom,
    required this.rankUpto,
    required this.prizeAmount,
    required this.amountInPercent,
  });

  factory PrizeDistribution.fromJson(Map<String, dynamic> json) {
    return PrizeDistribution(
      prizeId: json['prize_id'] ?? 0,
      contestId: json['contest_id'] ?? 0,
      rankFrom: json['rank_from'] ?? 0,
      rankUpto: json['rank_upto'] ?? 0,
      prizeAmount: json['prize_amount'] ?? '',
      amountInPercent: json['amount_in_percent'] ?? '',
    );
  }
}