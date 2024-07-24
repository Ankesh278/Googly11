import 'AllData.dart';

class UpcomingNewApiResponse {
  UpcomingNewApiResponse({
     required this.status,
    required this.allData,});

  UpcomingNewApiResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    allData = json['allData'] != null ? AllData.fromJson(json['allData']) : null;
  }
  int status =0;
  AllData? allData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (allData != null) {
      map['allData'] = allData!.toJson();
    }
    return map;
  }

}