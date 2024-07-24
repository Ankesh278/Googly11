import 'MatchInfoData.dart';
import 'TeamScoreData.dart';

class NewDataClass {
  MatchInfoData? matchInfo;
  TeamscoreData? teamscore1;
  TeamscoreData? teamscore2;

  NewDataClass({this.matchInfo, this.teamscore1, this.teamscore2});

  NewDataClass.fromJson(Map<dynamic, dynamic> json) {
    matchInfo = json['matchInfo'] != null
        ? new MatchInfoData.fromJson(json['matchInfo'])
        : null;
    teamscore1 = json['teamscore1'] != null
        ? new TeamscoreData.fromJson(json['teamscore1'])
        : null;
    teamscore2 = json['teamscore2'] != null
        ? new TeamscoreData.fromJson(json['teamscore2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchInfo != null) {
      data['matchInfo'] = this.matchInfo!.toJson();
    }
    if (this.teamscore1 != null) {
      data['teamscore1'] = this.teamscore1!.toJson();
    }
    if (this.teamscore2 != null) {
      data['teamscore2'] = this.teamscore2!.toJson();
    }
    return data;
  }
}