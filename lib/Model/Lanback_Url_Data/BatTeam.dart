class BatTeam {
  dynamic teamId;
  dynamic teamScore;
  dynamic teamWkts;

  BatTeam({this.teamId, this.teamScore, this.teamWkts});

  BatTeam.fromJson(Map<String, dynamic> json) {
    teamId = json['teamId']?.toInt();
    teamScore = json['teamScore']?.toInt();
    teamWkts = json['teamWkts']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamId'] = this.teamId;
    data['teamScore'] = this.teamScore;
    data['teamWkts'] = this.teamWkts;
    return data;
  }
}
