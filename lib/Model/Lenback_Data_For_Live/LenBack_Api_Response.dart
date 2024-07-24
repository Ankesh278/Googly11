import 'Data.dart';

class LenBackApiResponse {
  LenBackApiResponse({
    required  this.status,
    required this.data,});

  LenBackApiResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] != null ? LenBack_Data_For_Live.fromJson(json['data']) : null;
  }
  int status = 0;
  LenBack_Data_For_Live? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}