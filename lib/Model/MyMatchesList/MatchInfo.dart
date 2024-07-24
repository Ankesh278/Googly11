class MatchInfo {
  MatchInfo({
      this.seriesName, 
      this.matchFilterType, 
      this.matchFormat, 
      this.state, 
      this.team1Id, 
      this.team1Name, 
      this.team1TeamSName, 
      this.team1ImageUrl, 
      this.team1ImageId, 
      this.team2Id, 
      this.team2Name, 
      this.team2TeamSName, 
      this.team2ImageUrl, 
      this.team2ImageId, 
      this.matchId,
    this.contest_id,
     this.start_date,
      this.userTeamId, 
      this.tolatCreatTeams,
       this.is_lineupOut,
      this.totalJoinContest, 
      this.winnings,});

  MatchInfo.fromJson(dynamic json) {
    seriesName = json['series_name'] ?? '';
    matchFilterType = json['match_filter_type'] ?? '';
    matchFormat = json['match_format'] ?? '';
    state = json['state'] ?? '';
    team1Id = json['team1_id'] ?? 0;
    team1Name = json['team1_name'] ?? '';
    start_date = json['start_date'] ?? '';
    is_lineupOut = json['is_lineupOut'] ?? 0;
    team1TeamSName = json['team1_teamSName'] ?? '';
    team1ImageUrl = json['team1_image_url'] ?? '';
    team1ImageId = json['team1_imageId'] ?? 0;
    contest_id = json['contest_id'] ?? 0;
    team2Id = json['team2_id'] ?? 0;
    team2Name = json['team2_name'] ?? '';
    team2TeamSName = json['team2_teamSName'] ?? '';
    team2ImageUrl = json['team2_image_url'] ?? '';
    team2ImageId = json['team2_imageId'] ?? 0;
    matchId = json['match_id'] ?? 0;
    userTeamId = json['UserTeamId'] ?? 0;
    tolatCreatTeams = json['tolatCreatTeams'] ?? 0;
    totalJoinContest = json['totalJoinContest'] ?? 0;
    winnings = json['winnings'] ?? 0;
  }
  String? seriesName;
  String? matchFilterType;
  String? matchFormat;
  String? state;
  String? start_date;
  int? team1Id;
  int? is_lineupOut;
  String? team1Name;
  String? team1TeamSName;
  String? team1ImageUrl;
  int? team1ImageId;
  int? contest_id;
  int? team2Id;
  String? team2Name;
  String? team2TeamSName;
  String? team2ImageUrl;
  int? team2ImageId;
  int? matchId;
  int? userTeamId;
  int? tolatCreatTeams;
  int? totalJoinContest;
  dynamic winnings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['series_name'] = seriesName;
    map['match_filter_type'] = matchFilterType;
    map['match_format'] = matchFormat;
    map['state'] = state;
    map['team1_id'] = team1Id;
    map['start_date'] = start_date;
    map['team1_name'] = team1Name;
    map['team1_teamSName'] = team1TeamSName;
    map['team1_image_url'] = team1ImageUrl;
    map['team1_imageId'] = team1ImageId;
    map['team2_id'] = team2Id;
    map['team2_name'] = team2Name;
    map['team2_teamSName'] = team2TeamSName;
    map['team2_image_url'] = team2ImageUrl;
    map['team2_imageId'] = team2ImageId;
    map['match_id'] = matchId;
    map['UserTeamId'] = userTeamId;
    map['contest_id'] = contest_id;
    map['tolatCreatTeams'] = tolatCreatTeams;
    map['totalJoinContest'] = totalJoinContest;
    map['winnings'] = winnings;
    return map;
  }

}