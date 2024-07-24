
class MatchTransactionInfo {
  String? seriesName;
  String? matchFilterType;
  String? matchFormat;
  String? state;
  int? team1Id;
  String? team1Name;
  String? team1TeamSName;
  String? team1ImageUrl;
  int? team1ImageId;
  int? team2Id;
  String? team2Name;
  String? team2TeamSName;
  String? team2ImageUrl;
  int? team2ImageId;
  int? contestId;
  int? userId;
  int? teamId;
  int? rank;
  String? winnings;
  MatchTransactionInfo(
      {this.seriesName,
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
        this.contestId,
        this.userId,
        this.teamId,
        this.rank,
        this.winnings,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['series_name'] = this.seriesName;
    data['match_filter_type'] = this.matchFilterType;
    data['match_format'] = this.matchFormat;
    data['state'] = this.state;
    data['team1_id'] = this.team1Id;
    data['team1_name'] = this.team1Name;
    data['team1_teamSName'] = this.team1TeamSName;
    data['team1_image_url'] = this.team1ImageUrl;
    data['team1_imageId'] = this.team1ImageId;
    data['team2_id'] = this.team2Id;
    data['team2_name'] = this.team2Name;
    data['team2_teamSName'] = this.team2TeamSName;
    data['team2_image_url'] = this.team2ImageUrl;
    data['team2_imageId'] = this.team2ImageId;
    data['contest_id'] = this.contestId;
    data['user_id'] = this.userId;
    data['team_id'] = this.teamId;
    data['rank'] = this.rank;
    data['winnings'] = this.winnings;
    return data;
  }

  MatchTransactionInfo.fromJson(Map<String, dynamic> json) {
    seriesName = json['series_name'] ?? '';
    matchFilterType = json['match_filter_type'] ?? '';
    matchFormat = json['match_format'] ?? '';
    state = json['state'] ?? '';
    team1Id = json['team1_id'] ?? 0;
    team1Name = json['team1_name'] ?? '';
    team1TeamSName = json['team1_teamSName'] ?? 0;
    team1ImageUrl = json['team1_image_url'] ?? '';
    team1ImageId = json['team1_imageId'] ?? 0;
    team2Id = json['team2_id'] ?? 0;
    team2Name = json['team2_name'] ?? '';
    team2TeamSName = json['team2_teamSName']?? '';
    team2ImageUrl = json['team2_image_url'] ?? '';
    team2ImageId = json['team2_imageId'] ?? 0;
    contestId = json['contest_id'] ?? 0;
    userId = json['user_id'] ?? 0;
    teamId = json['team_id'] ?? 0;
    rank = json['rank']?? 0;
    winnings = json['winnings'] ?? 0;
  }
}
