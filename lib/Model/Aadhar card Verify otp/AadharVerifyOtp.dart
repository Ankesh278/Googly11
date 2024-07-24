import 'Result.dart';

class AadharVerifyOtp {
  dynamic code; // Change the type to dynamic
  Result? result;

  AadharVerifyOtp({
    required this.code,
    required this.result,
  });

  factory AadharVerifyOtp.fromJson(Map<String, dynamic> json) {
    return AadharVerifyOtp(
      code: json['code'] != null ? int.tryParse(json['code']) ?? 0 : 0,
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}
