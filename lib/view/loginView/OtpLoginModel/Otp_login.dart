import 'User.dart';

class OtpLogin {
  OtpLogin({
     required this.status,
    required this.message,
    required this.accessToken,
    required this.user,});

  OtpLogin.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    accessToken = json['access_token'] ?? '';
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  int status=0;
  String message="";
  String accessToken="";
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['access_token'] = accessToken;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

}