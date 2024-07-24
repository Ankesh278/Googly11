import 'Data.dart';

class GetContestDataClass {
  GetContestDataClass({
    required  this.status,
    required  this.data,});

  GetContestDataClass.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [] ;
      json['data'].forEach((v) {
        data!.add(ContestData.fromJson(v));
      });
    }
  }
  int status =0;
  List<ContestData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}