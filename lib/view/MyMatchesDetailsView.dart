import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/PlayersTeamCreationResponse/PlayersData.dart';
import 'package:world11/Model/UserAllTeamContestData/Data.dart';
import '../../ApiCallProviderClass/API_Call_Class.dart';
import '../../App_Widgets/CustomText.dart';
import '../../Model/Lenback_Data_For_Live/Data.dart';
import '../../Model/Lenback_Data_For_Live/LenBack_Api_Response.dart';
import '../../Model/LiveMatchPlayers_Image_Data/Data.dart';
import '../../Model/LiveMatchPlayers_Image_Data/Live_Match_Player_Data.dart';
import '../../Model/LiveMatchScorecardDataPlayers/LiveScorecard.dart';
import '../../Model/Upcoming_New_Model/Data.dart';
import '../../Model/Upcoming_New_Model/Upcoming_New_Api_Response.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Model/GetLeaderBoard/Data.dart';
import '../Model/GetLeaderBoard/GetLeaderBoardResponse.dart';
import '../Model/UserAllTeamContestData/Players.dart';
import '../Model/UserAllTeamContestData/UserAllTeamContestDataResponse.dart';
import '../Model/WinningsModel/PrizeDistributions.dart';
import '../Model/WinningsModel/WinningsResponseModel.dart';
import 'Add Cash In Wallet.dart';
import 'TeamPreviewAfterCompleteMatch.dart';

class MyMatchesDetailsView extends StatefulWidget {
  final logo1,
      logo2,
      text1,
      text2,
      stats,
      Match_id,
      team1_id,
      team2_id,
      Contest_Id,
      winnings;
  MyMatchesDetailsView(
      {super.key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.stats,
      this.Match_id,
      this.team1_id,
      this.team2_id,
      this.Contest_Id,
      this.winnings});

  @override
  State<MyMatchesDetailsView> createState() => _MyMatchesDetailsViewState();
}

