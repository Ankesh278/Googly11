class CricketMatch {
  String eventKey;
  String eventDateStart;
  String eventDateStop;
  String eventTime;
  String eventHomeTeam;
  String homeTeamKey;
  String eventAwayTeam;
  String awayTeamKey;
  String eventServiceHome;
  String eventServiceAway;
  String eventHomeFinalResult;
  String eventAwayFinalResult;
  String eventHomeRR;
  String eventAwayRR;
  String eventStatus;
  String eventStatusInfo;
  String leagueName;
  String leagueKey;
  String leagueRound;
  String leagueSeason;
  String eventLive;
  String eventType;
  String eventToss;
  String eventManOfMatch;
  String eventStadium;
  String? eventHomeTeamLogo;
  String? eventAwayTeamLogo;
  Scorecard scorecard;
  Comments comments;
  Extra extra;
  Lineups lineups;

  CricketMatch({
    required this.eventKey,
    required this.eventDateStart,
    required this.eventDateStop,
    required this.eventTime,
    required this.eventHomeTeam,
    required this.homeTeamKey,
    required this.eventAwayTeam,
    required this.awayTeamKey,
    required this.eventServiceHome,
    required this.eventServiceAway,
    required this.eventHomeFinalResult,
    required this.eventAwayFinalResult,
    required this.eventHomeRR,
    required this.eventAwayRR,
    required this.eventStatus,
    required this.eventStatusInfo,
    required this.leagueName,
    required this.leagueKey,
    required this.leagueRound,
    required this.leagueSeason,
    required this.eventLive,
    required this.eventType,
    required this.eventToss,
    required this.eventManOfMatch,
    required this.eventStadium,
    this.eventHomeTeamLogo,
    this.eventAwayTeamLogo,
    required this.scorecard,
    required this.comments,
    required this.extra,
    required this.lineups,
  });

  factory CricketMatch.fromJson(Map<String, dynamic> json) {
    return CricketMatch(
      eventKey: json['event_key'],
      eventDateStart: json['event_date_start'],
      eventDateStop: json['event_date_stop'],
      eventTime: json['event_time'],
      eventHomeTeam: json['event_home_team'],
      homeTeamKey: json['home_team_key'],
      eventAwayTeam: json['event_away_team'],
      awayTeamKey: json['away_team_key'],
      eventServiceHome: json['event_service_home'],
      eventServiceAway: json['event_service_away'],
      eventHomeFinalResult: json['event_home_final_result'],
      eventAwayFinalResult: json['event_away_final_result'],
      eventHomeRR: json['event_home_rr'],
      eventAwayRR: json['event_away_rr'],
      eventStatus: json['event_status'],
      eventStatusInfo: json['event_status_info'],
      leagueName: json['league_name'],
      leagueKey: json['league_key'],
      leagueRound: json['league_round'],
      leagueSeason: json['league_season'],
      eventLive: json['event_live'],
      eventType: json['event_type'],
      eventToss: json['event_toss'],
      eventManOfMatch: json['event_man_of_match'],
      eventStadium: json['event_stadium'],
      eventHomeTeamLogo: json['event_home_team_logo'],
      eventAwayTeamLogo: json['event_away_team_logo'],
      scorecard: Scorecard.fromJson(json['scorecard']),
      comments: Comments.fromJson(json['comments']),
      extra: Extra.fromJson(json['extra']),
      lineups: Lineups.fromJson(json['lineups']),
    );
  }
}

class Scorecard {
  Map<String, List<InningData>> inningsData;

  Scorecard({
    required this.inningsData,
  });

  factory Scorecard.fromJson(Map<String, dynamic> json) {
    final inningsData = json.map((key, value) {
      final List<InningData> dataList =
      List<InningData>.from(value.map((x) => InningData.fromJson(x)));
      return MapEntry(key, dataList);
    });

    return Scorecard(inningsData: inningsData);
  }
}

class InningData {
  String innings;
  String player;
  String type;
  String status;
  String R;
  String B;
  String Min;
  String? s4;
  String? s6;
  String? O;
  String? M;
  String? W;
  String SR;
  String? ER;

  InningData({
    required this.innings,
    required this.player,
    required this.type,
    required this.status,
    required this.R,
    required this.B,
    required this.Min,
    String? s4,
    String? s6,
    String? O,
    String? M,
    String? W,
    required this.SR,
    String? ER,
  })  : s4 = s4 ?? "0",
        s6 = s6 ?? "0",
        O = O ?? "0",
        M = M ?? "0",
        W = W ?? "0",
        ER = ER ?? "0";

  factory InningData.fromJson(Map<String, dynamic> json) {
    return InningData(
      innings: json['innings'],
      player: json['player'],
      type: json['type'],
      status: json['status'],
      R: json['R'],
      B: json['B'],
      Min: json['Min'],
      s4: json['4s'],
      s6: json['6s'],
      O: json['O'],
      M: json['M'],
      W: json['W'],
      SR: json['SR'],
      ER: json['ER'],
    );
  }
}

class Comments {
  Map<String, List<CommentData>> commentData;

  Comments({
    required this.commentData,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    final commentData = json.map((key, value) {
      final List<CommentData> dataList =
      List<CommentData>.from(value.map((x) => CommentData.fromJson(x)));
      return MapEntry(key, dataList);
    });

    return Comments(commentData: commentData);
  }
}

class CommentData {
  String innings;
  String balls;
  String overs;
  String ended;
  String runs;
  String post;

  CommentData({
    required this.innings,
    required this.balls,
    required this.overs,
    required this.ended,
    required this.runs,
    required this.post,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      innings: json['innings'],
      balls: json['balls'],
      overs: json['overs'],
      ended: json['ended'],
      runs: json['runs'],
      post: json['post'],
    );
  }
}

class Extra {
  Map<String, List<ExtraData>> extraData;

  Extra({
    required this.extraData,
  });

  factory Extra.fromJson(Map<String, dynamic> json) {
    final extraData = json.map((key, value) {
      final List<ExtraData> dataList =
      List<ExtraData>.from(value.map((x) => ExtraData.fromJson(x)));
      return MapEntry(key, dataList);
    });

    return Extra(extraData: extraData);
  }
}

class ExtraData {
  String innings;
  String nr;
  String text;
  String totalOvers;
  String total;
  String? percentOver;

  ExtraData({
    required this.innings,
    required this.nr,
    required this.text,
    required this.totalOvers,
    required this.total,
    this.percentOver,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(
      innings: json['innings'],
      nr: json['nr'],
      text: json['text'],
      totalOvers: json['total_overs'],
      total: json['total'],
      percentOver: json['percent_over'],
    );
  }
}

class Lineups {
  Lineup homeTeam;
  Lineup awayTeam;

  Lineups({
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Lineups.fromJson(Map<String, dynamic> json) {
    return Lineups(
      homeTeam: Lineup.fromJson(json['home_team']),
      awayTeam: Lineup.fromJson(json['away_team']),
    );
  }
}

class Lineup {
  List<LineupPlayer> startingLineups;

  Lineup({
    required this.startingLineups,
  });

  factory Lineup.fromJson(Map<String, dynamic> json) {
    final startingLineups = json['starting_lineups'].map<LineupPlayer>((item) {
      return LineupPlayer.fromJson(item);
    }).toList();

    return Lineup(startingLineups: startingLineups);
  }
}

class LineupPlayer {
  String player;

  LineupPlayer({
    required this.player,
  });

  factory LineupPlayer.fromJson(Map<String, dynamic> json) {
    return LineupPlayer(player: json['player']);
  }
}
