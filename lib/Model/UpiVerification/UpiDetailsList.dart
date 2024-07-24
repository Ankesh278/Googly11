class UpiDetailsList {
  UpiDetailsList({
      this.upiId, 
      this.name, 
      this.pspName, 
      this.code, 
      this.payeeType, 
      this.bankIfsc,});

  UpiDetailsList.fromJson(dynamic json) {
    upiId = json['upiId'] ?? '';
    name = json['name'] ?? '';
    pspName = json['pspName'] ?? '';
    code = json['code'] ?? '';
    payeeType = json['payeeType'] ?? '';
    bankIfsc = json['bankIfsc'] ?? '';
  }
  String? upiId;
  String? name;
  String? pspName;
  String? code;
  String? payeeType;
  String? bankIfsc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['upiId'] = upiId;
    map['name'] = name;
    map['pspName'] = pspName;
    map['code'] = code;
    map['payeeType'] = payeeType;
    map['bankIfsc'] = bankIfsc;
    return map;
  }

}