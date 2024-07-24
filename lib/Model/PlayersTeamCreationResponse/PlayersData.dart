import 'RankingsBat.dart';
import 'RankingsBowl.dart';

class PlayersData_ {
  PlayersData_({
    required this.playerId,
    required this.teamId,
    required this.playingTeamId,
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
    this.captain,
    this.viceCaptain,
    required this.isPlay,
    required this.captionByuser,
    required this.VoiceCaptionByuser
  });

  PlayersData_.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    playerId = json['player_id'] ?? 0;
    teamId = json['team_id'] ;
    playingTeamId = json['playing_team_id'] ?? 0;
    imageId = json['image_id'] ?? 0;
    roleType = json['role_type'] ?? '' ;
    bat = json['bat']  ?? '';
    bowl = json['bowl']  ?? '';
    name = json['name']  ?? '';
    nickName = json['nickName']  ?? '';
    role = json['role']  ?? '';
    intlTeam = json['intlTeam'] ?? '' ;
    image = json['image'] ?? '';
    teams = json['teams'] ?? '' ;
    // rankingsBat = json['rankings_bat'] != null ? RankingsBat.fromJson(json['rankings_bat']) : null;
    // rankingsBowl = json['rankings_bowl'] != null ? RankingsBowl.fromJson(json['rankings_bowl']) : null;
    // rankingsAll = json['rankings_all'] ?? '';
    points = json['points']  ?? 0;
    isPlay = json['isPlay']  ?? 0;
    captain = json['captain'] ?? 0;
    viceCaptain = json['viceCaptain'] ?? 0;
    last_match_playing = json['last_match_playing']  ?? 0;
    byuser = json['byuser']  ?? 0;
    VoiceCaptionByuser = json['VoiceCaptionByuser']  ?? 0;
    captionByuser = json['captionByuser']  ?? 0;
    total_points_in_series = json['total_points_in_series']  ?? 0;
  }
  int id = 0;
  int playerId = 0;
  dynamic teamId = 0;
  int playingTeamId = 0;
  int imageId = 0;
  dynamic captain = 0;
  dynamic viceCaptain = 0;
  dynamic roleType = '';
  dynamic bat = '';
  dynamic bowl = '';
  dynamic name = '';
  dynamic nickName = '';
  dynamic role = '';
  dynamic intlTeam = '';
  dynamic image = '';
  dynamic teams = '';
  // RankingsBat? rankingsBat;
  // RankingsBowl? rankingsBowl;
  // dynamic rankingsAll = '';
  int points = 0;
  int isPlay = 0;
  int last_match_playing=0;
  int byuser = 0;
  int captionByuser=0;
  int VoiceCaptionByuser=0;
  int total_points_in_series=0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['player_id'] = playerId;
    map['team_id'] = teamId;
    map['playing_team_id'] = playingTeamId;
    map['image_id'] = imageId;
    map['role_type'] = roleType;
    map['bat'] = bat;
    map['bowl'] = bowl;
    map['name'] = name;
    map['nickName'] = nickName;
    map['role'] = role;
    map['intlTeam'] = intlTeam;
    map['image'] = image;
    map['teams'] = teams;
    map['viceCaptain'] = viceCaptain;
    map['captain'] = captain;
    // if (rankingsBat != null) {
    //   map['rankings_bat'] = rankingsBat!.toJson();
    // }
    // if (rankingsBowl != null) {
    //   map['rankings_bowl'] = rankingsBowl!.toJson();
    // }
    // map['rankings_all'] = rankingsAll;
    map['points'] = points;
    map['isPlay'] = isPlay;
    map['last_match_playing'] = last_match_playing;
    map['byuser'] = byuser;
    map['total_points_in_series'] = total_points_in_series;
    return map;
  }

}