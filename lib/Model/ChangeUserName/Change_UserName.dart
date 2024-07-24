class ChangeUserNameResponse {
  ChangeUserNameResponse({
     required this.status,
     required this.message,
     required this.new_user_name
  });

  ChangeUserNameResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    message = json['message'] ?? '';
    new_user_name=json['new_user_name'] ?? '';
  }
  int status =0;
  String message ='';
  String new_user_name='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['new_user_name']=new_user_name;
    return map;
  }

}