class LiveMatchScoreCard {
  int? status;
  String? message;
  List<ScoreCardData>? data;

  LiveMatchScoreCard({this.status, this.message, this.data});

  LiveMatchScoreCard.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    if (json['data'] != null) {
      data = <ScoreCardData>[];
      json['data'].forEach((v) {
        data!.add(new ScoreCardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScoreCardData {
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

  ScoreCardData(
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

  ScoreCardData.fromJson(Map<String, dynamic> json) {
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
    wicketsData = json['wicketsData'] != null
        ? List<WicketsData>.from(json['wicketsData'].map((data) => WicketsData.fromJson(data)))
        : null;

    partnershipsData = json['partnershipsData'] != null
        ? List<PartnershipsData>.from(json['partnershipsData'].map((data) => PartnershipsData.fromJson(data)))
        : null;

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
      data['wicketsData'] = this.wicketsData!.map((wicket) => wicket.toJson()).toList();
    }
    if (this.partnershipsData != null) {
      data['partnershipsData'] = this.partnershipsData!.map((partnership) => partnership.toJson()).toList();
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
    batTeamId = json['batTeamId'];
    batTeamName = json['batTeamName'];
    batTeamShortName = json['batTeamShortName'];
    // Assuming 'batsmenData' is a list of JSON objects
    if (json['batsmenData'] != null) {
      batsmenData = List<BatsmenData>.from(
        json['batsmenData'].map((data) => BatsmenData.fromJson(data)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batTeamId'] = this.batTeamId;
    data['batTeamName'] = this.batTeamName;
    data['batTeamShortName'] = this.batTeamShortName;
    // Assuming 'batsmenData' is a list of BatsmenData objects
    if (this.batsmenData != null) {
      data['batsmenData'] = this.batsmenData!.map((batsmen) => batsmen.toJson()).toList();
    }
    return data;
  }
}

class BatsmenData {
  Bat5? bat5;
  Bat5? bat2;
  Bat5? bat10;
  Bat5? bat7;
  Bat1? bat1;
  Bat5? bat8;
  Bat5? bat3;
  Bat5? bat9;
  Bat5? bat6;
  Bat5? bat4;
  Bat5? bat11;

  BatsmenData(
      {this.bat5,
        this.bat2,
        this.bat10,
        this.bat7,
        this.bat1,
        this.bat8,
        this.bat3,
        this.bat9,
        this.bat6,
        this.bat4,
        this.bat11});

  BatsmenData.fromJson(Map<String, dynamic> json) {
    bat5 = json['bat_5'] != null ? new Bat5.fromJson(json['bat_5']) : null;
    bat2 = json['bat_2'] != null ? new Bat5.fromJson(json['bat_2']) : null;
    bat10 = json['bat_10'] != null ? new Bat5.fromJson(json['bat_10']) : null;
    bat7 = json['bat_7'] != null ? new Bat5.fromJson(json['bat_7']) : null;
    bat1 = json['bat_1'] != null ? new Bat1.fromJson(json['bat_1']) : null;
    bat8 = json['bat_8'] != null ? new Bat5.fromJson(json['bat_8']) : null;
    bat3 = json['bat_3'] != null ? new Bat5.fromJson(json['bat_3']) : null;
    bat9 = json['bat_9'] != null ? new Bat5.fromJson(json['bat_9']) : null;
    bat6 = json['bat_6'] != null ? new Bat5.fromJson(json['bat_6']) : null;
    bat4 = json['bat_4'] != null ? new Bat5.fromJson(json['bat_4']) : null;
    bat11 = json['bat_11'] != null ? new Bat5.fromJson(json['bat_11']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bat5 != null) {
      data['bat_5'] = this.bat5!.toJson();
    }
    if (this.bat2 != null) {
      data['bat_2'] = this.bat2!.toJson();
    }
    if (this.bat10 != null) {
      data['bat_10'] = this.bat10!.toJson();
    }
    if (this.bat7 != null) {
      data['bat_7'] = this.bat7!.toJson();
    }
    if (this.bat1 != null) {
      data['bat_1'] = this.bat1!.toJson();
    }
    if (this.bat8 != null) {
      data['bat_8'] = this.bat8!.toJson();
    }
    if (this.bat3 != null) {
      data['bat_3'] = this.bat3!.toJson();
    }
    if (this.bat9 != null) {
      data['bat_9'] = this.bat9!.toJson();
    }
    if (this.bat6 != null) {
      data['bat_6'] = this.bat6!.toJson();
    }
    if (this.bat4 != null) {
      data['bat_4'] = this.bat4!.toJson();
    }
    if (this.bat11 != null) {
      data['bat_11'] = this.bat11!.toJson();
    }
    return data;
  }
}

class Bat5 {
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

  Bat5(
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

  Bat5.fromJson(Map<String, dynamic> json) {
    batId = json['batId'];
    batName = json['batName'];
    batShortName = json['batShortName'];
    isCaptain = json['isCaptain'];
    isKeeper = json['isKeeper'];
    runs = json['runs'];
    balls = json['balls'];
    dots = json['dots'];
    fours = json['fours'];
    sixes = json['sixes'];
    mins = json['mins'];
    strikeRate = json['strikeRate'];
    outDesc = json['outDesc'];
    bowlerId = json['bowlerId'];
    fielderId1 = json['fielderId1'];
    fielderId2 = json['fielderId2'];
    fielderId3 = json['fielderId3'];
    ones = json['ones'];
    twos = json['twos'];
    threes = json['threes'];
    fives = json['fives'];
    boundaries = json['boundaries'];
    sixers = json['sixers'];
    wicketCode = json['wicketCode'];
    isOverseas = json['isOverseas'];
    inMatchChange = json['inMatchChange'];
    playingXIChange = json['playingXIChange'];
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

class Bat1 {
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

  Bat1(
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

  Bat1.fromJson(Map<String, dynamic> json) {
    batId = json['batId'];
    batName = json['batName'];
    batShortName = json['batShortName'];
    isCaptain = json['isCaptain'];
    isKeeper = json['isKeeper'];
    runs = json['runs'];
    balls = json['balls'];
    dots = json['dots'];
    fours = json['fours'];
    sixes = json['sixes'];
    mins = json['mins'];
    strikeRate = json['strikeRate'];
    outDesc = json['outDesc'];
    bowlerId = json['bowlerId'];
    fielderId1 = json['fielderId1'];
    fielderId2 = json['fielderId2'];
    fielderId3 = json['fielderId3'];
    ones = json['ones'];
    twos = json['twos'];
    threes = json['threes'];
    fives = json['fives'];
    boundaries = json['boundaries'];
    sixers = json['sixers'];
    wicketCode = json['wicketCode'];
    isOverseas = json['isOverseas'];
    inMatchChange = json['inMatchChange'];
    playingXIChange = json['playingXIChange'];
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
    bowlTeamId = json['bowlTeamId'];
    bowlTeamName = json['bowlTeamName'];
    bowlTeamShortName = json['bowlTeamShortName'];
    if (json['batsmenData'] != null) {
      bowlersData = List<BowlersData>.from(
        json['batsmenData'].map((data) => BowlersData.fromJson(data)),
      );
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowlTeamId'] = this.bowlTeamId;
    data['bowlTeamName'] = this.bowlTeamName;
    data['bowlTeamShortName'] = this.bowlTeamShortName;
    if (this.bowlersData != null) {
      data['bowlersData'] = this.bowlersData!.map((batsmen) => batsmen.toJson()).toList();
    }
    return data;
  }
}

class BowlersData {
  Bowl1? bowl1;
  Bowl4? bowl4;
  Bowl6? bowl6;
  Bowl4? bowl5;
  Bowl1? bowl3;
  Bowl6? bowl7;
  Bowl1? bowl2;

  BowlersData(
      {this.bowl1,
        this.bowl4,
        this.bowl6,
        this.bowl5,
        this.bowl3,
        this.bowl7,
        this.bowl2});

  BowlersData.fromJson(Map<String, dynamic> json) {
    bowl1 = json['bowl_1'] != null ? new Bowl1.fromJson(json['bowl_1']) : null;
    bowl4 = json['bowl_4'] != null ? new Bowl4.fromJson(json['bowl_4']) : null;
    bowl6 = json['bowl_6'] != null ? new Bowl6.fromJson(json['bowl_6']) : null;
    bowl5 = json['bowl_5'] != null ? new Bowl4.fromJson(json['bowl_5']) : null;
    bowl3 = json['bowl_3'] != null ? new Bowl1.fromJson(json['bowl_3']) : null;
    bowl7 = json['bowl_7'] != null ? new Bowl6.fromJson(json['bowl_7']) : null;
    bowl2 = json['bowl_2'] != null ? new Bowl1.fromJson(json['bowl_2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bowl1 != null) {
      data['bowl_1'] = this.bowl1!.toJson();
    }
    if (this.bowl4 != null) {
      data['bowl_4'] = this.bowl4!.toJson();
    }
    if (this.bowl6 != null) {
      data['bowl_6'] = this.bowl6!.toJson();
    }
    if (this.bowl5 != null) {
      data['bowl_5'] = this.bowl5!.toJson();
    }
    if (this.bowl3 != null) {
      data['bowl_3'] = this.bowl3!.toJson();
    }
    if (this.bowl7 != null) {
      data['bowl_7'] = this.bowl7!.toJson();
    }
    if (this.bowl2 != null) {
      data['bowl_2'] = this.bowl2!.toJson();
    }
    return data;
  }
}

class Bowl1 {
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

  Bowl1(
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

  Bowl1.fromJson(Map<String, dynamic> json) {
    bowlerId = json['bowlerId'];
    bowlName = json['bowlName'];
    bowlShortName = json['bowlShortName'];
    isCaptain = json['isCaptain'];
    isKeeper = json['isKeeper'];
    overs = json['overs'];
    maidens = json['maidens'];
    runs = json['runs'];
    wickets = json['wickets'];
    economy = json['economy'];
    noBalls = json['no_balls'];
    wides = json['wides'];
    dots = json['dots'];
    balls = json['balls'];
    runsPerBall = json['runsPerBall'];
    isOverseas = json['isOverseas'];
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

class Bowl4 {
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

  Bowl4(
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

  Bowl4.fromJson(Map<String, dynamic> json) {
    bowlerId = json['bowlerId'];
    bowlName = json['bowlName'];
    bowlShortName = json['bowlShortName'];
    isCaptain = json['isCaptain'];
    isKeeper = json['isKeeper'];
    overs = json['overs'];
    maidens = json['maidens'];
    runs = json['runs'];
    wickets = json['wickets'];
    economy = json['economy'];
    noBalls = json['no_balls'];
    wides = json['wides'];
    dots = json['dots'];
    balls = json['balls'];
    runsPerBall = json['runsPerBall'];
    isOverseas = json['isOverseas'];
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

class Bowl6 {
  int? bowlerId;
  String? bowlName;
  String? bowlShortName;
  bool? isCaptain;
  bool? isKeeper;
  int? overs;
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

  Bowl6(
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

  Bowl6.fromJson(Map<String, dynamic> json) {
    bowlerId = json['bowlerId'];
    bowlName = json['bowlName'];
    bowlShortName = json['bowlShortName'];
    isCaptain = json['isCaptain'];
    isKeeper = json['isKeeper'];
    overs = json['overs'];
    maidens = json['maidens'];
    runs = json['runs'];
    wickets = json['wickets'];
    economy = json['economy'];
    noBalls = json['no_balls'];
    wides = json['wides'];
    dots = json['dots'];
    balls = json['balls'];
    runsPerBall = json['runsPerBall'];
    isOverseas = json['isOverseas'];
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
  int? revisedOvers;
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
  Wkt8? wkt8;
  Wkt8? wkt2;
  Wkt8? wkt9;
  Wkt8? wkt1;
  Wkt8? wkt6;
  Wkt8? wkt10;
  Wkt8? wkt4;
  Wkt8? wkt5;
  Wkt8? wkt7;
  Wkt8? wkt3;

  WicketsData(
      {this.wkt8,
        this.wkt2,
        this.wkt9,
        this.wkt1,
        this.wkt6,
        this.wkt10,
        this.wkt4,
        this.wkt5,
        this.wkt7,
        this.wkt3});

  WicketsData.fromJson(Map<String, dynamic> json) {
    wkt8 = json['wkt_8'] != null ? new Wkt8.fromJson(json['wkt_8']) : null;
    wkt2 = json['wkt_2'] != null ? new Wkt8.fromJson(json['wkt_2']) : null;
    wkt9 = json['wkt_9'] != null ? new Wkt8.fromJson(json['wkt_9']) : null;
    wkt1 = json['wkt_1'] != null ? new Wkt8.fromJson(json['wkt_1']) : null;
    wkt6 = json['wkt_6'] != null ? new Wkt8.fromJson(json['wkt_6']) : null;
    wkt10 = json['wkt_10'] != null ? new Wkt8.fromJson(json['wkt_10']) : null;
    wkt4 = json['wkt_4'] != null ? new Wkt8.fromJson(json['wkt_4']) : null;
    wkt5 = json['wkt_5'] != null ? new Wkt8.fromJson(json['wkt_5']) : null;
    wkt7 = json['wkt_7'] != null ? new Wkt8.fromJson(json['wkt_7']) : null;
    wkt3 = json['wkt_3'] != null ? new Wkt8.fromJson(json['wkt_3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wkt8 != null) {
      data['wkt_8'] = this.wkt8!.toJson();
    }
    if (this.wkt2 != null) {
      data['wkt_2'] = this.wkt2!.toJson();
    }
    if (this.wkt9 != null) {
      data['wkt_9'] = this.wkt9!.toJson();
    }
    if (this.wkt1 != null) {
      data['wkt_1'] = this.wkt1!.toJson();
    }
    if (this.wkt6 != null) {
      data['wkt_6'] = this.wkt6!.toJson();
    }
    if (this.wkt10 != null) {
      data['wkt_10'] = this.wkt10!.toJson();
    }
    if (this.wkt4 != null) {
      data['wkt_4'] = this.wkt4!.toJson();
    }
    if (this.wkt5 != null) {
      data['wkt_5'] = this.wkt5!.toJson();
    }
    if (this.wkt7 != null) {
      data['wkt_7'] = this.wkt7!.toJson();
    }
    if (this.wkt3 != null) {
      data['wkt_3'] = this.wkt3!.toJson();
    }
    return data;
  }
}

class Wkt8 {
  int? batId;
  String? batName;
  int? wktNbr;
  dynamic wktOver;
  int? wktRuns;
  int? ballNbr;

  Wkt8(
      {this.batId,
        this.batName,
        this.wktNbr,
        this.wktOver,
        this.wktRuns,
        this.ballNbr});

  Wkt8.fromJson(Map<String, dynamic> json) {
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
  Pat10? pat10;
  Pat10? pat1;
  Pat10? pat6;
  Pat10? pat9;
  Pat10? pat2;
  Pat10? pat5;
  Pat10? pat3;
  Pat10? pat8;
  Pat10? pat4;
  Pat10? pat7;

  PartnershipsData(
      {this.pat10,
        this.pat1,
        this.pat6,
        this.pat9,
        this.pat2,
        this.pat5,
        this.pat3,
        this.pat8,
        this.pat4,
        this.pat7});

  PartnershipsData.fromJson(Map<String, dynamic> json) {
    pat10 = json['pat_10'] != null ? new Pat10.fromJson(json['pat_10']) : null;
    pat1 = json['pat_1'] != null ? new Pat10.fromJson(json['pat_1']) : null;
    pat6 = json['pat_6'] != null ? new Pat10.fromJson(json['pat_6']) : null;
    pat9 = json['pat_9'] != null ? new Pat10.fromJson(json['pat_9']) : null;
    pat2 = json['pat_2'] != null ? new Pat10.fromJson(json['pat_2']) : null;
    pat5 = json['pat_5'] != null ? new Pat10.fromJson(json['pat_5']) : null;
    pat3 = json['pat_3'] != null ? new Pat10.fromJson(json['pat_3']) : null;
    pat8 = json['pat_8'] != null ? new Pat10.fromJson(json['pat_8']) : null;
    pat4 = json['pat_4'] != null ? new Pat10.fromJson(json['pat_4']) : null;
    pat7 = json['pat_7'] != null ? new Pat10.fromJson(json['pat_7']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pat10 != null) {
      data['pat_10'] = this.pat10!.toJson();
    }
    if (this.pat1 != null) {
      data['pat_1'] = this.pat1!.toJson();
    }
    if (this.pat6 != null) {
      data['pat_6'] = this.pat6!.toJson();
    }
    if (this.pat9 != null) {
      data['pat_9'] = this.pat9!.toJson();
    }
    if (this.pat2 != null) {
      data['pat_2'] = this.pat2!.toJson();
    }
    if (this.pat5 != null) {
      data['pat_5'] = this.pat5!.toJson();
    }
    if (this.pat3 != null) {
      data['pat_3'] = this.pat3!.toJson();
    }
    if (this.pat8 != null) {
      data['pat_8'] = this.pat8!.toJson();
    }
    if (this.pat4 != null) {
      data['pat_4'] = this.pat4!.toJson();
    }
    if (this.pat7 != null) {
      data['pat_7'] = this.pat7!.toJson();
    }
    return data;
  }
}

class Pat10 {
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

  Pat10(
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

  Pat10.fromJson(Map<String, dynamic> json) {
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

class Batsman {
  final int batId;
  final String batName;
  final bool isCaptain;
  final bool isKeeper;
  final int runs;
  final int balls;
  final int dots;
  final int fours;
  final int sixes;
  final int mins;
  final double strikeRate;
  final String outDesc;
  final int bowlerId;
  final int fielderId1;
  final int fielderId2;
  final int fielderId3;
  final int ones;
  final int twos;
  final int threes;
  final int fives;
  final int boundaries;
  final int sixers;
  final String wicketCode;
  final bool isOverseas;
  final String inMatchChange;
  final String playingXIChange;

  Batsman({
    required this.batId,
    required this.batName,
    required this.isCaptain,
    required this.isKeeper,
    required this.runs,
    required this.balls,
    required this.dots,
    required this.fours,
    required this.sixes,
    required this.mins,
    required this.strikeRate,
    required this.outDesc,
    required this.bowlerId,
    required this.fielderId1,
    required this.fielderId2,
    required this.fielderId3,
    required this.ones,
    required this.twos,
    required this.threes,
    required this.fives,
    required this.boundaries,
    required this.sixers,
    required this.wicketCode,
    required this.isOverseas,
    required this.inMatchChange,
    required this.playingXIChange,
  });
}

