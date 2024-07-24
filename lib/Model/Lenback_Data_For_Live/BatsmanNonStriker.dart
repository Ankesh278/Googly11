class BatsmanNonStriker {
  BatsmanNonStriker({
     required this.batBalls,
    required this.batDots,
    required this.batFours,
    required this.batId,
    required this.batName,
    required this.batMins,
    required this.batRuns,
    required this.batSixes,});

  BatsmanNonStriker.fromJson(dynamic json) {
    batBalls = json['batBalls'] ?? 0;
    batDots = json['batDots'] ?? 0;
    batFours = json['batFours'] ?? 0;
    batId = json['batId'] ?? 0;
    batName = json['batName'] ?? '';
    batMins = json['batMins'] ?? 0;
    batRuns = json['batRuns'] ?? 0;
    batSixes = json['batSixes'] ?? 0;
  }
  dynamic batBalls =0;
  dynamic batDots =0;
  dynamic batFours =0;
  dynamic batId =0;
  dynamic batName ='';
  dynamic batMins =0;
  dynamic batRuns =0;
  dynamic batSixes =0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['batBalls'] = batBalls;
    map['batDots'] = batDots;
    map['batFours'] = batFours;
    map['batId'] = batId;
    map['batName'] = batName;
    map['batMins'] = batMins;
    map['batRuns'] = batRuns;
    map['batSixes'] = batSixes;
    return map;
  }

}