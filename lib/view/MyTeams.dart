import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/UserAllTeamContestData/Players.dart';
import 'package:http/http.dart' as http;
import 'package:world11/view/CopyYourTeam.dart';
import '../ApiCallProviderClass/API_Call_Class.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../Model/UserAllTeamContestData/Data.dart';
import '../Model/UserAllTeamContestData/UserAllTeamContestDataResponse.dart';
import '../resourses/Image_Assets/image_assets.dart';
import 'Team Preview.dart';
import 'UpdateCreatedTeam.dart';
import 'create_your_team/createTeam.dart';

class MyTeams extends StatefulWidget {
  var  logo1,logo2,text1,text2 , time_hours ,match_id,team1_Id,team_2_Id,HighestScore , Average_Score;
  MyTeams({super.key,this.logo1,this.logo2,this.text1,this.text2,this.time_hours,this.match_id,this.team1_Id,this.team_2_Id,this.Average_Score,this.HighestScore});

  @override
  State<MyTeams> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  bool captain=true;
  bool vice_captain=false;
  String _token='';
  List<TeamDataAll>? allTeamUserCreateData;
  List<Players>? players_Data=[];
  List<PlayersData_> player_Id=[];
  String total_Points='';
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];
  int team_Id=0;
  List<bool> isLoadingList = List.generate(100, (index) => false);
  List<bool> isLoadingList2 = List.generate(100, (index) => false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();

  }

  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };
  Future<void> fetchUserTeamData() async {
    // Your existing API call logic here
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.fetchUserTeamData(widget.match_id, _token);
  }

  Future<List<Players>?> fetchUserTeamDataByTeamId(String matchId, String token,String team_id) async {
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId&teamID=$team_id';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData=contestDataResponse.data;
          total_Points =allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id=allTeamUserCreateData![0].teamID;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);
          for(int i=0;i<players_Data!.length;i++){
            player_Id.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
              imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
              bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
              name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
              role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
              image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
              byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
              isPlay: players_Data![i].playerDetails!.isPlay, captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
            ));

            if(players_Data![i].playerDetails!.roleType == "WICKET KEEPER"){
              Wk_PlayersData.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BATSMEN"){
              BatData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "ALL ROUNDER"){
              ARData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BOWLER"){
              BowlData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId, playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          print("Data___::::::::::::"+Wk_PlayersData.length.toString());
          print("Data___::::::::::::"+BatData_Player.length.toString());
          print("Data___::::::::::::"+ARData_Player.length.toString());
          print("Data___::::::::::::"+BowlData_Player.length.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCreatedTeam(
            time_hours: widget.time_hours,team2_id: widget.team_2_Id,
            team1_id: widget.team1_Id,Match_id: widget.match_id,logo1: widget.logo1,
            logo2: widget.logo2,text1: widget.text1,text2: widget.text2,teamDataAll: player_Id,captain_id: allTeamUserCreateData![0].captain!.playerId,
            vice_captain_Id: allTeamUserCreateData![0].viceCaptain!.playerId, Wk_PlayersData: Wk_PlayersData,
            BowlData_Player: BowlData_Player, ARData_Player: ARData_Player, BatData_Player: BatData_Player,total_Points: total_Points, team_Id: team_Id,
            selected_Captain_Name: allTeamUserCreateData![0].captain!.nickName,selected_Vice_Captain_Name: allTeamUserCreateData![0].viceCaptain!.nickName,
            HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
            Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
          )));
          return contestDataResponse.data![0].players;
        } else if (contestDataResponse.status == 0) {

          return contestDataResponse.data![0].players;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      } else {
        // Handle other errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }

  Future<List<Players>?> CopyUserTeamDataByTeamId(String matchId, String token,String team_id) async {
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId&teamID=$team_id';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData=contestDataResponse.data;
          total_Points =allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id=allTeamUserCreateData![0].teamID;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);
          for(int i=0;i<players_Data!.length;i++){
            player_Id.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
              imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
              bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
              name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
              role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
              image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
              byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
              isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
            ));

            if(players_Data![i].playerDetails!.roleType == "WICKET KEEPER"){
              Wk_PlayersData.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BATSMEN"){
              BatData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "ALL ROUNDER"){
              ARData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BOWLER"){
              BowlData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                  byuser: players_Data![i].playerDetails!.imageId, playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          print("Data___::::::::::::"+Wk_PlayersData.length.toString());
          print("Data___::::::::::::"+BatData_Player.length.toString());
          print("Data___::::::::::::"+ARData_Player.length.toString());
          print("Data___::::::::::::"+BowlData_Player.length.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => CopyYourTeam(
            time_hours: widget.time_hours,team2_id: widget.team_2_Id,
            team1_id: widget.team1_Id,Match_id: widget.match_id,logo1: widget.logo1,
            logo2: widget.logo2,text1: widget.text1,text2: widget.text2,teamDataAll: player_Id,captain_id: allTeamUserCreateData![0].captain!.playerId,
            vice_captain_Id: allTeamUserCreateData![0].viceCaptain!.playerId, Wk_PlayersData: Wk_PlayersData,
            BowlData_Player: BowlData_Player, ARData_Player: ARData_Player, BatData_Player: BatData_Player,total_Points: total_Points, team_Id: team_Id,
            selected_Captain_Name: allTeamUserCreateData![0].captain!.nickName,selected_Vice_Captain_Name: allTeamUserCreateData![0].viceCaptain!.nickName,
            HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
            Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
          )));
          return contestDataResponse.data![0].players;
        } else if (contestDataResponse.status == 0) {

          return contestDataResponse.data![0].players;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      } else {
        // Handle other errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }




  Future<List<Players>?> fetchUserTeamDataByTeam(String matchId, String token) async {
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final contestDataResponse = UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData=contestDataResponse.data;
          total_Points =allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id=allTeamUserCreateData![0].teamID;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);
          for(int i=0;i<players_Data!.length;i++){
            player_Id.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
              imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
              bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
              name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
              role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
              image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
              byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
              isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
            ));

            if(players_Data![i].playerDetails!.roleType == "WICKET KEEPER"){
              Wk_PlayersData.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BATSMEN"){
              BatData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "ALL ROUNDER"){
              ARData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BOWLER"){
              BowlData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId, playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          print("Data___::::::::::::"+Wk_PlayersData.length.toString());
          print("Data___::::::::::::"+BatData_Player.length.toString());
          print("Data___::::::::::::"+ARData_Player.length.toString());
          print("Data___::::::::::::"+BowlData_Player.length.toString());
          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateCreatedTeam(
          //   time_hours: widget.time_hours,team2_id: widget.team_2_Id,
          //   team1_id: widget.team1_Id,Match_id: widget.match_id,logo1: widget.logo1,
          //   logo2: widget.logo2,text1: widget.text1,text2: widget.text2,teamDataAll: player_Id,captain_id: allTeamUserCreateData![0].captain!.playerId,
          //   vice_captain_Id: allTeamUserCreateData![0].viceCaptain!.playerId, Wk_PlayersData: Wk_PlayersData,
          //   BowlData_Player: BowlData_Player, ARData_Player: ARData_Player, BatData_Player: BatData_Player,total_Points: total_Points, team_Id: team_Id,
          //   selected_Captain_Name: allTeamUserCreateData![0].captain!.nickName,selected_Vice_Captain_Name: allTeamUserCreateData![0].viceCaptain!.nickName,
          //   HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
          //   Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
          // )));
          return contestDataResponse.data![0].players;
        } else if (contestDataResponse.status == 0) {

          return contestDataResponse.data![0].players;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      } else {
        // Handle other errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;

    });
    fetchUserTeamData();
    fetchUserTeamDataByTeam(widget.match_id,_token);
  }

  @override
  Widget build(BuildContext context) {
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context,listen: false);
    var size = MediaQuery.of(context).size;
    return   Scaffold(
      backgroundColor: Color(0xFFDFE4EB),
      appBar:AppBar(
        backgroundColor: Color(0xff780000),
        title: Column(
          children: [
            Text(
              'My Teams',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            CountdownTimerWidget(time: widget.time_hours)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
            child: Text(
              'My Teams(${apiProvider.allTeamUserCreateData != null ? apiProvider.allTeamUserCreateData.length : 0})',
              style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,fontSize: 15)
              ,),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: apiProvider.allTeamUserCreateData != null && apiProvider.allTeamUserCreateData.isNotEmpty
                  ? ListView.builder(
                  itemCount: apiProvider.allTeamUserCreateData.length,
                  itemBuilder: (context, index) {
                  final event=apiProvider.allTeamUserCreateData[index];
                  print("AHGdsghsduMatch_id"+event.teamID.toString());

                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey, // Set the color of the border
                          width: 2.0,         // Set the width of the border
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        event.teamName,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if(apiProvider.is_lineupOut == 1 && event.isNotPlayCount > 0)
                                        Row(
                                          children: [
                                            Image(image: AssetImage(ImageAssets.RedCircle),height: 10,width: 10,),
                                            Text(
                                              "Unannounced Player (${event.isNotPlayCount})",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            ),
                                          ],
                                        ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  isLoadingList2[index] = true;
                                                });
                                                allTeamUserCreateData = null;
                                                players_Data = [];
                                                Wk_PlayersData = [];
                                                BatData_Player = [];
                                                ARData_Player = [];
                                                BowlData_Player = [];
                                                player_Id = [];
                                                CopyUserTeamDataByTeamId(widget.match_id, _token, event.teamID.toString())
                                                    .then((result) {
                                                  setState(() {
                                                    isLoadingList2[index] = false;
                                                  });
                                                });
                                              },
                                              child: isLoadingList2[index]
                                                  ? Center(
                                                  child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      child:  SpinKitFadingCircle(color: Colors.redAccent,)
                                                  )
                                              )
                                                  : Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),

                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                isLoadingList[index] = true;
                                              });
                                              allTeamUserCreateData = null;
                                              players_Data = [];
                                              Wk_PlayersData = [];
                                              BatData_Player = [];
                                              ARData_Player = [];
                                              BowlData_Player = [];
                                              player_Id = [];
                                              fetchUserTeamDataByTeamId(widget.match_id, _token, event.teamID.toString())
                                                  .then((result) {
                                                setState(() {
                                                  isLoadingList[index] = false;
                                                });
                                              });
                                            },
                                            child: isLoadingList[index]
                                                ? Center(
                                                child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child:  SpinKitFadingCircle(color: Colors.redAccent,)
                                                )
                                            )
                                                : Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              players_Data=[];
                              Wk_PlayersData=[];
                              BatData_Player=[];
                              ARData_Player=[];
                              BowlData_Player=[];
                              total_Points =allTeamUserCreateData![0].totalCreditPointsUsed.toString();
                              players_Data!.addAll(event.players ?? []);
                              for(int i=0;i<players_Data!.length;i++){
                                player_Id.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                                  imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                                  bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                                  name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                                  role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                                  image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                                  byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                                  isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
                                ));
                                if(players_Data![i].playerDetails!.roleType == "WICKET KEEPER"){
                                  Wk_PlayersData.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                                    imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                                    bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                                    name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                                    role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                                    image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                                    byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                                      captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                                    isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
                                  ));
                                }
                                if(players_Data![i].playerDetails!.roleType == "BATSMEN"){
                                  BatData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                                    imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                                    bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                                    name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                                    role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                                    image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                                    byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                                      captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                                    isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
                                  ));
                                }
                                if(players_Data![i].playerDetails!.roleType == "ALL ROUNDER"){
                                  ARData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                                    imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                                    bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                                    name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                                    role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                                    image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                                    byuser: players_Data![i].playerDetails!.imageId,playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                                      captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                                    isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
                                  ));
                                }
                                if(players_Data![i].playerDetails!.roleType == "BOWLER"){
                                  BowlData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId, teamId: players_Data![i].teamID,
                                    imageId: players_Data![i].playerDetails!.imageId, roleType: players_Data![i].playerDetails!.roleType,
                                    bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                                    name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                                    role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                                    image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points,
                                    byuser: players_Data![i].playerDetails!.imageId, playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                                      captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                                    isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
                                  ));
                                }
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  TeamPreview(batsmen: BatData_Player,
                                    bowlers: BowlData_Player,
                                    allrounders: ARData_Player,
                                    wicketkeeper: Wk_PlayersData,
                                    points: points,
                                    time_hours: widget.time_hours,
                                    team1: widget.text1,
                                    team2: widget.text2,
                                    team1_id: widget.team1_Id,
                                    team2_id: widget.team_2_Id,
                                    credits_Points:total_Points,
                                    lineup: apiProvider.is_lineupOut,
                                  )
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5),
                              child: Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(ImageAssets.Ground2), // Replace "assets/background_image.jpg" with your image path
                                      fit: BoxFit.fitWidth,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,top:10),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipOval(
                                                          child: Center(
                                                            child: CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage: NetworkImage(event.captain!.image)
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: -2.2,
                                                          right: 1.5,
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.blue[700],
                                                            radius: 7,
                                                            child: Center(
                                                              child: Text('C', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10))
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(15)
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          (event.captain!.nickName.length > 10)
                                                              ? '${event.captain!.nickName.substring(0, 10)}...'
                                                              : event.captain!.nickName,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15,top:10),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipOval(
                                                          child:Center(
                                                            child: CircleAvatar(
                                                                radius: 20,
                                                                backgroundImage: NetworkImage(event.viceCaptain!.image)
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: -2.2,
                                                          right: 1.5,
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.blue[700],
                                                            radius: 7,
                                                            child: Center(
                                                              child: Text('VC', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 20,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius: BorderRadius.circular(15)
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          (event.viceCaptain!.nickName.length > 10)
                                                              ? '${event.viceCaptain!.nickName.substring(0, 10)}...'
                                                              : event.viceCaptain!.nickName,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top:10,right: 15),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      widget.text1.toString(),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      event.selectedTeamPlayer1.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:10,left: 10),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      widget.text2.toString(),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      event.selectedTeamPlayer2.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                  Consumer<ApiProvider>(
                                    builder: (context, dataModel, child) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'WK 3'
                                                  // '${dataModel.allWKCreateData.length}'
                                                  '',  // Replace 'wk' with the actual property in your data model
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'BAT 4'
                                                  // '${dataModel.allBatCreateData.length}'
                                                  '',  // Replace 'bat' with the actual property in your data model
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'AR 2'
                                                  // '${dataModel.allARCreateData.length}'
                                                  '',  // Replace 'ar' with the actual property in your data model
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'BOWL 2'
                                                  // '${dataModel.allBowlCreateData.length}'
                                                  '',  // Replace 'bowl' with the actual property in your data model
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                  ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text("No teams available"),
              ),
            ),
          ),

          Stack(
            children: [
              Container(
                width: double.infinity,
                height: size.height * 0.1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFe9f7df),
                      Color(0xFFf7e9df),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>CreateTeam(
                          logo2: widget.logo2,
                          logo1: widget.logo1,
                          text2: widget.text2,
                          text1: widget.text1,
                          time_hours: widget.time_hours,
                          Match_id: widget.match_id,
                          team1_id: widget.team1_Id,
                          team2_id: widget.team_2_Id,
                          HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                          Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
                        )
                        )
                    );
                  },
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTeam(
                                logo2: widget.logo2,
                                logo1: widget.logo1,
                                text2: widget.text2,
                                text1: widget.text1,
                                time_hours: widget.time_hours,
                                Match_id: widget.match_id,
                                team1_id: widget.team1_Id,
                                team2_id: widget.team_2_Id,
                                HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                                Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
                              )
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20,top: 20),
                      height: size.height *.05,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: Center(
                        child: Text('Create Team',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class CountdownTimerWidget extends StatefulWidget {
  final String time;

  CountdownTimerWidget({required this.time});

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();

    // Parse the provided time string to get the target time
    DateTime targetTime = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time));

    // Calculate the remaining time
    _remainingTime = targetTime.difference(DateTime.now());

    // Start a timer to update the UI every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Check if the remaining time is greater than 0
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = targetTime.difference(DateTime.now());
        } else {
          timer.cancel();
          _remainingTime = Duration(seconds: 0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatDuration(_remainingTime);

    return Text(
      formattedTime,
      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      // Format the date along with the time
      DateTime targetDate = DateTime.now().add(duration);
      String formattedDate = DateFormat('dd MMM yyyy').format(targetDate);
      return '$formattedDate';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h : ${(duration.inMinutes % 60).toString().padLeft(2, '0')}m : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
    } else {
      return '${duration.inMinutes}m : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}s';
    }
  }

}
