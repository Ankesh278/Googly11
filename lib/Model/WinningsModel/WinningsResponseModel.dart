import 'Data.dart';

class WinningsResponseModel {
  WinningsResponseModel({
    required  this.status,
    required this.data,});

  WinningsResponseModel.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int status = 0;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}