import 'Data.dart';

class LiveMatchPlayerData {
  LiveMatchPlayerData({
    required  this.status,
    required  this.data,});

  LiveMatchPlayerData.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(LiveMatch_Players_Image_Data.fromJson(v));
      });
    }
  }
  int status = 0;
  List<LiveMatch_Players_Image_Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}