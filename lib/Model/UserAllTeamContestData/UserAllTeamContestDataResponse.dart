import 'Data.dart';

class UserAllTeamContestDataResponse {
  UserAllTeamContestDataResponse({
    required  this.status,
    required this.data,
    required this.is_lineupOut
  });

  UserAllTeamContestDataResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    is_lineupOut = json['is_lineupOut'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TeamDataAll.fromJson(v));
      });
    } else {
      data = null; // Set data to null when json['data'] is null
    }
  }


  int status = 0;
  int is_lineupOut=0;
  List<TeamDataAll>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}