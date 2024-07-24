import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/GetLeaderBoard/GetLeaderBoardResponse.dart';
// import 'package:world11/Model/LiveMatchPlayers_Image_Data/Live_Match_Player_Data.dart';
 import 'package:world11/Model/PlayersTeamCreationResponse/PlayersData.dart';
import 'package:world11/Model/TopWinningContestDetails/TopWinningContestDetails.dart';
import 'package:world11/Model/Upcoming_New_Model/Upcoming_New_Api_Response.dart';
import 'package:world11/Model/UserAllTeamContestData/Data.dart';
import '../../App_Widgets/CustomText.dart';
import '../../Model/Lenback_Data_For_Live/Data.dart';
import '../../Model/Lenback_Data_For_Live/LenBack_Api_Response.dart';
import '../../Model/LiveMatchPlayers_Image_Data/Data.dart';
import '../../Model/LiveMatchScorecardDataPlayers/LiveScorecard.dart';
import '../../Model/Upcoming_New_Model/Data.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Model/GetLeaderBoard/Data.dart';
import '../Model/TopWinningContestDetails/MatchInfo.dart';
import '../Model/UserAllTeamContestData/Players.dart';
import 'Add Cash In Wallet.dart';
import 'MyMatchesDetailsView.dart';


class AfterWinningContestView extends StatefulWidget {
  final  logo1,logo2,text1,text2,stats,Match_id,team1_id,team2_id,Contest_Id,winnings;
  AfterWinningContestView({super.key,
    this.logo1,this.logo2,this.text1,this.text2,this.stats,this.Match_id,this.team1_id,this.team2_id,this.Contest_Id,this.winnings
  });

  @override
  State<AfterWinningContestView> createState() => AfterWinningContestViewState();
}

