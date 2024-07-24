class MatchTeamInfo {
  MatchTeamInfo({
     required this.battingTeamId,
    required this.battingTeamShortName,
    required this.bowlingTeamId,
    required this.bowlingTeamShortName,});

  MatchTeamInfo.fromJson(dynamic json) {
    battingTeamId = json['battingTeamId'] ?? 0;
    battingTeamShortName = json['battingTeamShortName'] ?? '';
    bowlingTeamId = json['bowlingTeamId'] ?? 0;
    bowlingTeamShortName = json['bowlingTeamShortName'] ?? '';
  }
  int battingTeamId = 0;
  String battingTeamShortName = '';
  int bowlingTeamId = 0;
  String bowlingTeamShortName = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['battingTeamId'] = battingTeamId;
    map['battingTeamShortName'] = battingTeamShortName;
    map['bowlingTeamId'] = bowlingTeamId;
    map['bowlingTeamShortName'] = bowlingTeamShortName;
    return map;
  }

}