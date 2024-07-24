import 'Data.dart';

class Result {
  Result({
    required  this.status,
    required  this.subCode,
    required  this.message,
    required  this.accountStatus,
    required  this.accountStatusCode,
    required  this.data,});

  Result.fromJson(dynamic json) {
    status = json['status'];
    subCode = json['subCode']  as int;
    message = json['message'];
    accountStatus = json['accountStatus'];
    accountStatusCode = json['accountStatusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  dynamic status;
  int subCode=0;
  String message="";
  String accountStatus="";
  String accountStatusCode="";
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['subCode'] = subCode;
    map['message'] = message;
    map['accountStatus'] = accountStatus;
    map['accountStatusCode'] = accountStatusCode;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}