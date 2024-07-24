class Results {
  Results({
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
    this.eventHomeRr,
    this.eventAwayRr,
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
    required this.eventHomeTeamLogo,
    required this.eventAwayTeamLogo,
    required this.scorecard,
    required this.comments,
    required this.wickets,
    required this.extra,
    required this.lineups,
    required this.commentsData,
    required this.extraData,
    required this.lineupsData,
    required this.scorecardData,
    required this.wicketsData
  });

  Results.fromJson(Map<String, dynamic> json) {
    eventKey = json['event_key'] ?? "";
    eventDateStart = json['event_date_start'] ?? "";
    eventDateStop = json['event_date_stop'] ?? "";
    eventTime = json['event_time'] ?? "";
    eventHomeTeam = json['event_home_team'] ?? "";
    homeTeamKey = json['home_team_key'] ?? "";
    eventAwayTeam = json['event_away_team'] ?? "";
    awayTeamKey = json['away_team_key'] ?? "";
    eventServiceHome = json['event_service_home'] ?? "";
    eventServiceAway = json['event_service_away'] ?? "";
    eventHomeFinalResult = json['event_home_final_result'] ?? "";
    eventAwayFinalResult = json['event_away_final_result'] ?? "";
    eventHomeRr = json['event_home_rr'];
    eventAwayRr = json['event_away_rr'];
    eventStatus = json['event_status'] ?? "";
    eventStatusInfo = json['event_status_info'] ?? "";
    leagueName = json['league_name'] ?? "";
    leagueKey = json['league_key'] ?? "";
    leagueRound = json['league_round'] ?? "";
    leagueSeason = json['league_season'] ?? "";
    eventLive = json['event_live'] ?? "";
    eventType = json['event_type'] ?? "";
    eventToss = json['event_toss'] ?? "";
    eventManOfMatch = json['event_man_of_match'] ?? "";
    eventStadium = json['event_stadium'] ?? "";
    eventHomeTeamLogo = json['event_home_team_logo'] ?? "";
    eventAwayTeamLogo = json['event_away_team_logo'] ?? "";



    if (json['scorecard'] != null && json['scorecard'] is List) {
      scorecard = List<Map<String, dynamic>>.from(json['scorecard'])
          .map((v) => InningData.fromJson(v))
          .toList();
    } else
      // if(json['scorecard'] != null && json['scorecard'] is Map)
      {
        scorecard=[];
      //   print("Scorecard::::");
      // scorecardData= Scorecard.fromJson(json['scorecard']);
    }

    if (json['comments'] != null && json['comments'] is List) {
      comments = List<Map<String, dynamic>>.from(json['comments'])
          .map((v) => Comment.fromJson(v))
          .toList();
    } else
      // if(json['comments'] != null && json['comments'] is Map)
      {
        comments=[];
      // commentsData= Comment.fromJson(json['comments']);
    }

    if (json['wickets'] != null && json['wickets'] is List) {
      wickets = List<Map<String, dynamic>>.from(json['wickets'])
          .map((v) => Wicket.fromJson(v))
          .toList();
    } else
      // if(json['wickets'] != null && json['wickets'] is Map)
      {
        wickets=[];
      // wicketsData= Wicket.fromJson(json['wickets']);
    }

    if (json['extra'] != null && json['extra'] is List) {
      extra = List<Map<String, dynamic>>.from(json['extra'])
          .map((v) => Extra.fromJson(v))
          .toList();
    } else
      // if(json['extra'] != null && json['extra'] is Map)
      {
        extra=[];
      // extraData= Extra.fromJson(json['extra']);
    }

    if (json['lineups'] != null && json['lineups'] is List) {
      lineups = List<Map<String, dynamic>>.from(json['lineups'])
          .map((v) => Lineup.fromJson(v))
          .toList();
    } else
      // if(json['lineups'] != null && json['lineups'] is Map)
      {
        lineups=[];
      // lineupsData= Lineup.fromJson(json['lineups']);
    }
  }


  String eventKey = "";
  String eventDateStart = "";
  String eventDateStop = "";
  String eventTime = "";
  String eventHomeTeam = "";
  String homeTeamKey = "";
  String eventAwayTeam = "";
  String awayTeamKey = "";
  String eventServiceHome = "";
  String eventServiceAway = "";
  String eventHomeFinalResult = "";
  String eventAwayFinalResult = "";
  dynamic eventHomeRr;
  dynamic eventAwayRr;
  String eventStatus = "";
  String eventStatusInfo = "";
  String leagueName = "";
  String leagueKey = "";
  String leagueRound = "";
  String leagueSeason = "";
  String eventLive = "";
  String eventType = "";
  String eventToss = "";
  String eventManOfMatch = "";
  String eventStadium = "";
    String eventHomeTeamLogo = "";
  String eventAwayTeamLogo = "";
  List<InningData> scorecard = [] ;
  List<Comment> comments = [];
  List<Wicket> wickets = [];
  List<Extra> extra = [];
  List<Lineup> lineups = [];
  Scorecard? scorecardData;
  Comment? commentsData;
  Wicket? wicketsData;
  Extra? extraData;
  Lineup? lineupsData;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['event_key'] = eventKey;
    map['event_date_start'] = eventDateStart;
    map['event_date_stop'] = eventDateStop;
    map['event_time'] = eventTime;
    map['event_home_team'] = eventHomeTeam;
    map['home_team_key'] = homeTeamKey;
    map['event_away_team'] = eventAwayTeam;
    map['away_team_key'] = awayTeamKey;
    map['event_service_home'] = eventServiceHome;
    map['event_service_away'] = eventServiceAway;
    map['event_home_final_result'] = eventHomeFinalResult;
    map['event_away_final_result'] = eventAwayFinalResult;
    map['event_home_rr'] = eventHomeRr;
    map['event_away_rr'] = eventAwayRr;
    map['event_status'] = eventStatus;
    map['event_status_info'] = eventStatusInfo;
    map['league_name'] = leagueName;
    map['league_key'] = leagueKey;
    map['league_round'] = leagueRound;
    map['league_season'] = leagueSeason;
    map['event_live'] = eventLive;
    map['event_type'] = eventType;
    map['event_toss'] = eventToss;
    map['event_man_of_match'] = eventManOfMatch;
    map['event_stadium'] = eventStadium;
    map['event_home_team_logo'] = eventHomeTeamLogo;
    map['event_away_team_logo'] = eventAwayTeamLogo;
    map['scorecard'] = scorecard.map((v) => v.toJson()).toList();
    map['comments'] = comments.map((v) => v.toJson()).toList();
    map['wickets'] = wickets.map((v) => v.toJson()).toList();
    map['extra'] = extra.map((v) => v.toJson()).toList();
    map['lineups'] = lineups.map((v) => v.toJson()).toList();
    return map;
  }
}