class AfterWinningContestViewState extends State<AfterWinningContestView> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String? _email;
  String? _userName;
  String _token = '';
  Future<List<UpcomingMatch_Recents_Data>?>? future;
  Future<List<LiveMatch_Players_Image_Data>?>? future_data;
  Future<List<LiveScoreNewData>?>? ScorecardData;
  bool isExpanded1 = true;
  List<Players>? players_Data=[];
  List<String> player_Id=[];
  Map<int, bool> isContainerVisibleMap = {};
  Future<List<LeaderBoardData>?>? contest_Data;
  List<TeamDataAll>? allTeamUserCreateData;
  String total_Points='';
  int team_Id=0;
 // bool _isLoading = false;

  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];
  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };

  Future<List<MatchInfo>?>? WinningContestData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
    ScorecardData=FetchScoreCardData(widget.Match_id);
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<UpcomingMatch_Recents_Data>?> fetchUpcomingMatches(String type) async {
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
      print("PPPPPPPP::::::::" + response.toString());
      print("PPPPPPPP::::::::" + response.body);
      if (response.statusCode == 200) {
        UpcomingNewApiResponse upcomingMatch =
        UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if(upcomingMatch.allData != null && upcomingMatch.allData != ""){
            return upcomingMatch.allData!.data;
          }else{
            print("No Data::::");
          }
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

  Future<List<LeaderBoardData>?> fetchDataMatchLeader(int match_Id,int contest_ID) async {
    print("match_id:::::::"+match_Id.toString() +"::"+contest_ID.toString());
    final String apiUrl = 'https://admin.googly11.in/api/get_leader_board_with_match';

    final Uri uri = Uri.parse('$apiUrl?match_id=$match_Id&contest_id=$contest_ID');

    try {
      final response = await http.get(uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      print('Error::::ewtrresg ${response.statusCode}');
      print('Response body:::::dfgdfg:: ${response.body}');
      if (response.statusCode == 200) {
        GetLeaderBoardResponse boardResponse = GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if(boardResponse.status == 1){
          print('Error:::: ${response.statusCode}');
          print('Response body::::::: ${response.body}');
          return boardResponse.data;
        }else{
          print('Error: ${response.statusCode}');
          print('Response body: ${response.body}');
          return boardResponse.data;
        }
      } else if(response.statusCode == 400){
        GetLeaderBoardResponse boardResponse = GetLeaderBoardResponse.fromJson(json.decode(response.body));
        if(boardResponse.status==0){
          return boardResponse.data;
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
  Future<List<LiveScoreNewData>?> FetchScoreCardData(String match_Id) async {
    final url = Uri.parse('https://admin.googly11.in/api/match_score_card?match_id=$match_Id');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    print('Failed to load data: ${response.body}');
    if (response.statusCode == 200) {
      LiveMatchScoreCardData liveMatchScoreCard=LiveMatchScoreCardData.fromJson(json.decode(response.body));
      if(liveMatchScoreCard.status == 1){
        print('Failed to load data: ${response.body}dfjgjg');
        return liveMatchScoreCard.data;
      }
    } else if(response.statusCode == 401){
      LiveMatchScoreCardData liveMatchScoreCard=LiveMatchScoreCardData.fromJson(json.decode(response.body));
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
    });
    WinningContestData=getWinningContestData(widget.Match_id,_token);
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
  }

  Future<LenBack_Data_For_Live?> fetchData(String match_id, String bearerToken) async {
    final String apiUrl = "https://admin.googly11.in/api/get_leanback?match_id=$match_id";
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      });
      print("Error: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        print("response: ${response.statusCode}");
        LenBackApiResponse leanBackData = LenBackApiResponse.fromJson(
            json.decode(response.body));
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
  Future<List<MatchInfo>?>  getWinningContestData(String match_id, String bearerToken) async {
    final String apiUrl = "https://admin.googly11.in/api/get_list_top_winning_contest_details/$match_id";
    try {
      final response = await http.get(Uri.parse(apiUrl),
          headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken'});
      print("Error: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        print("response: ${response.statusCode}");
        TopWinningContestDetails leanBackData = TopWinningContestDetails.fromJson(
            json.decode(response.body));
        print("Body:::: ${leanBackData.status}");
        if (leanBackData.status == 1) {
          return leanBackData.matchInfo;
        } else {
          leanBackData.matchInfo;
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

  Stream<LenBack_Data_For_Live?> fetchDataPeriodically(String match_id, String bearerToken) async* {
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
      appBar:AppBar(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCashInWallet()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Set the border color
                      width: 1.5, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Set the border radius if you want rounded corners
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
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<LenBack_Data_For_Live?>(
        stream: fetchDataPeriodically(widget.Match_id, _token),
        builder: (BuildContext context, AsyncSnapshot<LenBack_Data_For_Live?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:  SpinKitFadingCircle(
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
                  height: size.height * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: snapshot.data != null &&
                                  snapshot.data!.matchScoreDetails != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList!.length > 1 &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList![1].batTeamName != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList![1].batTeamName.toString() ==
                                      widget.text2.toString()
                                  ? MemoryImage(base64Decode(widget.logo2))
                                  : MemoryImage(base64Decode(widget.logo1)),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomPaddedText(
                                  text: snapshot.data != null &&
                                      snapshot.data!.matchScoreDetails != null &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList != null &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList!.length > 1
                                      ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].batTeamName}"
                                      : "----",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  snapshot.data?.matchScoreDetails?.inningsScoreList != null &&
                                      snapshot.data?.matchScoreDetails != null &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList!.length > 1
                                      ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![1].wickets}"
                                      : "----",
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
                                    fontSize: 12
                                )
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("${snapshot.data != null &&
                                    snapshot.data!.matchScoreDetails != null &&
                                    snapshot.data!.matchScoreDetails!.inningsScoreList != null &&
                                    snapshot.data!.matchScoreDetails!.inningsScoreList!.isNotEmpty
                                    ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName}"
                                    : "----"}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${snapshot.data?.matchScoreDetails?.inningsScoreList != null &&
                                      snapshot.data?.matchScoreDetails != null &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList!.isNotEmpty
                                      ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![0].wickets}"
                                      : "----"}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            CircleAvatar(
                              backgroundImage: snapshot.data != null &&
                                  snapshot.data!.matchScoreDetails != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList!.isNotEmpty &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName != null &&
                                  snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName.toString() ==
                                      widget.text1.toString()
                                  ? MemoryImage(base64Decode(widget.logo1))
                                  : MemoryImage(base64Decode(widget.logo2)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40,right: 40,top: 10),
                        child: Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            maxLines: 2,
                            snapshot.data != null ? snapshot.data!.matchScoreDetails!.customStatus : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if(widget.winnings.toString() != "0")
                Container(
                  height: size.height * 0.08,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(widget.winnings.toString() != "0")
                      Text(
                        "Congratulations! You've won in 1 contest ",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                        ),
                      ),
                      if(widget.winnings.toString() != "0")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Image.asset(
                              ImageAssets.win, // Replace with the path to your winners logo
                              height: 30, // Adjust the height as needed
                              width: 30, // Adjust the width as needed
                            ),
                          ),
                          Text(
                            "Rs"+ widget.winnings.toString() != "" ? widget.winnings.toString() : '',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],),

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
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelColor: Colors.red,
                                indicatorColor: Colors.transparent,
                                controller: _tabController,
                                unselectedLabelColor: Colors.black,
                                indicator: UnderlineTabIndicator(
                                  borderSide: BorderSide(width: 2.0, color: Colors.red), // Set the thickness and color of the underline
                                  insets: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding of the underline
                                ),
                                tabs:  [
                                  Tab(text: 'All Join Contest'),
                                  Tab(text: 'Scoreboard'),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.grey[300],
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      FutureBuilder<List<MatchInfo>?>(
                                        future: WinningContestData,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child:  SpinKitFadingCircle(
                                                color: Color(0xff780000),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text('No Internet' + snapshot.error.toString());
                                          } else if (!snapshot.hasData) {
                                            return RefreshIndicator(
                                              color: Colors.red,
                                              backgroundColor: Colors.white,
                                              onRefresh: () async {
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                );
                                                setState(() {
                                                  WinningContestData = getWinningContestData(widget.Match_id, _token);
                                                });
                                              },
                                              child: Center(child: Text('No Details available')),
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
                                                  WinningContestData = getWinningContestData(widget.Match_id, _token);
                                                });
                                              },
                                              child:   ListView.builder(
                                                itemCount: snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  final event = snapshot.data![index];
                                                  return InkWell(
                                                    onTap : (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyMatchesDetailsView(
                                                                logo1: widget.logo1 != null ? widget.logo1 : '',
                                                                logo2: widget.logo2 != null ?  widget.logo2 : '',
                                                                text1:  widget.text1 != null ?  widget.text1.toString() : '',
                                                                text2:  widget.text2 != null ? widget.text2.toString() : '',
                                                                Match_id: event.matchId.toString(),
                                                                Contest_Id: event.contestId,
                                                                team1_id: widget.team1_id.toString(),
                                                                team2_id: widget.team2_id.toString(),
                                                                stats: widget.stats,
                                                                winnings: event.winnings,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(6),
                                                      child: Card(
                                                        elevation: 20,
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          height: size.height *0.15 ,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            color: Colors.white.withOpacity(0.6),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: size.height *0.01),
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    CustomPaddedText(
                                                                      text: event.contestName.toString(),
                                                                      style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w300,
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 8),
                                                                      child: CustomPaddedText(
                                                                        text: event.rank != null ?"Rank"+ event.rank.toString() : "0",
                                                                        style: TextStyle(
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    CustomPaddedText(
                                                                      text: event.contestEntryFee != null ? event.contestEntryFee.toString() : "0",
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              SizedBox(height: 5,),
                                                              Row(

                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          10),
                                                                      child: Row(

                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                            CircleAvatar(
                                                                              backgroundImage: MemoryImage(
                                                                                  base64Decode(
                                                                                    widget.logo1 != null ? widget.logo1 : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z'
                                                                                  )
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .only(
                                                                                left: 2),
                                                                            child:
                                                                            Center(
                                                                              child: Text(
                                                                                  widget.text1 != null ? widget.text1 : '',
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontWeight: FontWeight
                                                                                          .w800,
                                                                                      fontSize: 12)),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 125,
                                                                    child: Padding(

                                                                      padding: const EdgeInsets.only(top: 8,left: 5),
                                                                      child: event.winnings != null && event.winnings.toString() != "0.00" ? Text(maxLines: 1,overflow: TextOverflow.ellipsis,
                                                                        " You won Rs  ${event.winnings},",
                                                                        style: TextStyle(
                                                                            fontSize: 11,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: event.winnings != null && event.winnings.toString() == "0.00" ?Colors.black : Colors.green
                                                                        ),
                                                                      ) : Text(
                                                                        "No winnings in this contest",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                            fontSize: 11,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: event.winnings != null && event.winnings.toString() == "0.00" ?Colors.black : Colors.green
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  Expanded(
                                                                    child:
                                                                    FractionallySizedBox(
                                                                      widthFactor:
                                                                      1.0,
                                                                      // Adjust the width factor as needed
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                            10),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  right:
                                                                                  0),
                                                                              child:
                                                                              Center(
                                                                                child:
                                                                                Text(
                                                                                  widget.text2 != null ? widget.text2 : '',
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      fontWeight: FontWeight
                                                                                          .bold,
                                                                                      fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Center(
                                                                              child:
                                                                              CircleAvatar(
                                                                                backgroundImage: MemoryImage(
                                                                                    base64Decode(
                                                                                        widget.logo2 != null ? widget.logo2 : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z'
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              SizedBox(height: 10,),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(right: 10),
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: CustomPaddedText(
                                                                      text: "View Leaderboard",
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            );
                                          }
                                        },
                                      ),
                                      FutureBuilder<List<LiveScoreNewData>?>(
                                        future: ScorecardData,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(
                                              child:  SpinKitFadingCircle(
                                                color: Color(0xff780000),
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
                                                  ScorecardData = FetchScoreCardData(widget.Match_id);
                                                });
                                              },
                                              child: Center(
                                                child: Text('No Players Data available'),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              height: 1000,
                                              child: ListView.separated(
                                                itemCount: snapshot.data!.length,
                                                separatorBuilder: (context, index) => Divider(height: 2, color: Colors.grey),
                                                itemBuilder: (BuildContext context, int index) {
                                                  final event = snapshot.data![index];
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: double.infinity,
                                                        color: Colors.yellow[50],
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              event.batTeamDetails!.batTeamShortName.toString(),
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 15,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Run Rate:${event.scoreDetails!.runRate} ",
                                                                    style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${event.scoreDetails!.runs}/${event.scoreDetails!.wickets}",
                                                                    style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " (${event.scoreDetails!.overs})",
                                                                    style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    isExpanded1
                                                                        ? Icons.arrow_drop_up_sharp
                                                                        : Icons.arrow_drop_down_sharp,
                                                                    color: Colors.black,
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
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Batsman",
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "R",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          "B",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "4",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          "6",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(right: 15),
                                                                      child: Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: Text(
                                                                          "SR",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
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
                                                        //height: 582,
                                                        child: Column(
                                                          children: event.batTeamDetails!.batsmenData!.map((event2) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          event2.batName!,
                                                                          style: TextStyle(
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          event2.outDesc!.length > 12
                                                                              ? '${event2.outDesc!.substring(0, 12)}\n${event2.outDesc!.substring(12)}'
                                                                              : event2.outDesc!,
                                                                          style: TextStyle(
                                                                            fontSize: 8,
                                                                            color: Colors.grey[700],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2.runs!.toString() ,
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          event2.balls!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2.fours!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          event2.sixes!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(right: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            event2.strikeRate!.toString(),
                                                                            style: TextStyle(
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
                                                        //height: 50,
                                                        width: double.infinity,
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "Bowler",
                                                                      style: TextStyle(
                                                                        fontSize: 11,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "O",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          "M",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          "R",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          "W",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(right: 15),
                                                                      child: Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: Text(
                                                                          "ECO",
                                                                          style: TextStyle(
                                                                            fontSize: 11,
                                                                            color: Colors.black,
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
                                                          children: event.bowlTeamDetails!.bowlersData!.map((event2) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          event2.bowlName!,
                                                                          style: TextStyle(
                                                                            fontSize: 10,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2.overs!.toString() ,
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          event2.maidens!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          event2.runs!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: 25,),
                                                                        Text(
                                                                          event2.wickets!.toString(),
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(right: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            event2.economy!.toString(),
                                                                            style: TextStyle(
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

