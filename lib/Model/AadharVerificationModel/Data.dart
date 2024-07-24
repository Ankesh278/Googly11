class Data {
  Data({
      required this.clientId,
      required this.otpSent,
      required this.ifNumber,
      required this.validAadhaar,
      required this.status,});

  Data.fromJson(dynamic json) {
    clientId = json['client_id'];
    otpSent = json['otp_sent'];
    ifNumber = json['if_number'];
    validAadhaar = json['valid_aadhaar'];
    status = json['status'];
  }
  String clientId="";
  bool otpSent=false;
  bool ifNumber=false;
  bool validAadhaar=false;
  String status="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['client_id'] = clientId;
    map['otp_sent'] = otpSent;
    map['if_number'] = ifNumber;
    map['valid_aadhaar'] = validAadhaar;
    map['status'] = status;
    return map;
  }

}