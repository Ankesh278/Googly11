class LoginOtpModel {
  LoginOtpModel({
    required  this.status,
    required  this.message,
    required this.otp,});

  LoginOtpModel.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    otp = json['OTP'] ?? 0;
  }
  int status=0;
  String message="";
  int otp=0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['OTP'] = otp;
    return map;
  }

}