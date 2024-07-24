import 'PlayersData.dart';

class PlayersTeamCreateResponse {
  PlayersTeamCreateResponse({
     required this.status,
    required this.playersData,});

  PlayersTeamCreateResponse.fromJson(dynamic json) {
    status = json['status'] ;
    if (json['players_data'] != null) {
      playersData = [];
      json['players_data'].forEach((v) {
        playersData!.add(PlayersData.fromJson(v));
      });
    }
  }
  dynamic status =0 ;
  List<PlayersData>? playersData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (playersData != null) {
      map['players_data'] = playersData!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}