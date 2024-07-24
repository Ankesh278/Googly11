class BatTeam {
  BatTeam({
     required this.teamId,
    required this.teamScore,
    required this.teamWkts,});

  BatTeam.fromJson(dynamic json) {
    teamId = json['teamId'] ?? 0;
    teamScore = json['teamScore'] ?? 0;
    teamWkts = json['teamWkts'] ?? 0;
  }
  dynamic teamId = 0;
  dynamic teamScore = 0;
  dynamic teamWkts =0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamId'] = teamId;
    map['teamScore'] = teamScore;
    map['teamWkts'] = teamWkts;
    return map;
  }

}