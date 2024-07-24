class TossResults {
  TossResults({
     required this.tossWinnerId,
    required this.tossWinnerName,
    required this.decision,});

  TossResults.fromJson(dynamic json) {
    tossWinnerId = json['tossWinnerId'] ?? 0;
    tossWinnerName = json['tossWinnerName'] ?? '';
    decision = json['decision'] ?? '';
  }
  int tossWinnerId = 0;
  String tossWinnerName = '';
  String decision = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tossWinnerId'] = tossWinnerId;
    map['tossWinnerName'] = tossWinnerName;
    map['decision'] = decision;
    return map;
  }

}