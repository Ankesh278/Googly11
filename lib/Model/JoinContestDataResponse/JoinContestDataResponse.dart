import '../JoinContestList/Data.dart';
import 'Data.dart';

class JoinContestDataResponse {
  JoinContestDataResponse({
    required  this.status,
    required  this.data,});

  JoinContestDataResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(JoinContestData_.fromJson(v));
      });
    }
  }
  int status = 0;
  List<JoinContestData_>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}