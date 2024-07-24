import 'Info.dart';

class BannersModel {
  BannersModel({
     required this.response,
    required this.msg,
    required this.info,});

  BannersModel.fromJson(dynamic json) {
    response = json['response'];
    msg = json['msg'];
    if (json['info'] != null) {
      info = [];
      json['info'].forEach((v) {
        info!.add(Info.fromJson(v));
      });
    }
  }
  String response="";
  String msg="";
  List<Info>? info;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = response;
    map['msg'] = msg;
    if (info != null) {
      map['info'] = info!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}