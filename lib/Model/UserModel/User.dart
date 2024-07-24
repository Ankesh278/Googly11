class UserModelData {
  UserModelData({
    required  this.id,
    required this.name,
    required  this.userName,
    required  this.email,
    required  this.emailVerifiedAt,
    required this.phone,
    required this.customApiToken,
    required this.createdAt,
    required this.updatedAt,});

  UserModelData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    userName = json['user_name'] ?? '';
    email = json['email'] ?? '';
    emailVerifiedAt = json['email_verified_at'] ?? '';
    phone = json['phone'] ?? '';
    customApiToken = json['custom_api_token'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
  int id=0;
  dynamic name;
  String userName='';
  dynamic email;
  dynamic emailVerifiedAt;
  String phone='';
  dynamic customApiToken;
  String createdAt='';
  String updatedAt='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_name'] = userName;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['phone'] = phone;
    map['custom_api_token'] = customApiToken;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}