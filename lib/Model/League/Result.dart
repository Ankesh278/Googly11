class Result {
  Result({
      required this.leagueKey,
      required this.leagueName,
      required this.leagueYear,});

  Result.fromJson(dynamic json) {
    leagueKey = json['league_key'] ?? '';
    leagueName = json['league_name'] ?? '';
    leagueYear = json['league_year'] ?? '';
  }

  String leagueKey="";
  String leagueName ="";
  String leagueYear ="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['league_key'] = leagueKey;
    map['league_name'] = leagueName;
    map['league_year'] = leagueYear;
    return map;
  }

}