class EmailOtpSend {
  EmailOtpSend({
      this.status, 
      this.message, 
      this.otp,});

  EmailOtpSend.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    otp = json['OTP'] ?? 0;
  }
  int? status;
  String? message;
  int? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['OTP'] = otp;
    return map;
  }

}