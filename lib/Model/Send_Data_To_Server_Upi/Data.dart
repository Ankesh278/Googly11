class DataSendServerReturn {
  DataSendServerReturn({
      this.id, 
      this.userId, 
      this.upiId, 
      this.name, 
      this.pspName, 
      this.code, 
      this.payeeType, 
      this.bankIfsc, 
      this.createdAt, 
      this.updatedAt,});

  DataSendServerReturn.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    upiId = json['upiId'] ?? '';
    name = json['name'] ?? '';
    pspName = json['pspName'] ?? '';
    code = json['code'] ?? '';
    payeeType = json['payeeType'] ?? '';
    bankIfsc = json['bankIfsc'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
  int? id;
  int? userId;
  String? upiId;
  String? name;
  String? pspName;
  String? code;
  String? payeeType;
  String? bankIfsc;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['upiId'] = upiId;
    map['name'] = name;
    map['pspName'] = pspName;
    map['code'] = code;
    map['payeeType'] = payeeType;
    map['bankIfsc'] = bankIfsc;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}