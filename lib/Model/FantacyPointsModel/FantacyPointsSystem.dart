import 'MatchTypes.dart';

class FantasyPointsSystem {
  FantasyPointsSystem({
    required  this.status,
    required  this.matchTypes,
  });

  FantasyPointsSystem.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['matchTypes'] != null) {
      matchTypes = [];
      json['matchTypes'].forEach((v) {
        matchTypes!.add(MatchTypes.fromJson(v));
      });
    }
  }
  int status = 0;
  List<MatchTypes>? matchTypes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (matchTypes != null) {
      map['matchTypes'] = matchTypes!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}