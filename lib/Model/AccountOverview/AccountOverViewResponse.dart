import 'Data.dart';

class AccountOverViewResponse {
  AccountOverViewResponse({
      this.status, 
      this.data,});

  AccountOverViewResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] != null ? AccountOverviewData.fromJson(json['data']) : null;
  }
  int? status;
  AccountOverviewData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}