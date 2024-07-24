import 'dart:ui';

import 'RankingsBat.dart';
import 'RankingsBowl.dart';

class PlayersData {
  PlayersData({
    required this.playerId,
    required this.teamId,
    required this.playing_team_id,
    required  this.imageId,
    required  this.roleType,
    required this.bat,
    required this.bowl,
    required this.name,
    required  this.nickName,
    required this.role,
    required  this.intlTeam,
    required this.image,
    required  this.points,
    required this.byuser,
    required this.backgroundColor,
   });

  PlayersData.fromJson(dynamic json) {
    id = json['id'];
    playerId = json['player_id'] ;
    teamId = json['team_id'] ;
    playing_team_id = json['playing_team_id'] ;
    imageId = json['image_id'] ;
    roleType = json['role_type'];
    bat = json['bat'] ;
    bowl = json['bowl'] ;
    name = json['name'] ;
    nickName = json['nickName'];
    height = json['height'] ;
    role = json['role'];
    birthPlace = json['birthPlace'] ;
    intlTeam = json['intlTeam'];
    teams = json['teams'] ;
    doB = json['DoB'];
    image = json['image'];
    bio = json['bio'];
    rankingsBat = json['rankings_bat'] != null ? RankingsBat.fromJson(json['rankings_bat']) : null;
    rankingsBowl = json['rankings_bowl'] != null ? RankingsBowl.fromJson(json['rankings_bowl']) : null;
    rankingsAll = json['rankings_all'];
    points = json['points'];
    byuser = json['byuser'] ;
    createdAt = json['created_at'] ;
    updatedAt = json['updated_at'] ;
  }

  dynamic id = 0;
  dynamic playerId =0;
  dynamic teamId =0;
  dynamic playing_team_id=0;
  dynamic imageId =0;
  dynamic roleType = '';
  dynamic bat= '';
  dynamic bowl= '';
  dynamic name= '';
  dynamic nickName= '';
  dynamic height= '';
  dynamic role= '';
  dynamic birthPlace= '';
  dynamic intlTeam= '';
  dynamic teams= '';
  dynamic doB= '';
  dynamic image= '';
  dynamic bio= '';
  RankingsBat? rankingsBat;
  RankingsBowl? rankingsBowl;
  dynamic rankingsAll= '';
  dynamic points= 0;
  dynamic byuser = 0;
  dynamic createdAt = '';
  dynamic updatedAt= '';
  Color? backgroundColor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['player_id'] = playerId;
    map['team_id'] = teamId;
    map['playing_team_id'] = playing_team_id;
    map['image_id'] = imageId;
    map['role_type'] = roleType;
    map['bat'] = bat;
    map['bowl'] = bowl;
    map['name'] = name;
    map['nickName'] = nickName;
    map['height'] = height;
    map['role'] = role;
    map['birthPlace'] = birthPlace;
    map['intlTeam'] = intlTeam;
    map['teams'] = teams;
    map['DoB'] = doB;
    map['image'] = image;
    map['bio'] = bio;
    if (rankingsBat != null) {
      map['rankings_bat'] = rankingsBat!.toJson();
    }
    if (rankingsBowl != null) {
      map['rankings_bowl'] = rankingsBowl!.toJson();
    }
    map['rankings_all'] = rankingsAll;
    map['points'] = points;
    map['byuser'] =byuser;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}