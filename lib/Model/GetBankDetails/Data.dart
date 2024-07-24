class BankAllData {
  BankAllData({
      this.id, 
      this.userId, 
      this.mobileNumber, 
      this.accountNumber, 
      this.ifscCode, 
      this.bankName, 
      this.city, 
      this.branch, 
      this.refid, 
      this.micr, 
      this.nameAtBank, 
      this.createdAt,
      this.verify_status,
      this.updatedAt,});

  BankAllData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    mobileNumber = json['mobile_number'] ?? "";
    accountNumber = json['account_number'] ?? "";
    ifscCode = json['ifsc_code'] ?? "";
    bankName = json['bank_name'] ?? "";
    city = json['city'] ?? "";
    branch = json['branch'] ?? "";
    refid = json['refid'] ?? "";
    micr = json['micr'] ?? "";
    nameAtBank = json['name_at_bank'] ?? "";
    createdAt = json['created_at'] ?? "";
    verify_status = json['verify_status'] ?? 0;
    updatedAt = json['updated_at'] ?? "";
  }
  int? id;
  int? userId;
  String? mobileNumber;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? city;
  String? branch;
  String? refid;
  String? micr;
  String? nameAtBank;
  String? createdAt;
  int? verify_status;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['mobile_number'] = mobileNumber;
    map['account_number'] = accountNumber;
    map['ifsc_code'] = ifscCode;
    map['bank_name'] = bankName;
    map['city'] = city;
    map['branch'] = branch;
    map['refid'] = refid;
    map['micr'] = micr;
    map['name_at_bank'] = nameAtBank;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}