class InningsScoreList {
  InningsScoreList({
   required this.inningsId,
    required this.batTeamId,
    required this.batTeamName,
    required this.score,
    required  this.wickets,
    required this.overs,
    required this.isDeclared,
    required this.isFollowOn,
    required this.ballNbr,});

  InningsScoreList.fromJson(dynamic json) {
    inningsId = json['inningsId'] ?? 0;
    batTeamId = json['batTeamId'] ?? 0;
    batTeamName = json['batTeamName'] ?? '';
    score = json['score'] ?? 0;
    wickets = json['wickets'] ?? 0;
    overs = json['overs'] ?? 0.0;
    isDeclared = json['isDeclared'] ?? false;
    isFollowOn = json['isFollowOn'] ?? false;
    ballNbr = json['ballNbr'] ?? 0;
  }
  dynamic inningsId = 0;
  dynamic batTeamId = 0;
  String batTeamName = '';
  dynamic score = 0;
  dynamic wickets=0 ;
  dynamic overs = 0.0;
  bool isDeclared = false;
  bool isFollowOn = false;
  dynamic ballNbr =0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inningsId'] = inningsId;
    map['batTeamId'] = batTeamId;
    map['batTeamName'] = batTeamName;
    map['score'] = score;
    map['wickets'] = wickets;
    map['overs'] = overs;
    map['isDeclared'] = isDeclared;
    map['isFollowOn'] = isFollowOn;
    map['ballNbr'] = ballNbr;
    return map;
  }

}