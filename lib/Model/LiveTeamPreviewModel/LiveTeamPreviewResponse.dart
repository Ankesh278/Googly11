import 'Data.dart';

class LiveTeamPreviewResponse {
  LiveTeamPreviewResponse({
      this.status, 
      this.data,});

  LiveTeamPreviewResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(LiveTeamPreviewData.fromJson(v));
      });
    }
  }
  int? status;
  List<LiveTeamPreviewData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}