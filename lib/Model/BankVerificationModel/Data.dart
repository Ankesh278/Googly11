class Data {
  Data({
    required  this.nameAtBank,
    required  this.refId,
    required this.bankName,
    required this.utr,
    required  this.city,
    required this.branch,
    required this.micr,});

  Data.fromJson(dynamic json) {
    nameAtBank = json['nameAtBank'] ?? "";
    refId = json['refId'] ?? "";
    bankName = json['bankName'] ?? "";
    utr = json['utr'] ?? null; // You can replace null with a default value if needed
    city = json['city'] ?? "";
    branch = json['branch'] ?? "";
    micr = json['micr'] ?? "";
  }

  String nameAtBank="";
  String refId="";
  String bankName="";
  dynamic utr;
  String city="";
  String branch="";
  String micr="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nameAtBank'] = nameAtBank;
    map['refId'] = refId;
    map['bankName'] = bankName;
    map['utr'] = utr;
    map['city'] = city;
    map['branch'] = branch;
    map['micr'] = micr;
    return map;
  }

}