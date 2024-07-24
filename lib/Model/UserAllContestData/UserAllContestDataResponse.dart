import 'Data.dart';

class UserAllContestDataResponse {
  UserAllContestDataResponse({
     required this.status,
    required  this.data,});

  UserAllContestDataResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TeamDataContest.fromJson(v));
      });
    }
  }
  int status = 0;
  List<TeamDataContest>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}