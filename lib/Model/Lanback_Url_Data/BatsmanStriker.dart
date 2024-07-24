class BatsmanStriker {
  dynamic batBalls;
  dynamic batDots;
  dynamic batFours;
  dynamic batId;
  String? batName;
  dynamic batMins;
  dynamic batRuns;
  dynamic batSixes;
  dynamic batStrikeRate;

  BatsmanStriker({
    this.batBalls,
    this.batDots,
    this.batFours,
    this.batId,
    this.batName,
    this.batMins,
    this.batRuns,
    this.batSixes,
    this.batStrikeRate,
  });

  BatsmanStriker.fromJson(Map<String, dynamic> json) {
    batBalls = json['batBalls']?.toInt();
    batDots = json['batDots']?.toInt();
    batFours = json['batFours']?.toInt();
    batId = json['batId']?.toInt();
    batName = json['batName'];
    batMins = json['batMins']?.toInt();
    batRuns = json['batRuns']?.toInt();
    batSixes = json['batSixes']?.toInt();
    batStrikeRate = json['batStrikeRate']?.toDouble(); // Change to toDouble()
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batBalls'] = this.batBalls;
    data['batDots'] = this.batDots;
    data['batFours'] = this.batFours;
    data['batId'] = this.batId;
    data['batName'] = this.batName;
    data['batMins'] = this.batMins;
    data['batRuns'] = this.batRuns;
    data['batSixes'] = this.batSixes;
    data['batStrikeRate'] = this.batStrikeRate;
    return data;
  }
}
