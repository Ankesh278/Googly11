class Pp1 {
  Pp1({
      required this.ppId,
    required this.ppOversFrom,
    required this.ppOversTo,
    required this.ppType,
    required this.runsScored,});

  Pp1.fromJson(dynamic json) {
    ppId = json['ppId'] ?? 0;
    ppOversFrom = json['ppOversFrom'] ?? 0;
    ppOversTo = json['ppOversTo'] ?? 0;
    ppType = json['ppType'] ?? '';
    runsScored = json['runsScored'] ?? 0;
  }
  int ppId = 0;
  double ppOversFrom = 0;
  int ppOversTo = 0;
  String ppType = '';
  int runsScored = 0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ppId'] = ppId;
    map['ppOversFrom'] = ppOversFrom;
    map['ppOversTo'] = ppOversTo;
    map['ppType'] = ppType;
    map['runsScored'] = runsScored;
    return map;
  }

}