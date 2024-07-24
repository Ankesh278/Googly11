import 'Data.dart';

class Result {
  Result({
     required this.data,
    required  this.statusCode,
    required this.success,
    required this.message,
    required this.messageCode,});

  Result.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    success = json['success'];
    message = json['message'];
    messageCode = json['message_code'];
  }
  Data? data;
  int statusCode=0;
  bool success=false;
  dynamic message;
  String messageCode="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['status_code'] = statusCode;
    map['success'] = success;
    map['message'] = message;
    map['message_code'] = messageCode;
    return map;
  }

}