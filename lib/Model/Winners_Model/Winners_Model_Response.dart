import 'Data.dart';

class WinnersModelResponse {
  WinnersModelResponse({
      this.status, 
      this.data,});

  WinnersModelResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(WinnersDataModel.fromJson(v));
      });
    }
  }
  int? status;
  List<WinnersDataModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}