class User {
  User({
     required this.id,
    required  this.name,
    required  this.userName,
    required this.invite_code,
    required  this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.phone_verified,
    required this.createdAt,
    required this.updatedAt,});

  User.fromJson(dynamic json) {
    id = json['id'] ?? 0; // Use the null-aware operator to provide a default value
    name = json['name'] ?? '';
    userName = json['user_name'] ?? '';
    invite_code=json['invite_code'] ?? '';
    email = json['email'] ?? '';
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'] ?? '';
    phone_verified = json['phone_verified'];
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
  int id=0;
  dynamic name;
  String userName="";
  String invite_code="";
  dynamic email;
  dynamic emailVerifiedAt;
  String phone="";
  dynamic phone_verified;
  String createdAt="";
  String updatedAt="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['user_name'] = userName;
    map['email'] = email;
    map['email_verified_at'] = emailVerifiedAt;
    map['phone'] = phone;
    map['phone_verified'] = phone_verified;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}