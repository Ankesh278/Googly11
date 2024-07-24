import 'Result.dart';

class UpiValidateResponse {
  UpiValidateResponse({
      this.code, 
      this.message, 
      this.result,});

  UpiValidateResponse.fromJson(dynamic json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? '';
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  int? code;
  String? message;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (result != null) {
      map['result'] = result!.toJson();
    }
    return map;
  }

}