import 'UserKyc.dart';

class UserDetails {
  UserDetails({
     required this.id,
    required this.name,
    required this.userName,
    required this.inviteCode,
    required this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.phoneVerified,
    required this.welcome_bones,
    required this.createdAt,
    required this.updatedAt,
    required this.userKyc,
    required this.referralAmount,
    required this.email_status,
    required this.appUrl,
    required this.appVersion,
    required this.maintenance,

  });

  UserDetails.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    reffran_code_use = json['reffran_code_use'] ?? 0;
    name = json['name'] ?? '';
    userName = json['user_name'] ?? '';
    inviteCode = json['invite_code'] ?? '';
    email = json['email'] ?? '';
    emailVerifiedAt = json['email_verified_at'] ?? '';
    phone = json['phone'] ?? '';
    phoneVerified = json['phone_verified'] ?? 0;
    welcome_bones= json['welcome_bones'] ?? 0;
    email_status= json['email_status'] ?? 0;
    createdAt = json['created_at'] ?? '';
    referralAmount = json['referralAmount'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    appVersion = json['appVersion'] ?? '';
    appUrl = json['appUrl'] ?? '';
    maintenance = json['maintenance'] ?? '';
    news_is_live = json['news_is_live'] ?? 0;
    news_title = json['news_title'] ?? '';
    news_dis = json['news_dis'] ?? '';
    m_dis = json['m_dis'] ?? '';
    m_start_time = json['m_start_time'] ?? '';
    m_end_time = json['m_end_time'] ?? '';
    userKyc = json['user_kyc'] != null ? UserKyc.fromJson(json['user_kyc']) : null;
  }
  int id=0;
  String name='';
  String userName='';
  String inviteCode='';
  int reffran_code_use=0;
  dynamic email;
  dynamic emailVerifiedAt;
  String phone='';
  int welcome_bones=0;
  int phoneVerified=0;
  int email_status=0;
  String referralAmount='';
  String createdAt='';
  String updatedAt='';
  UserKyc? userKyc;
  String? appVersion;
  String? appUrl;
  String? maintenance;
  int? news_is_live;
  String? news_title;
  String? news_dis;
  String? m_dis;
  String? m_start_time;
  String? m_end_time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['reffran_code_use'] = reffran_code_use;
    map['name'] = name;
    map['user_name'] = userName;
    map['invite_code'] = inviteCode;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['phone'] = phone;
    map['phone_verified'] = phoneVerified;
    map['welcome_bones'] = welcome_bones;
    map['email_status'] = email_status;
    map['created_at'] = createdAt;
    map['referralAmount'] = referralAmount;
    map['updated_at'] = updatedAt;
    map['appVersion'] = appVersion;
    map['appUrl'] = appUrl;
    if (userKyc != null) {
      map['user_kyc'] = userKyc!.toJson();
    }
    return map;
  }

}