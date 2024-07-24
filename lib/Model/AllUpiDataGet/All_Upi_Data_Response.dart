import 'Data.dart';

class AllUpiDataResponse {
  AllUpiDataResponse({
      this.status, 
      this.data,});

  AllUpiDataResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(All_Upi_Data.fromJson(v));
      });
    }
  }
  int? status;
  List<All_Upi_Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}