class _MyMatchesDetailsViewState extends State<MyMatchesDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _email;
  String? _userName;
  String _token = '';
  Future<List<UpcomingMatch_Recents_Data>?>? future;
  Future<List<LiveMatch_Players_Image_Data>?>? future_data;
  Future<List<LiveScoreNewData>?>? ScorecardData;
  bool isExpanded1 = true;
  List<Players>? players_Data = [];
  List<String> player_Id = [];
  Map<int, bool> isContainerVisibleMap = {};
  Future<List<LeaderBoardData>?>? contest_Data;
  List<TeamDataAll>? allTeamUserCreateData;
  String total_Points = '';
  int team_Id = 0;
  bool _isLoading = false;

  List<PlayersData_> Wk_PlayersData = [];
  List<PlayersData_> BatData_Player = [];
  List<PlayersData_> ARData_Player = [];
  List<PlayersData_> BowlData_Player = [];

  List<String> Wk_points_data = [];
  List<String> Bat_points_data = [];
  List<String> AR_points_data = [];
  List<String> Bowl_points_data = [];
  Future<List<PrizeDistributions>?>? winningsData;

  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();

    ScorecardData = FetchScoreCardData(widget.Match_id);
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> fetchUserTeam() async {
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    apiProvider.fetchUserTeamData(widget.Match_id, _token);
    apiProvider.fetchData(widget.Match_id, _token);
  }

  Future<List<UpcomingMatch_Recents_Data>?> fetchUpcomingMatches(
      String type) async {
    final String apiUrl =
        'https://admin.googly11.in/api/matchesDataInDatabaseGet?type=$type&pageSize=2';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          // Add any additional headers here if needed
        },
      );

      if (response.statusCode == 200) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if (upcomingMatch.allData != null && upcomingMatch.allData != "") {
            return upcomingMatch.allData!.data;
          } else {}
          return upcomingMatch.allData!.data;
        }
        return upcomingMatch.allData!.data;
      } else if (response.statusCode == 400) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          return upcomingMatch.allData!.data;
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<List<LeaderBoardData>?> fetchDataMatchLeader(
      int match_Id, int contest_ID) async {
    print(
        "match_id:::::::" + match_Id.toString() + "::" + contest_ID.toString());
    final String apiUrl =
        'https://admin.googly11.in/api/get_leader_board_with_match';

    final Uri uri =
        Uri.parse('$apiUrl?match_id=$match_Id&contest_id=$contest_ID');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        print("LeaderBoarddata>>"+response.body.toString());
        GetLeaderBoardResponse boardResponse =
            GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if (boardResponse.status == 1) {
          return boardResponse.data;
        } else {
          // print('Error: ${response.statusCode}');
          // print('Response body: ${response.body}');
          return boardResponse.data;
        }
      } else if (response.statusCode == 400) {
        GetLeaderBoardResponse boardResponse =
            GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if (boardResponse.status == 0) {
          return boardResponse.data;
        }
        // print('Error: ${response.statusCode}');
        // print('Response body: ${response.body}');
      } else {
        // print('Error: ${response.statusCode}');
        // print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<List<LiveScoreNewData>?> FetchScoreCardData(String match_Id) async {
    final url = Uri.parse(
        'https://admin.googly11.in/api/match_score_card?match_id=$match_Id');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    print('Failed to load data: ${response.body}');
    if (response.statusCode == 200) {
      LiveMatchScoreCardData liveMatchScoreCard =
          LiveMatchScoreCardData.fromJson(json.decode(response.body));
      if (liveMatchScoreCard.status == 1) {
        print('Failed to load data: ${response.body}dfjgjg');
        return liveMatchScoreCard.data;
      }
    } else if (response.statusCode == 401) {
      LiveMatchScoreCardData liveMatchScoreCard =
          LiveMatchScoreCardData.fromJson(json.decode(response.body));
      print('Failed to load data: ${response.statusCode}');
      return liveMatchScoreCard.data;
    }
    return null;
  }

  void getPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? token = prefs.getString("token");
    setState(() {
      _email = email;
      _userName = userName;
      _token = token!;
      contest_Data = fetchDataMatchLeader(int.parse(widget.Match_id.toString()),
          int.parse(widget.Contest_Id.toString()));
      fetchUserTeam();
    });
    future_data = Players_Data(widget.Match_id, _token,
        widget.team1_id.toString(), widget.team2_id.toString());
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
    winningsData = fetchWinnersData(int.parse(widget.Match_id.toString()),
        int.parse(widget.Contest_Id.toString()));
  }

  Future<List<PrizeDistributions>?> fetchWinnersData(
      int match_Id, int contest_ID) async {
    print(
        "match_id:::::::" + match_Id.toString() + "::" + contest_ID.toString());
    final String apiUrl =
        'https://admin.googly11.in/api/get_winnigs_user_contest?match_id=$match_Id&contest_id=$contest_ID';

    final Uri uri =
        Uri.parse('$apiUrl?match_id=$match_Id&contest_id=$contest_ID');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      // print('Error::::::::::346565 ${response.statusCode}');
      // print('Response body:::::::::::::347843790 ${response.body}');
      if (response.statusCode == 200) {
        WinningsResponseModel boardResponse =
            WinningsResponseModel.fromJson(json.decode(response.body));
        if (boardResponse.status == 1) {
          // print('Error:::: ${response.statusCode}');
          // print('Response body::::::: ${response.body}');
          return boardResponse.data!.prizeDistributions;
        } else {
          // print('Error: ${response.statusCode}');
          // print('Response body: ${response.body}');
          return boardResponse.data!.prizeDistributions;
        }
      } else if (response.statusCode == 400) {
        WinningsResponseModel boardResponse =
            WinningsResponseModel.fromJson(json.decode(response.body));
        if (boardResponse.status == 0) {
          return boardResponse.data!.prizeDistributions;
        }
        // print('Error: ${response.statusCode}');
        // print('Response body: ${response.body}');
      } else {
        // print('Error: ${response.statusCode}');
        // print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<List<LiveMatch_Players_Image_Data>?> Players_Data(String match_id,
      String bearerToken, String team1_id, String team2_id) async {
    final String apiUrl =
        "https://admin.googly11.in/api/get_Live_Match_Team?match_id=$match_id&team_id_1=$team1_id&team_id_2=$team2_id";
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      });
      print("Error: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        print("response: ${response.statusCode}");
        LiveMatchPlayerData leanBackData =
            LiveMatchPlayerData.fromJson(json.decode(response.body));
        print("Body:::: ${leanBackData.status}");
        if (leanBackData.status == 1) {
          return leanBackData.data;
        } else {
          leanBackData.data;
        }
      } else {
        // Handle the error
        // print("Error: ${response.statusCode}");
        // print("Body: ${response.body}");
      }
    } catch (e) {
      // Handle other potential errors
      print("Error: $e");
    }
    return null;
  }

  Future<List<Players>?> fetchUserTeamDataByTeamId(
      String matchId, String token, String team_id) async {
    final url =
        'https://admin.googly11.in/api/user_All_Contest_Data2?match_id=$matchId&teamID=$team_id';
    print("data:::::::::::::::::::::::::::::::::::" + url);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Data:::::::::::" + response.body);
      if (response.statusCode == 200) {
        final contestDataResponse =
            UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData = contestDataResponse.data;
          total_Points =
              allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id = allTeamUserCreateData![0].teamID;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);

          for (int i = 0; i < players_Data!.length; i++) {
            player_Id.add(players_Data![i].playerDetails!.playerId.toString());

            if (players_Data![i].playerDetails!.roleType == "WICKET KEEPER") {
              Wk_points_data.add(players_Data![i].totalMatchPoints.toString());
              print("Wicket:::::" + Wk_points_data.toString());
              Wk_PlayersData.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,
                playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,
                viceCaptain: players_Data![i].viceCaptain,
                captain: players_Data![i].captain,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "BATSMEN") {
              Bat_points_data.add(players_Data![i].totalMatchPoints.toString());
              print("BATSMEN:::::" + Bat_points_data.toString());
              BatData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,
                playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,
                viceCaptain: players_Data![i].viceCaptain,
                captain: players_Data![i].captain,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "ALL ROUNDER") {
              AR_points_data.add(players_Data![i].totalMatchPoints.toString());
              print("ALL ROUNDER:::::" + AR_points_data.toString());
              ARData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,
                playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,
                viceCaptain: players_Data![i].viceCaptain,
                captain: players_Data![i].captain,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "BOWLER") {
              Bowl_points_data.add(
                  players_Data![i].totalMatchPoints.toString());
              print("BOWLER:::::" + Bowl_points_data.toString());
              BowlData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points,
                byuser: players_Data![i].playerDetails!.imageId,
                playingTeamId: players_Data![i].playerDetails!.playing_team_id,
                isPlay: players_Data![i].playerDetails!.isPlay,
                viceCaptain: players_Data![i].viceCaptain,
                captain: players_Data![i].captain,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeamPreviewAfterCompleteMatch(
                      batsmen: BatData_Player,
                      bowlers: BowlData_Player,
                      allrounders: ARData_Player,
                      wicketkeeper: Wk_PlayersData,
                      points: points,
                      time_hours: "",
                      team1: widget.text1,
                      team2: widget.text2,
                      team2_id: widget.team2_id,
                      team1_id: widget.team1_id,
                      Wk_points_Data: Wk_points_data,
                      Bat_points_Data: Bat_points_data,
                      AR_points_Data: AR_points_data,
                      Bowl_points_Data: Bowl_points_data,
                      credits_Points: total_Points)));
          return contestDataResponse.data![0].players;
        } else if (contestDataResponse.status == 0) {
          return contestDataResponse.data![0].players;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      } else if (response.statusCode == 404) {
        // Handle other errors
        final contestDataResponse =
            UserAllTeamContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
        } else if (contestDataResponse.status == 0) {
          Fluttertoast.showToast(
              msg: "No Team Preview Allow Other Players",
              textColor: Colors.white,
              backgroundColor: Colors.black);
        }
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }

  Future<LenBack_Data_For_Live?> fetchData(
      String match_id, String bearerToken) async {
    final String apiUrl =
        "https://admin.googly11.in/api/get_leanback?match_id=$match_id";
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      });
      print("Error: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        print("response: ${response.statusCode}");
        LenBackApiResponse leanBackData =
            LenBackApiResponse.fromJson(json.decode(response.body));
        print("Body:::: ${leanBackData.status}");
        if (leanBackData.status == 1) {
          return leanBackData.data;
        } else {
          leanBackData.data;
        }
      } else {
        // Handle the error
        print("Error: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      // Handle other potential errors
      print("Error: $e");
    }
    return null;
  }

  Stream<LenBack_Data_For_Live?> fetchDataPeriodically(
      String match_id, String bearerToken) async* {
    while (true) {
      yield await fetchData(match_id, bearerToken);
      await Future.delayed(Duration(seconds: 15));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff780000),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '${widget.text1} vs ${widget.text2}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.stats}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCashInWallet()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Set the border color
                      width: 1.5, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        12.0), // Set the border radius if you want rounded corners
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0), // Add padding to the text
                        child: Text(
                          "Add Cash".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Image(
                        image: AssetImage(ImageAssets.wallet64),
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<LenBack_Data_For_Live?>(
        stream: fetchDataPeriodically(widget.Match_id, _token),
        builder: (BuildContext context,
            AsyncSnapshot<LenBack_Data_For_Live?> snapshot) {
          // Check the connection state of the future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.redAccent,
                size: 50.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: [
                Container(
                  height: size.height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: snapshot.data != null &&
                                      snapshot.data!.matchScoreDetails!
                                              .inningsScoreList![1].batTeamName
                                              .toString() ==
                                          widget.text1.toString()
                                  ? MemoryImage(base64Decode(widget.logo1))
                                  : MemoryImage(base64Decode(widget.logo2)),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data != null ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].batTeamName}" : "----"}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${snapshot.data != null ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![1].wickets}" : "----"}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            CustomPaddedText(
                                text: widget.stats,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[300],
                                    fontSize: 12)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomPaddedText(
                                  text:
                                      "${snapshot.data != null ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName}" : "----"}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    snapshot.data != null
                                        ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![0].wickets}"
                                        : "----",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            CircleAvatar(
                              backgroundImage: snapshot.data != null &&
                                      snapshot.data!.matchScoreDetails!
                                              .inningsScoreList![0].batTeamName
                                              .toString() ==
                                          widget.text2.toString()
                                  ? MemoryImage(base64Decode(widget.logo2))
                                  : MemoryImage(base64Decode(widget.logo1)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 40, right: 40, top: 10),
                        child: Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        snapshot.data != null
                            ? snapshot.data!.matchScoreDetails!.customStatus
                            : '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.winnings.toString() != "0.00")
                  Container(
                    height: size.height * 0.08,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.winnings.toString() != "0.00")
                          Text(
                            "Congratulations! You've won in 1 contest ",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                            ),
                          ),
                        if (widget.winnings.toString() != "0.00")
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Image.asset(
                                  ImageAssets
                                      .win, // Replace with the path to your winners logo
                                  height: 30, // Adjust the height as needed
                                  width: 30, // Adjust the width as needed
                                ),
                              ),
                              Text(
                                "Rs" + widget.winnings.toString() != ""
                                    ? widget.winnings.toString()
                                    : '',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      DefaultTabController(
                        length: 3, // Set the length to the number of tabs
                        child: Expanded(
                          child: Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.red,
                                indicatorColor: Colors.transparent,
                                controller: _tabController,
                                unselectedLabelColor: Colors.black,
                                indicator: UnderlineTabIndicator(
                                  borderSide:
                                      BorderSide(width: 2.0, color: Colors.red),
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                                tabs: [
                                  Tab(
                                    child: Text(
                                      'Leaderboard',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Winnings',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Player Stats',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'Scoreboard',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.grey[300],
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      Container(
                                        color: Color(0xFFfffcf7),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Rank'.tr),
                                                  Text('Teams'),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: FutureBuilder<
                                                  List<LeaderBoardData>?>(
                                                future: contest_Data,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          SpinKitFadingCircle(
                                                        color:
                                                            Color(0xff780000),
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text('No Internet' +
                                                        snapshot.error
                                                            .toString());
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    return RefreshIndicator(
                                                      color: Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      onRefresh: () async {
                                                        await Future.delayed(
                                                          const Duration(
                                                              seconds: 2),
                                                        );
                                                        setState(() {
                                                          contest_Data = fetchDataMatchLeader(
                                                              int.parse(widget
                                                                      .Match_id
                                                                  .toString()),
                                                              int.parse(widget
                                                                          .Contest_Id !=
                                                                      null
                                                                  ? widget.Contest_Id
                                                                      .toString()
                                                                  : "3"));
                                                        });
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                              'Opps! No Leaderboard data available')),
                                                    );
                                                  } else {
                                                    return RefreshIndicator(
                                                      color: Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      onRefresh: () async {
                                                        await Future.delayed(
                                                          const Duration(
                                                              seconds: 2),
                                                        );
                                                        setState(() {
                                                          contest_Data = fetchDataMatchLeader(
                                                              int.parse(widget
                                                                      .Match_id
                                                                  .toString()),
                                                              int.parse(widget
                                                                          .Contest_Id !=
                                                                      null
                                                                  ? widget.Contest_Id
                                                                      .toString()
                                                                  : "3"));
                                                        });
                                                      },
                                                      child: _isLoading
                                                          ? Center(
                                                              child:
                                                                  SpinKitFadingCircle(
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 50.0,
                                                            ))
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              child: ListView
                                                                  .separated(
                                                                itemCount:
                                                                    snapshot
                                                                        .data!
                                                                        .length,
                                                                separatorBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 0.5,
                                                                ),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final event =
                                                                      snapshot.data![
                                                                          index];
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            true; // Show progress bar
                                                                        players_Data =
                                                                            [];
                                                                        Wk_PlayersData =
                                                                            [];
                                                                        BatData_Player =
                                                                            [];
                                                                        ARData_Player =
                                                                            [];
                                                                        BowlData_Player =
                                                                            [];
                                                                        Wk_points_data =
                                                                            [];
                                                                        Bat_points_data =
                                                                            [];
                                                                        AR_points_data =
                                                                            [];
                                                                        Bowl_points_data =
                                                                            [];
                                                                      });
                                                                      fetchUserTeamDataByTeamId(
                                                                              widget.Match_id,
                                                                              _token,
                                                                              event.teamID.toString())
                                                                          .then((_) {
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              false; // Hide progress bar
                                                                        });
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      color: event.isCurrentUser ==
                                                                              true
                                                                          ? Colors.yellow[
                                                                              50]
                                                                          : Colors
                                                                              .white,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Align(
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        event.isCurrentUser == true ? "# " + event.rank.toString() : event.rank.toString(),
                                                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Align(
                                                                                      alignment: Alignment.topCenter,
                                                                                      child: event.winnings.isNotEmpty && event.winnings.toString() != "0.00"
                                                                                          ? Text(
                                                                                        event.isCurrentUser == true ? "You won Rs ${event.winnings}" : "Winnings Rs ${event.winnings}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: event.winnings.isNotEmpty && event.winnings.toString() == "0.00" ? Colors.black : Colors.green,
                                                                                        ),
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      )
                                                                                          : Text(
                                                                                        "No winnings",
                                                                                        style: TextStyle(
                                                                                          fontSize: 10,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: event.winnings.isNotEmpty && event.winnings.toString() == "0.00" ? Colors.black : Colors.green,
                                                                                        ),
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                      ),
                                                                                    ),
                                                                                  )

                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                event.total_player_points.toString() + " pts",
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                event.userName.toString(),
                                                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Color(0xFFfffcf7),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Rank'.tr),
                                                  Text('Prizes'),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: FutureBuilder<
                                                  List<PrizeDistributions>?>(
                                                future: winningsData,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                          SpinKitFadingCircle(
                                                        color:
                                                            Color(0xff780000),
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text('No Internet ' +
                                                        snapshot.error
                                                            .toString());
                                                  } else if (!snapshot
                                                      .hasData) {
                                                    return RefreshIndicator(
                                                      color: Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      onRefresh: () async {
                                                        await Future.delayed(
                                                          const Duration(
                                                              seconds: 2),
                                                        );
                                                        setState(() {
                                                          winningsData = fetchWinnersData(
                                                              int.parse(widget
                                                                      .Match_id
                                                                  .toString()),
                                                              int.parse(widget
                                                                      .Contest_Id
                                                                  .toString()));
                                                        });
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                              'No Details available. Please Join a Contest')),
                                                    );
                                                  } else {
                                                    return RefreshIndicator(
                                                      color: Colors.red,
                                                      backgroundColor:
                                                          Colors.white,
                                                      onRefresh: () async {
                                                        await Future.delayed(
                                                          const Duration(
                                                              seconds: 2),
                                                        );
                                                        setState(() {
                                                          winningsData = fetchWinnersData(
                                                              int.parse(widget
                                                                      .Match_id
                                                                  .toString()),
                                                              int.parse(widget
                                                                      .Contest_Id
                                                                  .toString()));
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        child:
                                                            ListView.separated(
                                                          itemCount: snapshot
                                                              .data!.length,
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  Divider(
                                                            color: Colors.grey,
                                                            height: 0.5,
                                                          ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final event =
                                                                snapshot.data![
                                                                    index];

                                                            return Container(
                                                              height: 45,
                                                              color:
                                                                  Colors.white,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            12),
                                                                    child: Text(
                                                                        '${event.rankFrom.toString() == event.rankUpto.toString() ? event.rankFrom.toString() : event.rankFrom.toString() + " - ${event.rankUpto.toString()}"}'),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12),
                                                                    child: Text(
                                                                        '${event.prizeAmount}'),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FutureBuilder<
                                          List<LiveMatch_Players_Image_Data>?>(
                                        future: future_data,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: SpinKitFadingCircle(
                                                color: Color(0xff780000),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('No Internet');
                                          } else if (!snapshot.hasData) {
                                            return RefreshIndicator(
                                              color: Colors.red,
                                              backgroundColor: Colors.white,
                                              onRefresh: () async {
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );
                                                setState(() {
                                                  future_data = Players_Data(
                                                      widget.Match_id,
                                                      _token,
                                                      widget.team1_id
                                                          .toString(),
                                                      widget.team2_id
                                                          .toString());
                                                });
                                              },
                                              child: Center(
                                                  child: Text(
                                                      'No events available')),
                                            );
                                          } else {
                                            return RefreshIndicator(
                                              color: Colors.red,
                                              backgroundColor: Colors.white,
                                              onRefresh: () async {
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );

                                                setState(() {
                                                  future_data = Players_Data(
                                                      widget.Match_id,
                                                      _token,
                                                      widget.team1_id
                                                          .toString(),
                                                      widget.team2_id
                                                          .toString());
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 15),
                                                              child: Text(
                                                                "Players",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Selected by",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Points",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_upward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 13,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final event = snapshot
                                                            .data![index];
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 8),
                                                              child: Container(
                                                                height: 60,
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          CircleAvatar(
                                                                            backgroundImage:
                                                                                MemoryImage(base64Decode(event.faceImageId)),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 8),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  event.name.length > 12 ? event.name.substring(0, 10) + '...' : event.name,
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                                Text(
                                                                                  event.teamName,
                                                                                  style: TextStyle(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.w300,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "${event.byUser.toString()} %",
                                                                                style: TextStyle(
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              "${event.points.toString()}",
                                                                              style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: Colors
                                                                  .grey[200],
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      FutureBuilder<List<LiveScoreNewData>?>(
                                        future: ScorecardData,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: SpinKitFadingCircle(
                                                color: Colors.redAccent,
                                                size: 50.0,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('No Scorecard Data');
                                          } else if (!snapshot.hasData) {
                                            return RefreshIndicator(
                                              color: Colors.red,
                                              backgroundColor: Colors.white,
                                              onRefresh: () async {
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );

                                                setState(() {
                                                  ScorecardData =
                                                      FetchScoreCardData(
                                                          widget.Match_id);
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                    'No Players Data available'),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              height: 1000,
                                              child: ListView.separated(
                                                itemCount:
                                                    snapshot.data!.length,
                                                separatorBuilder:
                                                    (context, index) => Divider(
                                                        height: 2,
                                                        color: Colors.grey),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final event =
                                                      snapshot.data![index];
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: double.infinity,
                                                        color:
                                                            Colors.yellow[50],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              event
                                                                  .batTeamDetails!
                                                                  .batTeamShortName
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Run Rate:${event.scoreDetails!.runRate} ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${event.scoreDetails!.runs}/${event.scoreDetails!.wickets}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " (${event.scoreDetails!.overs})",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    isExpanded1
                                                                        ? Icons
                                                                            .arrow_drop_up_sharp
                                                                        : Icons
                                                                            .arrow_drop_down_sharp,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 20,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        width: double.infinity,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Batsman",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "R",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          "B",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "4",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          "6",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            Text(
                                                                          "SR",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        //height: 580,
                                                        child: Column(
                                                          children: event
                                                              .batTeamDetails!
                                                              .batsmenData!
                                                              .map((event2) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .batName!,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          event2.outDesc!.length > 12
                                                                              ? '${event2.outDesc!.substring(0, 12)}\n${event2.outDesc!.substring(12)}'
                                                                              : event2.outDesc!,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            color:
                                                                                Colors.grey[700],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .runs!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          event2
                                                                              .balls!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .fours!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          event2
                                                                              .sixes!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            event2.strikeRate!.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 11,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 2,
                                                        color: Colors.grey,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        width: double.infinity,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Bowler",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "O",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          "M",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "R",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          "W",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            Text(
                                                                          "ECO",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        //height: 250,
                                                        child: Column(
                                                          children: event
                                                              .bowlTeamDetails!
                                                              .bowlersData!
                                                              .map((event2) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .bowlName!,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .overs!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          event2
                                                                              .maidens!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2
                                                                              .runs!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              25,
                                                                        ),
                                                                        Text(
                                                                          event2
                                                                              .wickets!
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            event2.economy!.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 11,
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
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
    DateTime targetTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time));

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
      style: TextStyle(
          color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600),
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
