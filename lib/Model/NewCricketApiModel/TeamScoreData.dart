import 'InnigsData.dart';

class TeamscoreData {
  InngsData? inngs1;

  TeamscoreData({this.inngs1});

  TeamscoreData.fromJson(Map<String, dynamic> json) {
    inngs1 =
    json['inngs1'] != null ? new InngsData.fromJson(json['inngs1']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.inngs1 != null) {
      data['inngs1'] = this.inngs1!.toJson();
    }
    return data;
  }
}