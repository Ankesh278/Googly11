import 'Result.dart';
//
// class AadharVerification {
//   AadharVerification({
//      required this.code,
//      required this.result,});
//
//   AadharVerification.fromJson(dynamic json) {
//     code = json['code'];
//     result = json['result'] != null ? Result.fromJson(json['result']) : null;
//   }
//   int code=0;
//   Result? result;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['code'] = code;
//     if (result != null) {
//       map['result'] = result!.toJson();
//     }
//     return map;
//   }
//
// }
class AadharVerification {
  AadharVerification({
    this.refId,
    this.status,
    this.message,
  });

  AadharVerification.fromJson(Map<String, dynamic> json) {
    refId = json['ref_id'] != null ? int.tryParse(json['ref_id']) : null;
    status = json['status'];
    message = json['message'];
  }

  int? refId;
  String? status;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ref_id'] = this.refId;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}


