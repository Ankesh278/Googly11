import 'Data.dart';

class PanDetails {
  PanDetails({
     required this.transactionStatus,
    required  this.txnId,
    required this.statusMessage,
    required this.statusCode,
    required this.requestTimestamp,
    required this.responseTimestamp,
    required this.refId,
    required this.data,});

  PanDetails.fromJson(dynamic json) {
    transactionStatus = json['transaction_status'];
    txnId = json['txn_id'];
    statusMessage = json['statusMessage'];
    statusCode = json['statusCode'];
    requestTimestamp = json['request_timestamp'];
    responseTimestamp = json['response_timestamp'];
    refId = json['ref_Id'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int transactionStatus=0;
  String txnId="";
  String statusMessage="";
  String statusCode="";
  String requestTimestamp="";
  String responseTimestamp="";
  String refId="";
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transaction_status'] = transactionStatus;
    map['txn_id'] = txnId;
    map['statusMessage'] = statusMessage;
    map['statusCode'] = statusCode;
    map['request_timestamp'] = requestTimestamp;
    map['response_timestamp'] = responseTimestamp;
    map['ref_Id'] = refId;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}