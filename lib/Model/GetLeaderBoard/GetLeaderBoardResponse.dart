import 'Data.dart';

class GetLeaderBoardResponse {
  GetLeaderBoardResponse({
     required this.status,
    required this.data,});

  GetLeaderBoardResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(LeaderBoardData.fromJson(v));
      });
    }
  }
  int status= 0;
  List<LeaderBoardData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}