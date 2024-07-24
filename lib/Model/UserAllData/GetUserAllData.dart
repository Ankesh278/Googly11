import 'User.dart';

class GetUserAllData {
  GetUserAllData({
    required  this.status,
    required this.user,});

  GetUserAllData.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    user = json['user'] != null ? UserDetails.fromJson(json['user']) : null;
  }
  int status=0;
  UserDetails? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

}