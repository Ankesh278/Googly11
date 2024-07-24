import 'MatchInfo.dart';

class TopWinningContestDetails {
  TopWinningContestDetails({
      this.status, 
      this.joincontestWinnings, 
      this.matchInfo,});

  TopWinningContestDetails.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    joincontestWinnings = json['joincontestWinnings'] ?? '';
    if (json['match_info'] != null) {
      matchInfo = [];
      json['match_info'].forEach((v) {
        matchInfo!.add(MatchInfo.fromJson(v));
      });
    }
  }
  int? status;
  String? joincontestWinnings;
  List<MatchInfo>? matchInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['joincontestWinnings'] = joincontestWinnings;
    if (matchInfo != null) {
      map['match_info'] = matchInfo!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}