class LiveMatchScoreCardData {
  int? status;
  String? message;
  dynamic abandon;
  List<LiveScoreNewData>? data;

  LiveMatchScoreCardData({this.status, this.message, this.data});

  LiveMatchScoreCardData.fromJson(Map<String, dynamic> json) {
    status = json['status']?? 0;
    message = json['message'] ?? '';
    abandon = json['abandon'] ?? false;
    if (json['data'] != null) {
      data = <LiveScoreNewData>[];
      json['data'].forEach((v) {
        data!.add(new LiveScoreNewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status ;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiveScoreNewData {
  int? matchId;
  int? inningsId;
  int? timeScore;
  BatTeamDetails? batTeamDetails;
  BowlTeamDetails? bowlTeamDetails;
  ScoreDetails? scoreDetails;
  ExtrasData? extrasData;
  Null ppData;
  List<WicketsData>? wicketsData;
  List<PartnershipsData>? partnershipsData;

  LiveScoreNewData(
      {this.matchId,
        this.inningsId,
        this.timeScore,
        this.batTeamDetails,
        this.bowlTeamDetails,
        this.scoreDetails,
        this.extrasData,
        this.ppData,
        this.wicketsData,
        this.partnershipsData});

  LiveScoreNewData.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'] ?? 0;
    inningsId = json['inningsId'] ?? 0;
    timeScore = json['timeScore'] ?? 0;
    batTeamDetails = json['batTeamDetails'] != null
        ? new BatTeamDetails.fromJson(json['batTeamDetails'])
        : null;
    bowlTeamDetails = json['bowlTeamDetails'] != null
        ? new BowlTeamDetails.fromJson(json['bowlTeamDetails'])
        : null;
    scoreDetails = json['scoreDetails'] != null
        ? new ScoreDetails.fromJson(json['scoreDetails'])
        : null;
    extrasData = json['extrasData'] != null
        ? new ExtrasData.fromJson(json['extrasData'])
        : null;
    ppData = json['ppData'];
    if (json['wicketsData'] != null) {
      wicketsData = <WicketsData>[];
      json['wicketsData'].forEach((v) {
        wicketsData!.add(new WicketsData.fromJson(v));
      });
    }
    if (json['partnershipsData'] != null) {
      partnershipsData = <PartnershipsData>[];
      json['partnershipsData'].forEach((v) {
        partnershipsData!.add(new PartnershipsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matchId'] = this.matchId;
    data['inningsId'] = this.inningsId;
    data['timeScore'] = this.timeScore;
    if (this.batTeamDetails != null) {
      data['batTeamDetails'] = this.batTeamDetails!.toJson();
    }
    if (this.bowlTeamDetails != null) {
      data['bowlTeamDetails'] = this.bowlTeamDetails!.toJson();
    }
    if (this.scoreDetails != null) {
      data['scoreDetails'] = this.scoreDetails!.toJson();
    }
    if (this.extrasData != null) {
      data['extrasData'] = this.extrasData!.toJson();
    }
    data['ppData'] = this.ppData;
    if (this.wicketsData != null) {
      data['wicketsData'] = this.wicketsData!.map((v) => v.toJson()).toList();
    }
    if (this.partnershipsData != null) {
      data['partnershipsData'] =
          this.partnershipsData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BatTeamDetails {
  int? batTeamId;
  String? batTeamName;
  String? batTeamShortName;
  List<BatsmenData>? batsmenData;

  BatTeamDetails(
      {this.batTeamId,
        this.batTeamName,
        this.batTeamShortName,
        this.batsmenData});

  BatTeamDetails.fromJson(Map<String, dynamic> json) {
    batTeamId = json['batTeamId'] ?? 0;
    batTeamName = json['batTeamName'] ?? '';
    batTeamShortName = json['batTeamShortName'] ?? '';
    if (json['batsmenData'] != null) {
      batsmenData = <BatsmenData>[];
      json['batsmenData'].forEach((v) {
        batsmenData!.add(new BatsmenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batTeamId'] = this.batTeamId;
    data['batTeamName'] = this.batTeamName;
    data['batTeamShortName'] = this.batTeamShortName;
    if (this.batsmenData != null) {
      data['batsmenData'] = this.batsmenData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BatsmenData {
  int? batId;
  String? batName;
  String? batShortName;
  bool? isCaptain;
  bool? isKeeper;
  int? runs;
  int? balls;
  int? dots;
  int? fours;
  int? sixes;
  int? mins;
  dynamic strikeRate;
  String? outDesc;
  int? bowlerId;
  int? fielderId1;
  int? fielderId2;
  int? fielderId3;
  int? ones;
  int? twos;
  int? threes;
  int? fives;
  int? boundaries;
  int? sixers;
  String? wicketCode;
  bool? isOverseas;
  String? inMatchChange;
  String? playingXIChange;

  BatsmenData(
      {this.batId,
        this.batName,
        this.batShortName,
        this.isCaptain,
        this.isKeeper,
        this.runs,
        this.balls,
        this.dots,
        this.fours,
        this.sixes,
        this.mins,
        this.strikeRate,
        this.outDesc,
        this.bowlerId,
        this.fielderId1,
        this.fielderId2,
        this.fielderId3,
        this.ones,
        this.twos,
        this.threes,
        this.fives,
        this.boundaries,
        this.sixers,
        this.wicketCode,
        this.isOverseas,
        this.inMatchChange,
        this.playingXIChange});

  BatsmenData.fromJson(Map<String, dynamic> json) {
    batId = json['batId'] ?? 0;
    batName = json['batName'] ?? '';
    batShortName = json['batShortName'] ?? '';
    isCaptain = json['isCaptain'] ?? false;
    isKeeper = json['isKeeper'] ?? false;
    runs = json['runs'] ?? 0;
    balls = json['balls'] ?? 0;
    dots = json['dots'] ?? 0;
    fours = json['fours'] ?? 0;
    sixes = json['sixes'] ?? 0;
    mins = json['mins'] ?? 0;
    strikeRate = json['strikeRate'] ?? 0;
    outDesc = json['outDesc'] ?? '';
    bowlerId = json['bowlerId'] ?? 0;
    fielderId1 = json['fielderId1']  ?? 0;
    fielderId2 = json['fielderId2'] ?? 0;
    fielderId3 = json['fielderId3'] ?? 0;
    ones = json['ones'] ?? 0;
    twos = json['twos'] ?? 0;
    threes = json['threes'] ?? 0;
    fives = json['fives'] ?? 0;
    boundaries = json['boundaries'] ?? 0;
    sixers = json['sixers']  ?? 0;
    wicketCode = json['wicketCode']  ?? '';
    isOverseas = json['isOverseas'] ?? false;
    inMatchChange = json['inMatchChange']?? '';
    playingXIChange = json['playingXIChange']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batId'] = this.batId;
    data['batName'] = this.batName;
    data['batShortName'] = this.batShortName;
    data['isCaptain'] = this.isCaptain;
    data['isKeeper'] = this.isKeeper;
    data['runs'] = this.runs;
    data['balls'] = this.balls;
    data['dots'] = this.dots;
    data['fours'] = this.fours;
    data['sixes'] = this.sixes;
    data['mins'] = this.mins;
    data['strikeRate'] = this.strikeRate;
    data['outDesc'] = this.outDesc;
    data['bowlerId'] = this.bowlerId;
    data['fielderId1'] = this.fielderId1;
    data['fielderId2'] = this.fielderId2;
    data['fielderId3'] = this.fielderId3;
    data['ones'] = this.ones;
    data['twos'] = this.twos;
    data['threes'] = this.threes;
    data['fives'] = this.fives;
    data['boundaries'] = this.boundaries;
    data['sixers'] = this.sixers;
    data['wicketCode'] = this.wicketCode;
    data['isOverseas'] = this.isOverseas;
    data['inMatchChange'] = this.inMatchChange;
    data['playingXIChange'] = this.playingXIChange;
    return data;
  }
}

class BowlTeamDetails {
  int? bowlTeamId;
  String? bowlTeamName;
  String? bowlTeamShortName;
  List<BowlersData>? bowlersData;

  BowlTeamDetails(
      {this.bowlTeamId,
        this.bowlTeamName,
        this.bowlTeamShortName,
        this.bowlersData});

  BowlTeamDetails.fromJson(Map<String, dynamic> json) {
    bowlTeamId = json['bowlTeamId'] ?? 0;
    bowlTeamName = json['bowlTeamName'] ?? '';
    bowlTeamShortName = json['bowlTeamShortName'] ?? '';
    if (json['bowlersData'] != null) {
      bowlersData = <BowlersData>[];
      json['bowlersData'].forEach((v) {
        bowlersData!.add(new BowlersData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowlTeamId'] = this.bowlTeamId;
    data['bowlTeamName'] = this.bowlTeamName;
    data['bowlTeamShortName'] = this.bowlTeamShortName;
    if (this.bowlersData != null) {
      data['bowlersData'] = this.bowlersData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BowlersData {
  int? bowlerId;
  String? bowlName;
  String? bowlShortName;
  bool? isCaptain;
  bool? isKeeper;
  dynamic overs;
  int? maidens;
  int? runs;
  int? wickets;
  dynamic economy;
  int? noBalls;
  int? wides;
  int? dots;
  int? balls;
  dynamic runsPerBall;
  bool? isOverseas;
  String? inMatchChange;
  String? playingXIChange;

  BowlersData(
      {this.bowlerId,
        this.bowlName,
        this.bowlShortName,
        this.isCaptain,
        this.isKeeper,
        this.overs,
        this.maidens,
        this.runs,
        this.wickets,
        this.economy,
        this.noBalls,
        this.wides,
        this.dots,
        this.balls,
        this.runsPerBall,
        this.isOverseas,
        this.inMatchChange,
        this.playingXIChange});

  BowlersData.fromJson(Map<String, dynamic> json) {
    bowlerId = json['bowlerId']?? 0;
    bowlName = json['bowlName'] ?? '';
    bowlShortName = json['bowlShortName'] ?? '';
    isCaptain = json['isCaptain']  ?? false;
    isKeeper = json['isKeeper']  ?? false;
    overs = json['overs']  ?? 0;
    maidens = json['maidens']  ?? 0;
    runs = json['runs'] ?? 0;
    wickets = json['wickets'] ?? 0;
    economy = json['economy']  ?? 0;
    noBalls = json['no_balls'] ?? 0 ;
    wides = json['wides'] ?? 0;
    dots = json['dots'] ?? 0;
    balls = json['balls'] ?? 0;
    runsPerBall = json['runsPerBall']  ?? 0;
    isOverseas = json['isOverseas'] ;
    inMatchChange = json['inMatchChange'];
    playingXIChange = json['playingXIChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowlerId'] = this.bowlerId;
    data['bowlName'] = this.bowlName;
    data['bowlShortName'] = this.bowlShortName;
    data['isCaptain'] = this.isCaptain;
    data['isKeeper'] = this.isKeeper;
    data['overs'] = this.overs;
    data['maidens'] = this.maidens;
    data['runs'] = this.runs;
    data['wickets'] = this.wickets;
    data['economy'] = this.economy;
    data['no_balls'] = this.noBalls;
    data['wides'] = this.wides;
    data['dots'] = this.dots;
    data['balls'] = this.balls;
    data['runsPerBall'] = this.runsPerBall;
    data['isOverseas'] = this.isOverseas;
    data['inMatchChange'] = this.inMatchChange;
    data['playingXIChange'] = this.playingXIChange;
    return data;
  }
}

class ScoreDetails {
  int? ballNbr;
  bool? isDeclared;
  bool? isFollowOn;
  dynamic overs;
  dynamic revisedOvers;
  dynamic runRate;
  int? runs;
  int? wickets;
  dynamic runsPerBall;

  ScoreDetails(
      {this.ballNbr,
        this.isDeclared,
        this.isFollowOn,
        this.overs,
        this.revisedOvers,
        this.runRate,
        this.runs,
        this.wickets,
        this.runsPerBall});

  ScoreDetails.fromJson(Map<String, dynamic> json) {
    ballNbr = json['ballNbr'];
    isDeclared = json['isDeclared'];
    isFollowOn = json['isFollowOn'];
    overs = json['overs'];
    revisedOvers = json['revisedOvers'];
    runRate = json['runRate'];
    runs = json['runs'];
    wickets = json['wickets'];
    runsPerBall = json['runsPerBall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ballNbr'] = this.ballNbr;
    data['isDeclared'] = this.isDeclared;
    data['isFollowOn'] = this.isFollowOn;
    data['overs'] = this.overs;
    data['revisedOvers'] = this.revisedOvers;
    data['runRate'] = this.runRate;
    data['runs'] = this.runs;
    data['wickets'] = this.wickets;
    data['runsPerBall'] = this.runsPerBall;
    return data;
  }
}

class ExtrasData {
  int? noBalls;
  int? total;
  int? byes;
  int? penalty;
  int? wides;
  int? legByes;

  ExtrasData(
      {this.noBalls,
        this.total,
        this.byes,
        this.penalty,
        this.wides,
        this.legByes});

  ExtrasData.fromJson(Map<String, dynamic> json) {
    noBalls = json['noBalls'];
    total = json['total'];
    byes = json['byes'];
    penalty = json['penalty'];
    wides = json['wides'];
    legByes = json['legByes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noBalls'] = this.noBalls;
    data['total'] = this.total;
    data['byes'] = this.byes;
    data['penalty'] = this.penalty;
    data['wides'] = this.wides;
    data['legByes'] = this.legByes;
    return data;
  }
}

class WicketsData {
  int? batId;
  String? batName;
  int? wktNbr;
  dynamic wktOver;
  int? wktRuns;
  int? ballNbr;

  WicketsData(
      {this.batId,
        this.batName,
        this.wktNbr,
        this.wktOver,
        this.wktRuns,
        this.ballNbr});

  WicketsData.fromJson(Map<String, dynamic> json) {
    batId = json['batId'];
    batName = json['batName'];
    wktNbr = json['wktNbr'];
    wktOver = json['wktOver'];
    wktRuns = json['wktRuns'];
    ballNbr = json['ballNbr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batId'] = this.batId;
    data['batName'] = this.batName;
    data['wktNbr'] = this.wktNbr;
    data['wktOver'] = this.wktOver;
    data['wktRuns'] = this.wktRuns;
    data['ballNbr'] = this.ballNbr;
    return data;
  }
}

class PartnershipsData {
  int? bat1Id;
  String? bat1Name;
  int? bat1Runs;
  int? bat1fours;
  int? bat1sixes;
  int? bat2Id;
  String? bat2Name;
  int? bat2Runs;
  int? bat2fours;
  int? bat2sixes;
  int? totalRuns;
  int? totalBalls;
  int? bat1balls;
  int? bat2balls;
  int? bat1Ones;
  int? bat1Twos;
  int? bat1Threes;
  int? bat1Fives;
  int? bat1Boundaries;
  int? bat1Sixers;
  int? bat2Ones;
  int? bat2Twos;
  int? bat2Threes;
  int? bat2Fives;
  int? bat2Boundaries;
  int? bat2Sixers;

  PartnershipsData(
      {this.bat1Id,
        this.bat1Name,
        this.bat1Runs,
        this.bat1fours,
        this.bat1sixes,
        this.bat2Id,
        this.bat2Name,
        this.bat2Runs,
        this.bat2fours,
        this.bat2sixes,
        this.totalRuns,
        this.totalBalls,
        this.bat1balls,
        this.bat2balls,
        this.bat1Ones,
        this.bat1Twos,
        this.bat1Threes,
        this.bat1Fives,
        this.bat1Boundaries,
        this.bat1Sixers,
        this.bat2Ones,
        this.bat2Twos,
        this.bat2Threes,
        this.bat2Fives,
        this.bat2Boundaries,
        this.bat2Sixers});

  PartnershipsData.fromJson(Map<String, dynamic> json) {
    bat1Id = json['bat1Id'];
    bat1Name = json['bat1Name'];
    bat1Runs = json['bat1Runs'];
    bat1fours = json['bat1fours'];
    bat1sixes = json['bat1sixes'];
    bat2Id = json['bat2Id'];
    bat2Name = json['bat2Name'];
    bat2Runs = json['bat2Runs'];
    bat2fours = json['bat2fours'];
    bat2sixes = json['bat2sixes'];
    totalRuns = json['totalRuns'];
    totalBalls = json['totalBalls'];
    bat1balls = json['bat1balls'];
    bat2balls = json['bat2balls'];
    bat1Ones = json['bat1Ones'];
    bat1Twos = json['bat1Twos'];
    bat1Threes = json['bat1Threes'];
    bat1Fives = json['bat1Fives'];
    bat1Boundaries = json['bat1Boundaries'];
    bat1Sixers = json['bat1Sixers'];
    bat2Ones = json['bat2Ones'];
    bat2Twos = json['bat2Twos'];
    bat2Threes = json['bat2Threes'];
    bat2Fives = json['bat2Fives'];
    bat2Boundaries = json['bat2Boundaries'];
    bat2Sixers = json['bat2Sixers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bat1Id'] = this.bat1Id;
    data['bat1Name'] = this.bat1Name;
    data['bat1Runs'] = this.bat1Runs;
    data['bat1fours'] = this.bat1fours;
    data['bat1sixes'] = this.bat1sixes;
    data['bat2Id'] = this.bat2Id;
    data['bat2Name'] = this.bat2Name;
    data['bat2Runs'] = this.bat2Runs;
    data['bat2fours'] = this.bat2fours;
    data['bat2sixes'] = this.bat2sixes;
    data['totalRuns'] = this.totalRuns;
    data['totalBalls'] = this.totalBalls;
    data['bat1balls'] = this.bat1balls;
    data['bat2balls'] = this.bat2balls;
    data['bat1Ones'] = this.bat1Ones;
    data['bat1Twos'] = this.bat1Twos;
    data['bat1Threes'] = this.bat1Threes;
    data['bat1Fives'] = this.bat1Fives;
    data['bat1Boundaries'] = this.bat1Boundaries;
    data['bat1Sixers'] = this.bat1Sixers;
    data['bat2Ones'] = this.bat2Ones;
    data['bat2Twos'] = this.bat2Twos;
    data['bat2Threes'] = this.bat2Threes;
    data['bat2Fives'] = this.bat2Fives;
    data['bat2Boundaries'] = this.bat2Boundaries;
    data['bat2Sixers'] = this.bat2Sixers;
    return data;
  }
}