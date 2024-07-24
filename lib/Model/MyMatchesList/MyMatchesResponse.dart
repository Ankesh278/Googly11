import 'MatchInfo.dart';

class MyMatchesResponse {
  MyMatchesResponse({
      this.status, 
      this.matchInfo,});

  MyMatchesResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['match_info'] != null) {
      matchInfo = [];
      json['match_info'].forEach((v) {
        matchInfo!.add(MatchInfo.fromJson(v));
      });
    }
  }
  int? status;
  List<MatchInfo>? matchInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (matchInfo != null) {
      map['match_info'] = matchInfo!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}