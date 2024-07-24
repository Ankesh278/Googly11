class BonesResponse {
  BonesResponse({
      this.status, 
      this.message, 
      this.amount,});

  BonesResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    amount = json['amount'] ?? '';
  }
  int? status;
  String? message;
  String? amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['amount'] = amount;
    return map;
  }

}