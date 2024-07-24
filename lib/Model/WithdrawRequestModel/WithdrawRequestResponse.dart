class WithdrawRequestResponse {
  WithdrawRequestResponse({
      this.status, 
      this.message, 
      this.bankId,});

  WithdrawRequestResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    bankId = json['bankId'] ?? '';
  }
  int? status;
  String? message;
  String? bankId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['bankId'] = bankId;
    return map;
  }

}