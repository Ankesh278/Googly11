class Result {
  Result({
     required this.resultType,
    required this.winningTeam,
    required this.winningteamId,
    required this.winningMargin,
    required this.winByRuns,
    required this.winByInnings,});

  Result.fromJson(dynamic json) {
    resultType = json['resultType']?? '';
    winningTeam = json['winningTeam'] ?? '';
    winningteamId = json['winningteamId'] ?? 0;
    winningMargin = json['winningMargin'] ?? 0;
    winByRuns = json['winByRuns'] ?? false;
    winByInnings = json['winByInnings'] ?? false;
  }
  String resultType = '';
  String winningTeam = '' ;
  int winningteamId  = 0;
  int winningMargin  = 0;
  bool winByRuns  = false;
  bool winByInnings  = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['resultType'] = resultType;
    map['winningTeam'] = winningTeam;
    map['winningteamId'] = winningteamId;
    map['winningMargin'] = winningMargin;
    map['winByRuns'] = winByRuns;
    map['winByInnings'] = winByInnings;
    return map;
  }

}