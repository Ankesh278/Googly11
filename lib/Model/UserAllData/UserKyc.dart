class UserKyc {
  var adhar_status;

  UserKyc({
    required this.id,
    required  this.userId,
    required this.dob,
    required this.gender,
    required this.userImage,
    required  this.address,
    required  this.documnetType,
    required  this.docFrontImage,
    required  this.docBackImage,
    required  this.validateBy,
    required  this.kycStatus,
    required  this.pan_kyc,
    required  this.bankStatus,
    required  this.adharstatus,
    required  this.createdAt,
    required this.updatedAt,});

  UserKyc.fromJson(dynamic json) {
    id = json['id']?? 0;
    userId = json['user_id']?? 0;
    dob = json['dob'] ?? '';
    gender = json['gender'] ?? '';
    userImage = json['user_image'] ?? '';
    address = json['address'] ?? '';
    documnetType = json['documnet_type'] ?? '';
    docFrontImage = json['doc_front_image'] ?? '';
    docBackImage = json['doc_back_image'] ?? '';
    validateBy = json['validate_by'] ?? '';
    kycStatus = json['kyc_status'] ?? 0;
    pan_kyc = json['pan_kyc'] ?? 0;
    bankStatus = json['bank_status'] ?? 0;
    adharstatus = json['adhar_status'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';

  }
  int id=0;
  int userId = 0;
  String dob = '';
  String gender= '';
  String userImage= '';
  dynamic address;
  dynamic documnetType;
  dynamic docFrontImage;
  dynamic docBackImage;
  dynamic validateBy;
  int kycStatus= 0;
  int pan_kyc= 0;
  int adharstatus= 0;
  int bankStatus= 0;
  String createdAt ='';
  String updatedAt ='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['dob'] = dob;
    map['gender'] = gender;
    map['user_image'] = userImage;
    map['address'] = address;
    map['documnet_type'] = documnetType;
    map['doc_front_image'] = docFrontImage;
    map['doc_back_image'] = docBackImage;
    map['validate_by'] = validateBy;
    map['kyc_status'] = kycStatus;
    map['adhar_status'] = adharstatus;
    map['bank_status'] = bankStatus;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}