class Scorecard {
  Map<String, List<InningData>> inningsData;
  // List<dynamic> Tasmania_INN1;
  // List<dynamic> Tasmania_INN2;

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
  dynamic innings;
  dynamic player;
  dynamic type;
  dynamic status;
  dynamic r;
  dynamic b;
  dynamic min;
  dynamic s4;
  dynamic s6;
  dynamic o;
  dynamic m;
  dynamic w;
  dynamic sr;
  dynamic er;

  InningData({
    required this.innings,
    required this.player,
    required this.type,
    required this.status,
    required this.r,
    required this.b,
    required this.min,
    required this.s4,
    required this.s6,
    required this.o,
    required this.m,
    required this.w,
    required this.sr,
    required this.er,
  });

  factory InningData.fromJson(Map<String, dynamic> json) {
    return InningData(
      innings: json['innings'] ?? "",
      player: json['player'] ?? "",
      type: json['type'] ?? "",
      status: json['status'] ?? "",
      r: json['R'] ?? "",
      b: json['B'] ?? "",
      min: json['Min'] ?? "",
      s4: json['4s'] ?? "",
      s6: json['6s'] ?? "",
      o: json['O'] ?? "",
      m: json['M'] ?? "",
      w: json['W'] ?? "",
      sr: json['SR'] ?? "",
      er: json['ER'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['innings'] = innings;
    map['player'] = player;
    map['type'] = type;
    map['status'] = status;
    map['R'] = r;
    map['B'] = b;
    map['Min'] = min;
    map['4s'] = s4;
    map['6s'] = s6;
    map['O'] = o;
    map['M'] = m;
    map['W'] = w;
    map['SR'] = sr;
    map['ER'] = er;
    return map;
  }

}

class Comment {
  dynamic innings;
  dynamic balls;
  dynamic overs;
  dynamic ended;
  dynamic runs;
  dynamic post;

  Comment({
    required this.innings,
    required this.balls,
    required this.overs,
    required this.ended,
    required this.runs,
    required this.post,
  });

  factory Comment.fromJson(Map<dynamic, dynamic> json) {
    return Comment(
      innings: json['innings']?? "",
      balls: json['balls'] ?? "",
      overs: json['overs'] ?? "",
      ended: json['ended'] ?? "",
      runs: json['runs'] ?? "",
      post: json['post'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['innings'] = innings;
    map['balls'] = balls;
    map['overs'] = overs;
    map['ended'] = ended;
    map['runs'] = runs;
    map['post'] = post;
    return map;
  }


}

class Wicket {
  dynamic innings;
  dynamic fall;
  dynamic balwer;
  dynamic batsman;
  dynamic score;

  Wicket({
    required this.innings,
    required this.fall,
    required this.balwer,
    required this.batsman,
    required this.score,
  });

  factory Wicket.fromJson(Map<dynamic, dynamic> json) {
    return Wicket(
      innings: json['innings'] ?? "",
      fall: json['fall'] ?? "",
      balwer: json['balwer'] ?? "",
      batsman: json['batsman'] ?? "",
      score: json['score'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['innings'] = innings;
    map['fall'] = fall;
    map['balwer'] = balwer;
    map['batsman'] = batsman;
    map['score'] = score;
    return map;
  }

}

class Extra {
  dynamic innings;
  dynamic nr;
  dynamic text;
  dynamic totalOvers;
  dynamic total;
  dynamic percentOver;

  Extra({
    required this.innings,
    required this.nr,
    required this.text,
    required this.totalOvers,
    required this.total,
    required this.percentOver,
  });

  factory Extra.fromJson(Map<dynamic, dynamic> json) {
    return Extra(
      innings: json['innings'] ?? "",
      nr: json['nr'] ?? "",
      text: json['text'] ?? "",
      totalOvers: json['total_overs'] ?? "",
      total: json['total'] ?? "",
      percentOver: json['percent_over'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['innings'] = innings;
    map['nr'] = nr;
    map['text'] = text;
    map['total_overs'] = totalOvers;
    map['total'] = total;
    map['percent_over'] = percentOver;
    return map;
  }

}

class Lineup {
  HomeTeam homeTeam;
  AwayTeam awayTeam;

  Lineup({required this.homeTeam, required this.awayTeam});

  factory Lineup.fromJson(Map<dynamic, dynamic> json) {
    return Lineup(
      homeTeam: HomeTeam.fromJson(json['home_team'] ?? "") ,
      awayTeam: AwayTeam.fromJson(json['away_team'] ?? ""),
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['home_team'] = homeTeam.toJson();
    map['away_team'] = awayTeam.toJson();
    return map;
  }

}

class HomeTeam {
  List<PlayerData> startingLineups;

  HomeTeam({required this.startingLineups});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['starting_lineups'] =
        startingLineups.map((playerData) => playerData.toJson()).toList();
    return map;
  }
  factory HomeTeam.fromJson(Map<dynamic, dynamic> json) {
    return HomeTeam(
      startingLineups: List<PlayerData>.from(
          json['starting_lineups'].map((playerData) => PlayerData.fromJson(playerData))),
    );
  }
}

class AwayTeam {
  List<PlayerData> startingLineups;

  AwayTeam({required this.startingLineups});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['starting_lineups'] =
        startingLineups.map((playerData) => playerData.toJson()).toList();
    return map;
  }
  factory AwayTeam.fromJson(Map<dynamic, dynamic> json) {
    return AwayTeam(
      startingLineups: List<PlayerData>.from(
          json['starting_lineups'].map((playerData) => PlayerData.fromJson(playerData))),
    );
  }
}


class PlayerData {
  String player;

  PlayerData({required this.player});
  factory PlayerData.fromJson(Map<dynamic, dynamic> json) {
    return PlayerData(
      player: json['player'] ?? "",
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['player'] = player;
    return map;
  }
}


