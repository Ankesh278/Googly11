import 'dart:convert';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/App_Widgets/CustomText.dart';
import 'package:get/get.dart';
import 'package:world11/Model/LiveTeamPreviewModel/LiveTeamPreviewResponse.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import '../../ApiCallProviderClass/API_Call_Class.dart';
import '../Model/GetLeaderBoard/Data.dart';
import '../Model/GetLeaderBoard/GetLeaderBoardResponse.dart';
import '../Model/LiveTeamPreviewModel/Data.dart';
import '../Model/LiveTeamPreviewModel/Players.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
// import '../Model/UserAllTeamContestData/Data.dart';
// import '../Model/UserAllTeamContestData/Players.dart';
//import '../Model/UserAllTeamContestData/UserAllTeamContestDataResponse.dart';
import '../Model/WinningsModel/PrizeDistributions.dart';
import 'package:http/http.dart' as http;

import '../Model/WinningsModel/WinningsResponseModel.dart';
import 'LiveTeamPreview.dart';
//import 'TeamPreviewAfterCompleteMatch.dart';

class AfterJoinContestView extends StatefulWidget {
  var team1_Id, team2_Id, text1, text2, Match_Id,logo1,logo2,time_hours,
      entry_fee,app_charge,user_participant,Number_of_user,Contest_Id,
      first_Prize,winnerCriteria,total_Teams_allow;
  AfterJoinContestView(
      {Key? key,
        this.team1_Id,
        this.team2_Id,
        this.text1,
        this.text2,
        this.Match_Id,
        this.logo1,
        this.logo2,
        this.time_hours,
        this.app_charge,
        this.entry_fee,
        this.Number_of_user,
        this.user_participant,
        this.Contest_Id,
        this.first_Prize,
        this.winnerCriteria,
        this.total_Teams_allow
      }) : super(key: key);

  @override
  State<AfterJoinContestView> createState() => _MakeTeamPayMentState();
}

