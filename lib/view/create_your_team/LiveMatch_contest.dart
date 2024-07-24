import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ApiCallProviderClass/API_Call_Class.dart';
import '../../App_Widgets/CustomText.dart';
import '../../Model/Lenback_Data_For_Live/Data.dart';
import '../../Model/Lenback_Data_For_Live/LenBack_Api_Response.dart';
import '../../Model/LiveMatchPlayers_Image_Data/Data.dart';
import '../../Model/LiveMatchPlayers_Image_Data/Live_Match_Player_Data.dart';
import '../../Model/LiveMatchScorecardDataPlayers/LiveScorecard.dart';
import '../../Model/LiveTeamPreviewModel/Data.dart';
import '../../Model/LiveTeamPreviewModel/LiveTeamPreviewResponse.dart';
import '../../Model/LiveTeamPreviewModel/Players.dart';
import '../../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../../Model/Upcoming_New_Model/Data.dart';
import '../../Model/Upcoming_New_Model/Upcoming_New_Api_Response.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Add Cash In Wallet.dart';
import '../AfterjoinContestView.dart';
import '../LiveTeamPreview.dart';
import 'create_contest.dart';
import 'package:http/http.dart' as http;

class LiveMatch_contests extends StatefulWidget {
  dynamic logo1, logo2, text1, text2, status, Match_id, team1_id, team2_id;
  LiveMatch_contests(
      {super.key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.status,
      this.Match_id,
      this.team1_id,
      this.team2_id});
  @override
  State<LiveMatch_contests> createState() => _LiveMatch_contestsState();
}

