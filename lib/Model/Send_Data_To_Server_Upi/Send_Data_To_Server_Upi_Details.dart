import 'Data.dart';

class SendDataToServerUpiDetails {
  SendDataToServerUpiDetails({
      this.status, 
      this.message, 
      this.data,});

  SendDataToServerUpiDetails.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(DataSendServerReturn.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<DataSendServerReturn>? data;

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