class _MakeTeamPayMentState extends State<AfterJoinContestView>
    with SingleTickerProviderStateMixin {
  String? _email;
  String? _userName;
  String _token='';
  TabController? _tabController;
  Future<List<LeaderBoardData>?>? contest_Data;
  Future<List<PrizeDistributions>?>? winningsData;
  List<LiveTeamPreviewData>? allTeamUserCreateData;
  String total_Points='';
  int team_Id=0;
  List<Players_>? players_Data=[];
  List<String> player_Id=[];
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];

  List<String> Wk_points_data=[];
  List<String> Bat_points_data=[];
  List<String> AR_points_data=[];
  List<String> Bowl_points_data=[];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getPrefrenceData();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
      fetchUserTeam();
      contest_Data=   fetchData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
      winningsData=  fetchWinnersData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
    });
    print("email"+_email.toString());
    print("user_id"+_userName.toString());
  }
  Future<List<Players_>?> fetchUserTeamDataByTeamPreview(String matchId, String token, String team_id) async {
    print("match_Id::::" + matchId.toString() + "::::::::" + "::::::" + team_id);
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data2?match_id=$matchId&teamID=$team_id';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Error:::::::djgfwiue ${response.statusCode}');
      print('Response::::::::::ewytty ${response.body}');
      if (response.statusCode == 200) {
        final contestDataResponse = LiveTeamPreviewResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1 && contestDataResponse.data != null && contestDataResponse.data!.isNotEmpty) {
          allTeamUserCreateData = contestDataResponse.data;
          total_Points = allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id = allTeamUserCreateData![0].teamID!;
          players_Data = allTeamUserCreateData![0].players ?? [];

          for (var playerData in players_Data!) {
            player_Id.add(playerData.playerDetails!.playerId.toString());

            final roleType = playerData.playerDetails!.roleType;
            final player = PlayersData_(
              playerId: playerData.playerDetails!.playerId!,
              teamId: playerData.teamID,
              imageId: playerData.playerDetails!.imageId!,
              roleType: roleType,
              bat: playerData.playerDetails!.name,
              bowl: playerData.playerDetails!.name,
              name: playerData.playerDetails!.name,
              nickName: playerData.playerDetails!.nickName,
              role: playerData.playerDetails!.role,
              intlTeam: playerData.playerDetails!.intlTeam,
              image: playerData.playerDetails!.image,
              points: playerData.playerDetails!.points!,
              byuser: playerData.playerDetails!.imageId!,
              playingTeamId: playerData.playerDetails!.playingTeamId!,
              captain: playerData.captain,
              viceCaptain: playerData.viceCaptain,
              isPlay: playerData.playerDetails!.isPlay,
              captionByuser: playerData.playerDetails!.isPlay,
              VoiceCaptionByuser: playerData.playerDetails!.isPlay,
            );

            switch (roleType) {
              case "WICKET KEEPER":
                Wk_points_data.add(playerData.totalMatchPoints.toString());
                Wk_PlayersData.add(player);
                break;
              case "BATSMEN":
                Bat_points_data.add(playerData.totalMatchPoints.toString());
                BatData_Player.add(player);
                break;
              case "ALL ROUNDER":
                AR_points_data.add(playerData.totalMatchPoints.toString());
                ARData_Player.add(player);
                break;
              case "BOWLER":
                Bowl_points_data.add(playerData.totalMatchPoints.toString());
                BowlData_Player.add(player);
                break;
            }
          }

          print("Data___::::::::::::" + Wk_PlayersData.length.toString());
          print("Data___::::::::::::" + BatData_Player.length.toString());
          print("Data___::::::::::::" + ARData_Player.length.toString());
          print("Data___::::::::::::" + BowlData_Player.length.toString());

          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              LiveTeamPreview(
                batsmen: BatData_Player,
                bowlers: BowlData_Player,
                allrounders: ARData_Player,
                wicketkeeper: Wk_PlayersData,
                Wk_points_Data: Wk_points_data,
                team2_id: widget.team2_Id,
                team1_id: widget.team1_Id,
                Bat_points_Data: Bat_points_data,
                AR_points_Data: AR_points_data,
                Bowl_points_Data: Bowl_points_data,
                time_hours: "0",
              )));
          return contestDataResponse.data![0].players;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No data available')),
          );
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      } else if (response.statusCode == 404) {
        final contestDataResponse = LiveTeamPreviewResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 0) {
          Fluttertoast.showToast(msg: "No Team Preview Allow Other Players", textColor: Colors.white, backgroundColor: Colors.black);
        }
        // Handle 404 not found
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



  Future<List<LeaderBoardData>> fetchData(int match_Id, int contest_ID) async {
    print("match_id:::::::$match_Id::$contest_ID");
    final String apiUrl = 'https://admin.googly11.in/api/get_leader_board_with_match';

    final Uri uri = Uri.parse('$apiUrl?match_id=$match_Id&contest_id=$contest_ID');

    print("Apiiiiiii>>>>>>>>>>>>"+uri.toString());

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      print('Error::::retrtyr ${response.statusCode}');
      print('Response body:::::::tuytuu ${response.body}');
      if (response.statusCode == 200) {
        GetLeaderBoardResponse boardResponse = GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if (boardResponse.status == 1) {

          return boardResponse.data!;
        } else {
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
          return boardResponse.data!;
        }
      } else if (response.statusCode == 400) {
        GetLeaderBoardResponse boardResponse = GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if (boardResponse.status == 0) {
          return boardResponse.data!;
        }
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return []; // Return an empty list if there's an error or no data
  }

  Future<List<PrizeDistributions>?> fetchWinnersData(int match_Id,int contest_ID) async {
    print("match_id:::::::"+match_Id.toString() +"::"+contest_ID.toString());
    final String apiUrl = 'https://admin.googly11.in/api/get_winnigs_user_contest?match_id=$match_Id&contest_id=$contest_ID';

    final Uri uri = Uri.parse('$apiUrl?match_id=$match_Id&contest_id=$contest_ID');

    try {
      final response = await http.get(uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      print('Error::::::::::346565 ${response.statusCode}');
      print('Response body:::::::::::::347843790 ${response.body}');
      if (response.statusCode == 200) {
        WinningsResponseModel boardResponse = WinningsResponseModel.fromJson(json.decode(response.body));
        if(boardResponse.status == 1){
          print('Error:::: ${response.statusCode}');
          print('Response body::::::: ${response.body}');
          return boardResponse.data!.prizeDistributions;
        }else{
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
          return boardResponse.data!.prizeDistributions;
        }
      } else if(response.statusCode == 400){
        WinningsResponseModel boardResponse = WinningsResponseModel.fromJson(json.decode(response.body));
        if(boardResponse.status==0){
          return boardResponse.data!.prizeDistributions;
        }
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else{
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  Future<void> fetchUserTeam() async {
    // Your existing API call logic here
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.fetchUserTeamDataWithContest_Id(widget.Match_Id, _token,widget.Contest_Id.toString());
    // apiProvider.fetchData(widget.Match_Id, _token);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.text1} VS ${widget.text2}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff780000),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          // Your other widgets...
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.035,
                  color: Colors.white,
                  child: TabBar(
                    labelColor: Colors.white,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF880E4F),
                          Color(0xFF2F33D0)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Tab(text: 'Leaderboards'.tr),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Tab(text: 'Winnings'.tr,),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Leaderboards Tab
                      FutureBuilder<List<LeaderBoardData>?>(
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
                                  contest_Data = fetchData(
                                      int.parse(widget
                                          .Match_Id
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
                            // Your list view widget for leaderboards
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
                                  contest_Data = fetchData(
                                      int.parse(widget
                                          .Match_Id
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
                                        fetchUserTeamDataByTeamPreview(
                                            widget.Match_Id,
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
                                                          "No winnings amounts",
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
                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: event.winningZone==1?Colors.green:Colors.black),
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
                      // Winnings Tab
                      FutureBuilder<List<PrizeDistributions>?>(
                        future: winningsData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No data available. Please try again later.'),
                                ),
                              );
                            });
                            return Container(); // or any other fallback widget
                          } else {
                            // Your list view widget for winnings
                            return  RefreshIndicator(
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
                                          .Match_Id
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
                    ],
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsPopup(BuildContext context,String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Details"),
          content: Text(
            "$text",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13
            ),),
          actions: [
            TextButton(
              onPressed: () {
                // Close the popup when the button is pressed
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

}
