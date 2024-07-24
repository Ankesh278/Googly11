import 'Address.dart';

class Data {
  Data({
    required  this.clientId,
    required this.fullName,
    required this.aadhaarNumber,
    required this.dob,
    required this.gender,
    required this.address,
    required this.faceStatus,
    required this.faceScore,
    required this.zip,
    required this.profileImage,
    required this.hasImage,
    required this.emailHash,
    required this.mobileHash,
    required this.rawXml,
    required this.zipData,
    required this.careOf,
    required this.shareCode,
    required this.mobileVerified,
    required this.referenceId,
    required this.aadhaarPdf,
    required this.status,
    required this.uniquenessId,});

  Data.fromJson(dynamic json) {
    clientId = json['client_id'];
    fullName = json['full_name'];
    aadhaarNumber = json['aadhaar_number'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    faceStatus = json['face_status'];
    faceScore = json['face_score'];
    zip = json['zip'];
    profileImage = json['profile_image'];
    hasImage = json['has_image'];
    emailHash = json['email_hash'];
    mobileHash = json['mobile_hash'];
    rawXml = json['raw_xml'];
    zipData = json['zip_data'];
    careOf = json['care_of'];
    shareCode = json['share_code'];
    mobileVerified = json['mobile_verified'];
    referenceId = json['reference_id'];
    aadhaarPdf = json['aadhaar_pdf'];
    status = json['status'];
    uniquenessId = json['uniqueness_id'];
  }
  String clientId="";
  String fullName="";
  String aadhaarNumber="";
  String dob="";
  String gender="";
  Address? address;
  bool faceStatus=false;
  int faceScore=0;
  String zip="";
  String profileImage="";
  bool hasImage=false;
  String emailHash="";
  String mobileHash="";
  String rawXml="";
  String zipData="";
  String careOf="";
  String shareCode="";
  bool mobileVerified=false;
  String referenceId="";
  dynamic aadhaarPdf;
  String status="";
  String uniquenessId="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['client_id'] = clientId;
    map['full_name'] = fullName;
    map['aadhaar_number'] = aadhaarNumber;
    map['dob'] = dob;
    map['gender'] = gender;
    if (address != null) {
      map['address'] = address!.toJson();
    }
    map['face_status'] = faceStatus;
    map['face_score'] = faceScore;
    map['zip'] = zip;
    map['profile_image'] = profileImage;
    map['has_image'] = hasImage;
    map['email_hash'] = emailHash;
    map['mobile_hash'] = mobileHash;
    map['raw_xml'] = rawXml;
    map['zip_data'] = zipData;
    map['care_of'] = careOf;
    map['share_code'] = shareCode;
    map['mobile_verified'] = mobileVerified;
    map['reference_id'] = referenceId;
    map['aadhaar_pdf'] = aadhaarPdf;
    map['status'] = status;
    map['uniqueness_id'] = uniquenessId;
    return map;
  }

}