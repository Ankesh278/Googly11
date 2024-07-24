class RankingsBowl {
  RankingsBowl({
     required this.odiBestRank,
    required this.t20BestRank,
    required this.testBestRank,});

  RankingsBowl.fromJson(dynamic json) {
    odiBestRank = json['odiBestRank'];
    t20BestRank = json['t20BestRank'];
    testBestRank = json['testBestRank'];
  }
  dynamic odiBestRank = '';
  dynamic t20BestRank = '';
  dynamic testBestRank = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['odiBestRank'] = odiBestRank;
    map['t20BestRank'] = t20BestRank;
    map['testBestRank'] = testBestRank;
    return map;
  }

}