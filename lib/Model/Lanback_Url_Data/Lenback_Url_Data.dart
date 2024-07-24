import 'Data.dart';

class LenbackUrlData {
  LenbackUrlData({
    required  this.status,
    required  this.data,});

  LenbackUrlData.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] != null ? LeanBackData.fromJson(json['data']) : null;
  }
  int status = 0;
  LeanBackData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}