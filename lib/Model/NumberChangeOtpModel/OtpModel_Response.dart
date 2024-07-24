class OtpModelResponse {
  OtpModelResponse({
     required this.status,
    required this.message,});

  OtpModelResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
  }
  int status= 0;
  String message = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}