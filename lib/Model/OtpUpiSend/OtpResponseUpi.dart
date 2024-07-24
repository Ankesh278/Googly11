class OtpResponseUpi {
  OtpResponseUpi({
      this.status, 
      this.message, 
      this.otp,});

  OtpResponseUpi.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    otp = json['otp'] ?? 0;
  }
  int? status;
  String? message;
  int? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['otp'] = otp;
    return map;
  }

}