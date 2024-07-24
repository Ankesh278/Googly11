import 'PlayersData.dart';

class PlayerTeamCreateResponse_ {
  PlayerTeamCreateResponse_();

  PlayerTeamCreateResponse_.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    lineup = json['lineup'] ?? 0;
    if (json['players_data'] != null) {
      playersData = [];
      json['players_data'].forEach((v) {
        playersData!.add(PlayersData_.fromJson(v));
      });
    }
  }
  int status =0 ;
  int lineup =0;
  List<PlayersData_>? playersData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (playersData != null) {
      map['players_data'] = playersData!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}