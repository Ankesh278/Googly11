import 'User.dart';

class UserModelResponse {
  UserModelResponse({
     required this.status,
     required this.user,}
      );

  UserModelResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    user = json['user'] != null ? UserModelData.fromJson(json['user']) : null;
  }
  int status=0;
  UserModelData? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

}