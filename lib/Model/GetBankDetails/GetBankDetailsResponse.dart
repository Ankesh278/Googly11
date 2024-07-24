import 'Data.dart';

class GetBankDetailsResponse {
  GetBankDetailsResponse({
      this.status, 
      this.message, 
      this.data,});

  GetBankDetailsResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(BankAllData.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<BankAllData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}