class _LiveMatch_contestsState extends State<LiveMatch_contests>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isBenCcExpanded = false;
  bool isBadExpanded = true;
  bool isExpanded1 = true;
  bool isExpanded2 = false;
  bool isContainerVisible = false;
  String? _email;
  String? _userName;
  String _token = '';
  List<LiveMatch_Players_Image_Data> liveMatch_Players_Image_Data = [];
  Future<List<LiveMatch_Players_Image_Data>?>? future_data;
  Future<List<UpcomingMatch_Recents_Data>?>? future;
  Future<List<LiveScoreNewData>?>? ScorecardData;
  Map<int, bool> isContainerVisibleMap = {};
  List<LiveTeamPreviewData>? allTeamUserCreateData;
  List<Players_>? players_Data = [];
  List<String> player_Id = [];
  String total_Points = '';
  List<PlayersData_> Wk_PlayersData = [];
  List<PlayersData_> BatData_Player = [];
  List<PlayersData_> ARData_Player = [];
  List<PlayersData_> BowlData_Player = [];
  int team_Id = 0;
  bool _isLoading = false;

  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };
  List<String> Wk_points_data = [];
  List<String> Bat_points_data = [];
  List<String> AR_points_data = [];
  List<String> Bowl_points_data = [];
  @override
  void initState() {
    getPrefrenceData();
    super.initState();
    future = fetchUpcomingMatches("upcoming");
    ScorecardData = FetchScoreCardData(widget.Match_id);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        },
      );
      print("PPPPPPPP::::::::" + response.toString());
      print("PPPPPPPP::::::::" + response.body);
      if (response.statusCode == 200) {
        UpcomingNewApiResponse upcomingMatch =
            UpcomingNewApiResponse.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if (upcomingMatch.allData != null && upcomingMatch.allData != "") {
            return upcomingMatch.allData!.data;
          } else {
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
      await Future.delayed(Duration(seconds: 20));
    }
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
      fetchUserTeam();
    });
    future_data = Players_Data(widget.Match_id, _token,
        widget.team1_id.toString(), widget.team2_id.toString());
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
    print("Match_Id:::" + widget.Match_id);
  }

  @override
  Widget build(BuildContext context) {
    print("Match_Id" + widget.Match_id);
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
                  '${widget.text1 != null ? widget.text1 : 'No Data'} vs ${widget.text2 != null ? widget.text2 : 'No Data'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${widget.status != null ? widget.status : 'No Data'}',
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
                          "Add Cash",
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
            // Use snapshot.data to access the latest data
            LenBack_Data_For_Live? data = snapshot.data;
            String recentOvsStats = snapshot.data?.recentOvsStats ??
                ""; // Provide a default value if nul
            // print("object::::::${data!.recentOvsStats}");
            if (snapshot.data != null) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.21,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                            child: Image.asset(
                              ImageAssets.bagroundImage,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(base64Decode(widget.logo1)),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data != null ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName}" : "----"}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.matchScoreDetails!
                                                      .inningsScoreList !=
                                                  null &&
                                              snapshot
                                                      .data!
                                                      .matchScoreDetails!
                                                      .inningsScoreList!
                                                      .length >
                                                  0
                                          ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![0].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![0].wickets}"
                                          : "Yet to Bat",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                CustomPaddedText(
                                    text: widget.status,
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
                                          "${snapshot.data != null && snapshot.data!.matchScoreDetails != null && snapshot.data!.matchScoreDetails!.inningsScoreList != null && snapshot.data!.matchScoreDetails!.inningsScoreList!.length > 1 ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].batTeamName}" : "----"}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        snapshot.data!.matchScoreDetails!
                                                        .inningsScoreList !=
                                                    null &&
                                                snapshot
                                                        .data!
                                                        .matchScoreDetails!
                                                        .inningsScoreList!
                                                        .length >
                                                    1
                                            ? "${snapshot.data!.matchScoreDetails!.inningsScoreList![1].score}/${snapshot.data!.matchScoreDetails!.inningsScoreList![1].wickets}"
                                            : "Yet to Bat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(base64Decode(widget.logo2)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 10),
                            child: Divider(
                              color: Colors.white,
                              height: 2,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        snapshot.data?.batsmanStriker?.batName
                                                    .length >
                                                15
                                            ? snapshot.data?.batsmanStriker
                                                    ?.batName
                                                    .substring(0, 15) +
                                                "..." // Truncate if more than 15 characters
                                            : snapshot
                                                .data?.batsmanStriker?.batName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data?.batsmanStriker?.batRuns !=
                                              null
                                          ? "${snapshot.data?.batsmanStriker?.batRuns}/(${snapshot.data?.batsmanStriker?.batBalls})"
                                          : "----",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                " | ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data?.batsmanNonStriker?.batName
                                                  .length >
                                              15
                                          ? snapshot.data?.batsmanNonStriker
                                                  ?.batName
                                                  .substring(0, 15) +
                                              "..." // Truncate if more than 15 characters
                                          : snapshot
                                              .data?.batsmanNonStriker?.batName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data?.batsmanNonStriker
                                                    ?.batRuns !=
                                                null
                                            ? "${snapshot.data?.batsmanNonStriker?.batRuns}/(${snapshot.data?.batsmanNonStriker?.batBalls})"
                                            : "----",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, top: 5),
                            child: Divider(
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    // _buildCircularBox("1"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "${(snapshot.data?.bowlerStriker?.bowlName ?? '----').length > 15 ? snapshot.data?.bowlerStriker?.bowlName?.substring(0, 15) + '...' : snapshot.data?.bowlerStriker?.bowlName}  ${snapshot.data?.bowlerStriker?.bowlRuns != null ? snapshot.data?.bowlerStriker?.bowlRuns : '----'} (${snapshot.data?.bowlerStriker?.bowlWkts != null ? snapshot.data?.bowlerStriker?.bowlWkts : '----'})",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: _buildCircularBoxes(
                                            recentOvsStats)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
                                  labelStyle: TextStyle(fontSize: 11),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  labelColor: Colors.red,
                                  indicatorColor: Colors.transparent,
                                  controller: _tabController,
                                  unselectedLabelColor: Colors.black,
                                  indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        width: 2.0, color: Colors.red),
                                    // Set the thickness and color of the underline
                                    insets: EdgeInsets.symmetric(
                                        horizontal:
                                            16.0), // Adjust the horizontal padding of the underline
                                  ),
                                  tabs: [
                                    Tab(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'My contest',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                          Expanded(
                                            child: Consumer<ApiProvider>(
                                              builder: (context, apiProvider,
                                                  child) {
                                                return Text(
                                                  ' (${apiProvider.allContestCreateData != null ? apiProvider.allContestCreateData!.length : '0'})',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(text: 'Player Stats'),
                                    Tab(text: 'Scoreboard'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      Consumer<ApiProvider>(
                                        builder: (context, apiProvider, child) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10, top: 10),
                                            child: apiProvider
                                                            .allContestCreateData !=
                                                        null &&
                                                    apiProvider
                                                        .allContestCreateData!
                                                        .isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: apiProvider
                                                        .allContestCreateData!
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final event = apiProvider
                                                              .allContestCreateData![
                                                          index];
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          AfterJoinContestView(
                                                                            team1_Id:
                                                                                widget.team1_id,
                                                                            team2_Id:
                                                                                widget.team2_id,
                                                                            text1:
                                                                                widget.text1,
                                                                            text2:
                                                                                widget.text2,
                                                                            Match_Id:
                                                                                widget.Match_id,
                                                                            logo1:
                                                                                widget.logo1,
                                                                            logo2:
                                                                                widget.logo2,
                                                                            app_charge:
                                                                                event.appCharge,
                                                                            entry_fee:
                                                                                event.entryFee,
                                                                            Number_of_user:
                                                                                event.numberOfUser,
                                                                            user_participant:
                                                                                event.userParticipant,
                                                                            Contest_Id:
                                                                                event.id,
                                                                            first_Prize:
                                                                                event.firstPrize,
                                                                            winnerCriteria:
                                                                                event.winnerCriteria,
                                                                            total_Teams_allow:
                                                                                event.totalTeamsAllowed,
                                                                          )));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.5),
                                                          child: Card(
                                                            elevation: 20,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  size.height *
                                                                      0.45,
                                                              width:
                                                                  size.width *
                                                                      0.95,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                      height: size
                                                                              .height *
                                                                          0.01),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomPaddedText(
                                                                        text: event
                                                                            .contestName,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 8),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomPaddedText(
                                                                          text:
                                                                              () {
                                                                            try {
                                                                              if (event.entryFee != null) {
                                                                                double result = double.parse(event.entryFee.toString()) * double.parse(event.userParticipant.toString()) * double.parse(event.appCharge.toString()) / 100;
                                                                                double newData = double.parse(event.entryFee.toString()) * double.parse(event.userParticipant.toString()) - result;
                                                                                return newData.toStringAsFixed(2);
                                                                              } else {
                                                                                return '';
                                                                              }
                                                                            } catch (e) {
                                                                              // Handle the parsing error
                                                                              print("Error parsing entryFee: $e");
                                                                              return '';
                                                                            }
                                                                          }(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  LinearProgressBar(
                                                                    maxSteps: event
                                                                        .userParticipant,
                                                                    progressType:
                                                                        LinearProgressBar
                                                                            .progressTypeLinear, // Use Linear progress
                                                                    currentStep:
                                                                        event
                                                                            .numberOfUser,
                                                                    progressColor:
                                                                        Colors
                                                                            .red,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                                  SizedBox(
                                                                    height: size
                                                                            .height *
                                                                        0.01,
                                                                  ),
                                                                  CustomPaddedText(
                                                                    text:
                                                                        '${int.parse(event.userParticipant.toString()) - int.parse(event.numberOfUser.toString())} spots left',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      height: size
                                                                              .height *
                                                                          0.05,
                                                                      width: size
                                                                              .width *
                                                                          0.95,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(12),
                                                                          bottomLeft:
                                                                              Radius.circular(12),
                                                                        ),
                                                                        color: Color(
                                                                            0xFFF0F0F0),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _showDetailsPopup(context, "First Prize = ${event.firstPrize != null ? event.firstPrize : "1000 Rs"}");
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(left: 5),
                                                                              child: Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.looks_one_sharp,
                                                                                    color: Colors.black54,
                                                                                    size: 13,
                                                                                  ),
                                                                                  Text(
                                                                                    event.firstPrize != null ? event.firstPrize : "1000 Rs",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black54,
                                                                                      fontSize: 13,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              double result = double.parse(event.userParticipant.toString()) * double.parse(event.winnerCriteria.toString()) / 100;
                                                                              print("result" + result.toString());
                                                                              double newData = double.parse(event.userParticipant.toString()) - result;
                                                                              _showDetailsPopup(context, "$newData teams win the contest");
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Image(
                                                                                  image: AssetImage(ImageAssets.trophyy),
                                                                                  height: 15,
                                                                                ),
                                                                                CustomPaddedText(
                                                                                  text: '${event.winnerCriteria}%',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black54,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _showDetailsPopup(context, "Max ${event.totalTeamsAllowed} entries per user in this contest");
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.bookmark_sharp,
                                                                                  color: Colors.black54,
                                                                                  size: 13,
                                                                                ),
                                                                                Text(
                                                                                  "${event.totalTeamsAllowed.toString()}",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black54,
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          if (event.guaranteed ==
                                                                              1)
                                                                            InkWell(
                                                                              onTap: () {
                                                                                _showDetailsPopup(context, "Guaranteed to take place regardless of spots filled");
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(right: 5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.check_circle,
                                                                                      color: Colors.black54,
                                                                                      size: 13,
                                                                                    ),
                                                                                    Text(
                                                                                      " Guaranteed",
                                                                                      style: TextStyle(
                                                                                        color: Colors.black54,
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (event.guaranteed ==
                                                                              0)
                                                                            InkWell(
                                                                              onTap: () {
                                                                                // _showDetailsPopup(context,"Guaranteed to take place regardless of spots filled");
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(right: 5),
                                                                                child: Row(
                                                                                  children: [
                                                                                    // Icon(
                                                                                    //   Icons.check_circle,
                                                                                    //   color: Colors.black54,
                                                                                    //   size: 13,
                                                                                    // ),
                                                                                    Text(
                                                                                      "Play and win",
                                                                                      style: TextStyle(
                                                                                        color: Colors.black54,
                                                                                        fontSize: 13,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        CustomPaddedText(
                                                                          text:
                                                                              'Joined with ${event.joinContestUser!.length} team',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 130,
                                                                    margin: EdgeInsets
                                                                        .all(8),
                                                                    child: _isLoading
                                                                        ? Center(
                                                                            child: SpinKitFadingCircle(
                                                                            color:
                                                                                Colors.redAccent,
                                                                            size:
                                                                                50.0,
                                                                          ))
                                                                        : Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                ListView.separated(
                                                                              itemCount: event.leaderBoard_Entry!.length,
                                                                              separatorBuilder: (context, index) => Divider(
                                                                                color: Colors.grey,
                                                                                height: 0.5,
                                                                              ),
                                                                              itemBuilder: (context, index) {
                                                                                final event_Data = event.leaderBoard_Entry![index];
                                                                                return InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      _isLoading = true;
                                                                                      allTeamUserCreateData = null;
                                                                                      players_Data = [];
                                                                                      Wk_PlayersData = [];
                                                                                      BatData_Player = [];
                                                                                      ARData_Player = [];
                                                                                      BowlData_Player = [];
                                                                                      player_Id = [];
                                                                                      Wk_points_data = [];
                                                                                      AR_points_data = [];
                                                                                      Bat_points_data = [];
                                                                                      Bowl_points_data = [];
                                                                                    });

                                                                                    fetchUserTeamDataByTeamPreview(widget.Match_id, _token, event_Data.teamId.toString()).then((value) {
                                                                                      setState(() {
                                                                                        _isLoading = false;
                                                                                      });
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    color: Colors.yellow[50],
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  event_Data.userName.toString(),
                                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                if (event_Data.winningZone == 1)
                                                                                                  Text(
                                                                                                    "In winning zone",
                                                                                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                                                                                                  ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  event_Data.teamName.toString(),
                                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 15,
                                                                                                ),
                                                                                                Text(
                                                                                                  event_Data.totalPlayerPoints.toString() + " pts",
                                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  event_Data.isCurrentUser == true ? "# " + event_Data.rank.toString() : event_Data.rank.toString(),
                                                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                event_Data.winningZone == 1
                                                                                                    ? Icon(
                                                                                                        Icons.arrow_upward_sharp,
                                                                                                        color: Colors.green,
                                                                                                        size: 12,
                                                                                                      )
                                                                                                    : Icon(
                                                                                                        Icons.arrow_downward_sharp,
                                                                                                        color: Colors.red,
                                                                                                        size: 12,
                                                                                                      )
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
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
                                                : Container(
                                                    color: Colors.grey[300],
                                                    height:
                                                        400.0, // Set the height to an appropriate value
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                          child: Text(
                                                            "Join Upcoming Match",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: FutureBuilder<
                                                              List<
                                                                  UpcomingMatch_Recents_Data>?>(
                                                            future: future,
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return Center(
                                                                  child:
                                                                      SpinKitFadingCircle(
                                                                    color: Color(
                                                                        0xff780000),
                                                                  ),
                                                                );
                                                              } else if (snapshot
                                                                  .hasError) {
                                                                return Text(
                                                                    'No Internet');
                                                              } else if (!snapshot
                                                                  .hasData) {
                                                                return RefreshIndicator(
                                                                    color: Colors
                                                                        .red,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    onRefresh:
                                                                        () async {
                                                                      await Future
                                                                          .delayed(
                                                                        const Duration(
                                                                            seconds:
                                                                                2),
                                                                      );

                                                                      setState(
                                                                          () {
                                                                        future =
                                                                            fetchUpcomingMatches("upcoming");
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                        'No events available'));
                                                              } else {
                                                                return RefreshIndicator(
                                                                  color: Colors
                                                                      .red,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  onRefresh:
                                                                      () async {
                                                                    await Future
                                                                        .delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              2),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      future =
                                                                          fetchUpcomingMatches(
                                                                              "upcoming");
                                                                    });
                                                                  },
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount:
                                                                        snapshot
                                                                            .data!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      final event =
                                                                          snapshot
                                                                              .data![index];

                                                                      // print("DataMatch_id::::"+event.matchId.toString());
                                                                      DateTime
                                                                          currentTime =
                                                                          DateTime
                                                                              .now();
                                                                      DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(int.parse(event.startDate !=
                                                                              null
                                                                          ? event
                                                                              .startDate
                                                                          : '445754'));
                                                                      Duration
                                                                          timeDifference =
                                                                          eventTime
                                                                              .difference(currentTime);
                                                                      // print("Start_date::::"+event.startDate.toString());
                                                                      // print("End_date::::"+event.endDate.toString());
                                                                      if (timeDifference
                                                                              .inSeconds >
                                                                          0) {
                                                                        return InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (timeDifference.inHours <=
                                                                                24) {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => CreateContest(
                                                                                    logo1: event.firstTeam != null ? event.firstTeam!.imageData : '',
                                                                                    logo2: event.secondTeam != null ? event.secondTeam!.imageData : '',
                                                                                    text1: event.firstTeam != null ? event.firstTeam!.teamSName : '',
                                                                                    text2: event.secondTeam != null ? event.secondTeam!.teamSName : '',
                                                                                    time_hours: event.startDate,
                                                                                    match_id: event.matchId.toString(),
                                                                                    team1_Id: event.team1Id.toString(),
                                                                                    team2_Id: event.team2Id.toString(),
                                                                                    Average_Score: '',
                                                                                    HighestScore: '',
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            } else {
                                                                              print("fhsjdjfk");
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child: Container(
                                                                                height: size.height * 0.12,
                                                                                width: size.width * 0.8,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(15),
                                                                                  color: timeDifference.inHours <= 24
                                                                                      ? Colors.white // Event is clickable, use white background
                                                                                      : Colors.grey.withOpacity(0.15), // Event is not clickable, use transparent gray background
                                                                                ),
                                                                                // Center the contents of the container
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      event.seriesName != null
                                                                                          ? event.seriesName
                                                                                          : '' + "," + event.matchFormat != null
                                                                                              ? event.matchFormat
                                                                                              : '',
                                                                                      style: TextStyle(fontSize: 10),
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 10),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                Center(
                                                                                                  child: CircleAvatar(
                                                                                                    backgroundImage: MemoryImage(base64Decode(event.firstTeam != null ? event.firstTeam!.imageData : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(left: 5),
                                                                                                  child: Center(
                                                                                                    child: Text(event.firstTeam != null ? event.firstTeam!.teamSName : '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14)),
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Text(event.state != null ? event.state : '?', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800, fontSize: 12)),
                                                                                        Expanded(
                                                                                          child: FractionallySizedBox(
                                                                                            widthFactor: 1.0,
                                                                                            // Adjust the width factor as needed
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.only(right: 10),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(right: 5),
                                                                                                    child: Center(
                                                                                                      child: Text(
                                                                                                        event.secondTeam != null ? event.secondTeam!.teamSName : '',
                                                                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Center(
                                                                                                    child: CircleAvatar(
                                                                                                      backgroundImage: MemoryImage(base64Decode(event.secondTeam != null ? event.secondTeam!.imageData : '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAAkADADASIAAhEBAxEB/8QAGQAAAgMBAAAAAAAAAAAAAAAAAAMBAgQF/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/2gAMAwEAAhADEAAAAe9JIrPMefbm1v3wKbzTVXIyNOjk9alyFLsBIB//xAAfEAACAgIBBQAAAAAAAAAAAAABAgARAxASEyEiI0P/2gAIAQEAAQUC0x4g5CDjJYbyNcU1E7jTETxrkkRk3nvr5XDT6KfZLlwABpcuf//EABcRAAMBAAAAAAAAAAAAAAAAAAASITD/2gAIAQMBAT8BFmH/xAAaEQADAAMBAAAAAAAAAAAAAAAAARECAxAg/9oACAECAQE/AR7LlELkRJ4//8QAIRAAAQMEAQUAAAAAAAAAAAAAAQARIQIQEiAiMUFRobH/2gAIAQEABj8Cs6HdORo2rZMoIUn0mpNwwfhI8hcTGI+rGonGeqogtEPI0NQElGL/AP/EAB0QAQADAQADAQEAAAAAAAAAAAEAETEhQVFhkRD/2gAIAQEAAT8hAo5KPUyQ1KhAeQlCAZEKeQw/lqmEoPtyLrHGGEuXHFpfiUAovKLlhRIeov2G/kcYYSzzR7bDksduHE4hwLFFrzyhf2Leiiv0P09xxl6l4AA0rzCjgd6zWEvU/9oADAMBAAIAAwAAABCCtFZOqCDz/8QAGREAAwEBAQAAAAAAAAAAAAAAAAERMRAg/9oACAEDAQE/EBRTQ95WN3fH/8QAGREAAwADAAAAAAAAAAAAAAAAAAERICEx/9oACAECAQE/EBFKHI1TVIJEiw//xAAhEAEAAgICAwADAQAAAAAAAAABABEhMVGhQWFxEIGR0f/aAAgBAQABPxBmJriep/ISEmxUUVBRdPMUDWBWXlhMTXE634AVvYnlhoSywcX+5tA5dNzrTrRNnWYB9vkABwNCw6T/AGOpJFhVe4C1HZa+cTrTrQFhVCxlQefXmqgWNWbipLMiDSeIkHbYSR/AUR1wKFYmRjIR1oACjUzaIuVqdj6Ty+4qQR6tvPUuhyHmoosGp//Z')),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Center(
                                                                                      child: CountdownTimerWidget(
                                                                                        time: event.startDate != null ? event.startDate : '454875',
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Center(
                                                                          child:
                                                                              SpinKitFadingCircle(),
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        },
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
                                                                                  event.name.length > 10 ? event.name.substring(0, 10) + '...' : event.name,
                                                                                  style: TextStyle(
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
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
                                                        height: 280,
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
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  'No Match Record found',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Players_>?> fetchUserTeamDataByTeamPreview(
      String matchId, String token, String team_id) async {
    print(
        "match_Id::::" + matchId.toString() + "::::::::" + "::::::" + team_id);
    final url =
        'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId&teamID=$team_id';
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
        final contestDataResponse =
            LiveTeamPreviewResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData = contestDataResponse.data;
          total_Points =
              allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id = allTeamUserCreateData![0].teamID!;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);
          for (int i = 0; i < players_Data!.length; i++) {
            player_Id.add(players_Data![i].playerDetails!.playerId.toString());

            if (players_Data![i].playerDetails!.roleType == "WICKET KEEPER") {
              Wk_points_data.add(players_Data![i].totalMatchPoints.toString());
              Wk_PlayersData.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId!,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,
                playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,
                viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "BATSMEN") {
              Bat_points_data.add(players_Data![i].totalMatchPoints.toString());
              BatData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId!,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,
                playingTeamId: players_Data![i].playerDetails!.playerId!,
                captain: players_Data![i].captain,
                viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "ALL ROUNDER") {
              AR_points_data.add(players_Data![i].totalMatchPoints.toString());
              ARData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId!,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,
                playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,
                viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "BOWLER") {
              Bowl_points_data.add(
                  players_Data![i].totalMatchPoints.toString());
              BowlData_Player.add(PlayersData_(
                playerId: players_Data![i].playerDetails!.playerId!,
                teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!,
                roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name,
                bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name,
                nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role,
                intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image,
                points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,
                playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,
                viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          print("Data___::::::::::::" + Wk_PlayersData.length.toString());
          print("Data___::::::::::::" + BatData_Player.length.toString());
          print("Data___::::::::::::" + ARData_Player.length.toString());
          print("Data___::::::::::::" + BowlData_Player.length.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LiveTeamPreview(
                        batsmen: BatData_Player,
                        bowlers: BowlData_Player,
                        allrounders: ARData_Player,
                        wicketkeeper: Wk_PlayersData,
                        Wk_points_Data: Wk_points_data,
                        team2_id: widget.team2_id,
                        team1_id: widget.team1_id,
                        Bat_points_Data: Bat_points_data,
                        AR_points_Data: AR_points_data,
                        Bowl_points_Data: Bowl_points_data,
                        time_hours: "0",
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

  void _showDetailsPopup(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Details"),
          content: Text(
            "$text",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
          ),
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

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

Widget _buildCircularBoxes(String recentOvsStats) {
  List<String> statsArray = recentOvsStats.split('|');
  String lastStat = statsArray.isNotEmpty ? statsArray.last.trim() : "";
  List<String> dataArray = lastStat.split(' '); // Split by whitespace

  print("characters: " + dataArray.toString());

  List<Widget> circularBoxes = [];

  for (int i = 0; i < dataArray.length; i++) {
    String character = dataArray[i]; // Access dataArray, not lastStat
    print("characters: " + character);
    circularBoxes.add(_buildSingleCircularBox(character));
  }

  return Padding(
    padding: const EdgeInsets.only(left: 2),
    child: Row(
      children: circularBoxes,
    ),
  );
}

Widget _buildSingleCircularBox(String character) {
  return Container(
    width: 20,
    height: 20,
    margin: EdgeInsets.only(right: 2), // Adjust margin as needed
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    ),
    child: Center(
      child: Text(
        character,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
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
