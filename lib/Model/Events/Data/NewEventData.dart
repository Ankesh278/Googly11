class Welcome6 {
  Welcome6({
    required this.success,
    required this.result,
  });

  int success;
  List<Eventdata> result;
}

class Eventdata {
  Eventdata({
    required this.eventKey,
    required this.eventDateStart,
    required this.eventDateStop,
    required this.eventTime,
    required this.eventHomeTeam,
    required this.homeTeamKey,
    required this.eventAwayTeam,
    required this.awayTeamKey,
    required this.eventServiceHome,
    required  this.eventServiceAway,
    required this.eventHomeFinalResult,
    required this.eventAwayFinalResult,
    required this.eventHomeRr,
    required  this.eventAwayRr,
    required this.eventStatus,
    required this.eventStatusInfo,
    required this.leagueName,
    required this.leagueKey,
    required this.leagueRound,
    required this.leagueSeason,
    required this.eventLive,
    required this.eventType,
    required  this.eventToss,
    required  this.eventManOfMatch,
    required this.eventStadium,
    required  this.eventHomeTeamLogo,
    required  this.eventAwayTeamLogo,
    this.scorecard,
    this.comments,
    this.wickets,
    this.extra,
    this.lineups,
  });

  String eventKey;
  DateTime eventDateStart;
  DateTime eventDateStop;
  String eventTime;
  String eventHomeTeam;
  String homeTeamKey;
  String eventAwayTeam;
  String awayTeamKey;
  String eventServiceHome;
  String eventServiceAway;
  String eventHomeFinalResult;
  String eventAwayFinalResult;
  String eventHomeRr;
  String eventAwayRr;
  EventStatus eventStatus;
  String eventStatusInfo;
  String leagueName;
  String leagueKey;
  String leagueRound;
  String leagueSeason;
  String eventLive;
  EventType eventType;
  String eventToss;
  EventManOfMatch eventManOfMatch;
  String eventStadium;
  String eventHomeTeamLogo;
  String eventAwayTeamLogo;
  dynamic scorecard;
  dynamic comments;
  dynamic wickets;
  dynamic extra;
  dynamic lineups;
}

class Comment {
  Comment({
    required this.innings,
    required this.balls,
    required this.overs,
    required this.ended,
    required this.runs,
    required this.post,
  });

  Innings innings;
  String balls;
  String overs;
  Ended ended;
  String runs;
  String post;
}

enum Ended { NO, YES }

enum Innings { BANGLADESH_WOMEN_2_INN, GUYANA_AMAZON_WARRIORS_2_INN, INDIA_WOMEN_1_INN, PAKISTAN_WOMEN_1_INN, SRI_LANKA_WOMEN_2_INN, TASMANIA_1_INN, TRINBAGO_KNIGHT_RIDERS_1_INN, VICTORIA_2_INN, EASTERNS_2_INN, SOUTH_AFRICA_EMERGING_PLAYERS_1_INN }

enum EventManOfMatch { EMPTY, BEAU_WEBSTER, DWAINE_PRETORIUS }

enum EventStatus { ABANDONED, FINISHED, EMPTY }

enum EventType { ODI, T20 }

class ExtraElement {
  ExtraElement({
    required this.innings,
    required this.nr,
    required this.text,
    required this.totalOvers,
    required this.total,
    this.percentOver,
  });

  Innings innings;
  String nr;
  String text;
  String totalOvers;
  String total;
  dynamic percentOver;
}

class LineupsClass {
  LineupsClass({
    required this.homeTeam,
    required this.awayTeam,
  });

  Team homeTeam;
  Team awayTeam;
}

class Team {
  Team({
    required this.startingLineups,
  });

  List<StartingLineup> startingLineups;
}

class StartingLineup {
  StartingLineup({
    required this.player,
  });

  String player;
}

class ScorecardElement {
  ScorecardElement({
    required this.innings,
    required  this.player,
    required  this.type,
    required  this.status,
    required  this.r,
    required  this.b,
    required  this.min,
    required this.the4S,
    required this.the6S,
    required this.o,
    required this.m,
    required this.w,
    required  this.sr,
    required this.er,
  });

  Innings innings;
  String player;
  Type type;
  String status;
  String r;
  String b;
  String min;
  String the4S;
  String the6S;
  String o;
  String m;
  String w;
  String sr;
  String er;
}

enum Type { BATSMAN, BOWLER }

class Wicket {
  Wicket({
    required this.innings,
    required  this.fall,
    required  this.balwer,
    required  this.batsman,
    required this.score,
  });

  Innings innings;
  String fall;
  String balwer;
  String batsman;
  String score;
}
