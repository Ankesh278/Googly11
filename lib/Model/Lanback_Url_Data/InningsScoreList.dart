class InningsScoreList {
  dynamic inningsId;
  dynamic batTeamId;
  dynamic batTeamName;
  dynamic score;
  dynamic wickets;
  dynamic overs = 0.0;
  bool? isDeclared;
  bool? isFollowOn;
  dynamic ballNbr;

  InningsScoreList(
      {this.inningsId,
        this.batTeamId,
        this.batTeamName,
        this.score,
        this.wickets,
        required this.overs,
        this.isDeclared,
        this.isFollowOn,
        this.ballNbr});

  InningsScoreList.fromJson(Map<String, dynamic> json) {
    inningsId = json['inningsId'];
    batTeamId = json['batTeamId'];
    batTeamName = json['batTeamName'];
    score = json['score'];
    wickets = json['wickets'];
    overs = json['overs'];
    isDeclared = json['isDeclared'];
    isFollowOn = json['isFollowOn'];
    ballNbr = json['ballNbr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inningsId'] = this.inningsId;
    data['batTeamId'] = this.batTeamId;
    data['batTeamName'] = this.batTeamName;
    data['score'] = this.score;
    data['wickets'] = this.wickets;
    data['overs'] = this.overs;
    data['isDeclared'] = this.isDeclared;
    data['isFollowOn'] = this.isFollowOn;
    data['ballNbr'] = this.ballNbr;
    return data;
  }
}