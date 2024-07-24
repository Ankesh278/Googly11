import 'Data.dart';

class Result {
  Result({
      required this.data,
      required this.statusCode,
      required this.messageCode,
      required this.message,
      required this.success,});

  Result.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    messageCode = json['message_code'];
    message = json['message'];
    success = json['success'];
  }
  Data? data;
  int statusCode=0;
  String messageCode="";
  String message="";
  bool success=false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['status_code'] = statusCode;
    map['message_code'] = messageCode;
    map['message'] = message;
    map['success'] = success;
    return map;
  }

}