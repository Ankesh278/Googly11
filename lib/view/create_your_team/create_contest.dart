import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/GetContestData/Data.dart';
import 'package:world11/Model/GetContestData/GetContestDataClass.dart';
import 'package:world11/Model/UserAllContestData/UserAllContestDataResponse.dart';
import 'package:world11/view/MyTeams.dart';
import '../../ApiCallProviderClass/API_Call_Class.dart';
import '../../App_Widgets/CustomText.dart';
import '../../Model/LiveTeamPreviewModel/Data.dart';
import '../../Model/LiveTeamPreviewModel/LiveTeamPreviewResponse.dart';
import '../../Model/LiveTeamPreviewModel/Players.dart';
import '../../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../../Model/UserAllContestData/Data.dart';
import '../../Model/UserAllData/GetUserAllData.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Add Cash In Wallet.dart';
import '../BeforJoiningContestView.dart';
import '../JoinContextWithTeam.dart';
import '../Team Preview.dart';
import '../UpdateCreatedTeam.dart';
import 'createTeam.dart';
import 'make_team_payment.dart';
import 'package:http/http.dart' as http;

class CreateContest extends StatefulWidget {
  var logo1,
      logo2,
      text1,
      text2,
      match_id,
      time_hours,
      team1_Id,
      team2_Id,
      HighestScore,
      Average_Score;
  CreateContest(
      {Key? key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.time_hours,
      this.match_id,
      this.team1_Id,
      this.team2_Id,
      this.Average_Score,
      this.HighestScore})
      : super(key: key);
  @override
  State<CreateContest> createState() => _CreateContestState();
}

class _CreateContestState extends State<CreateContest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _email;
  String? _userName;
  String _token = '';
  Future<List<ContestData>?>? contest_Data;
  List<TeamDataContest> AllTeamUserCreateData = [];
  bool isContainerVisible = false;
  Map<int, bool> isContainerVisibleMap = {};

  List<LiveTeamPreviewData>? allTeamUserCreateData;
  List<Players_>? players_Data = [];
  List<PlayersData_> player_Id = [];
  String total_Points = '';
  List<PlayersData_> Wk_PlayersData = [];
  List<PlayersData_> BatData_Player = [];
  List<PlayersData_> ARData_Player = [];
  List<PlayersData_> BowlData_Player = [];
  int team_Id = 0;
  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };
  List<String> points_Data = [];
  List<bool> isLoadingList = List.generate(25, (index) => false);
  late Timer _timer;
  late Duration _remainingTime;
  List<String> Wk_points_data = [];
  List<String> Bat_points_data = [];
  List<String> AR_points_data = [];
  List<String> Bowl_points_data = [];
  bool _isLoading = false;
  int lineupStatus = 0;

  @override
  void initState() {
    super.initState();
    getPrefrenceData();
    _tabController = TabController(length: 3, vsync: this);

    // Perform null checks before accessing widget properties
    if (widget.time_hours != null) {
      print("time_Data::::::::" + widget.time_hours.toString());
      DateTime targetTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(widget.time_hours.toString()));
      _remainingTime = targetTime.difference(DateTime.now());
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        // Check if the remaining time is greater than 0
        if (_remainingTime.inSeconds > 0) {
          setState(() {
            _remainingTime = targetTime.difference(DateTime.now());
          });
        } else {
          timer.cancel();
          setState(() {
            lineupStatus = 1;
          });

          _remainingTime = Duration(seconds: 0);
          showBottomSheetDialog();
        }
      });
    }

    // Perform null checks for other widget properties as needed
    if (widget.HighestScore != null && widget.Average_Score != null) {
      print("Data::::dsbfdhhf" +
          widget.HighestScore.toString() +
          "::::::" +
          widget.Average_Score);
    }

    if (widget.team1_Id != null && widget.team2_Id != null && widget.match_id != null) {
      print("Team_1::::::::" + widget.team1_Id.toString());
      print("Team_2::::::::" + widget.team2_Id.toString());
      print("Match_id_Data::::::::" + widget.match_id.toString());
      // fetchUserTeamData(widget.match_id);
    }
  }


  @override
  void dispose() {
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<List<ContestData>?> fetchData() async {
    final String apiUrl =
        "https://admin.googly11.in/api/get_contest?match_id=${widget.match_id}";
    print("Dataa:::::::::::::" + widget.match_id.toString());
    final String token = _token;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Response: ${response.body}');
    print('Response: ${response}');
    if (response.statusCode == 200) {
      GetContestDataClass contestDataClass =
          GetContestDataClass.fromJson(json.decode(response.body));
      if (contestDataClass.status == 1) {
        print('Response: ${response.body}');
        return contestDataClass.data;
      } else {
        print('Response: ${response.body}');
        return contestDataClass.data;
      }
    } else if (response.statusCode == 400) {
      print('Response: ${response.body}');
      GetContestDataClass upcomingMatch =
          GetContestDataClass.fromJson(jsonDecode(response.body));
      if (upcomingMatch.status == 0) {
        return upcomingMatch.data;
      }
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
    return null;
  }

  Future<void> fetchUserTeam() async {
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    apiProvider.fetchUserTeamData(widget.match_id, _token);
    apiProvider.fetchData(widget.match_id, _token);
    contest_Data = apiProvider.fetchDataContestData(widget.match_id, _token);
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
      fetchUserAllData(token.toString());
      // contest_Data=fetchData();
      fetchUserTeam();
    });
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
  }

  Future<List<TeamDataContest>?> fetchUserTeamData(String match_id) async {
    final url =
        'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$match_id';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      print('Response::::::::::::::: ${response.body}');
      print('Error::::::::::::::: ${response.statusCode}');
      if (response.statusCode == 200) {
        UserAllContestDataResponse contestDataResponse =
            UserAllContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
          AllTeamUserCreateData = contestDataResponse.data!;
          return contestDataResponse.data;
        }
      } else if (response.statusCode == 401) {
        UserAllContestDataResponse contestDataResponse =
            UserAllContestDataResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 0) {
          AllTeamUserCreateData = contestDataResponse.data!;
          return contestDataResponse.data;
        }
        // Handle errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Exception: $error');
    }
    return null;
  }

  Future<void> fetchUserAllData(String token) async {
    var apiUrl = 'https://admin.googly11.in/api/user';
    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      if (response.statusCode == 200) {
        GetUserAllData userAllData =
            GetUserAllData.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          setState(() {
            _userName = userAllData.user!.userName;
          });
          var responseData = jsonDecode(response.body);
          print('API call successful');
          print('Response: $responseData');
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Token not found", textColor: Colors.red);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "User not found", textColor: Colors.red);
      }
    } catch (e) {
      // Handle exceptions
      print('Error making API call: $e');
    }
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
                  '${widget.text1 != null ? widget.text1 : "No Data"} vs ${widget.text2 != null ? widget.text2 : "No Data"}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                CountdownTimerWidget(
                    time: widget.time_hours != null
                        ? widget.time_hours
                        : "No Data"),
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
      body: Column(
        children: [
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
                                width: 2.0,
                                color: Colors
                                    .red), // Set the thickness and color of the underline
                            insets: EdgeInsets.symmetric(
                                horizontal:
                                    16.0), // Adjust the horizontal padding of the underline
                          ),
                          tabs: [
                            Tab(text: 'All Contests'),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'My contest',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Expanded(
                                    child: Consumer<ApiProvider>(
                                      builder: (context, apiProvider, child) {
                                        return Text(
                                          ' (${apiProvider.allContestCreateData != null ? apiProvider.allContestCreateData!.length : '0'})',
                                          style: TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tab(text: 'Expert Teams'),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey[100],
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                lineupStatus == 0
                                    ? Column(
                                        children: [
                                          Consumer<ApiProvider>(builder:
                                              (context, apiProvider, child) {
                                            return apiProvider
                                                            .all_Contest_Data !=
                                                        null &&
                                                    apiProvider
                                                        .all_Contest_Data!
                                                        .isNotEmpty
                                                ? Padding(
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
                                                            Text(
                                                              "Prize Pool",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 11,
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
                                                              size: 15,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15,
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Winners",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 11,
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
                                                              size: 15,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15,
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Sports",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 11,
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
                                                              size: 15,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15,
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Entry Fee",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 11,
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
                                                              size: 15,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_downward,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Container();
                                          }),
                                          Consumer<ApiProvider>(builder:
                                              (context, apiProvider, child) {
                                            return Expanded(
                                              child: FutureBuilder<
                                                  List<ContestData>?>(
                                                future: contest_Data,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child:
                                                      SpinKitFadingCircle(
                                                        color: Colors.redAccent,
                                                        size: 50.0,
                                                      )
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Container(
                                                            height: 150,
                                                            width:
                                                                double.infinity,
                                                            child: Image.asset(
                                                              ImageAssets
                                                                  .no_events_available,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Text(
                                                            "No contest available for this match",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
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
                                                            contest_Data = apiProvider
                                                                .fetchDataContestData(
                                                                    widget
                                                                        .match_id,
                                                                    _token);
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 25,
                                                              ),
                                                              Container(
                                                                height: 150,
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    Image.asset(
                                                                  ImageAssets
                                                                      .no_events_available,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 25,
                                                              ),
                                                              Text(
                                                                "No contest available for this match",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ));
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
                                                          contest_Data = apiProvider
                                                              .fetchDataContestData(
                                                                  widget
                                                                      .match_id,
                                                                  _token);
                                                        });
                                                      },
                                                      child: ListView.builder(
                                                        itemCount: snapshot
                                                            .data!.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final event = snapshot
                                                              .data![index];
                                                          double entryFee =
                                                              double.parse(event
                                                                  .entryFee);
                                                          double
                                                              discountPercentage =
                                                              event.discounts /
                                                                  100;
                                                          double discountedFee =
                                                              entryFee +
                                                                  (entryFee *
                                                                      discountPercentage);
                                                          // print("EntryFee0:::"+entryFee.toString());
                                                          // print("EntryFee1:::"+event.discounts.toString());
                                                          // print("EntryFee2:::"+discountedFee.toString());
                                                          // print("EntryFee3:::"+discountPercentage.toString());

                                                          double result = double
                                                                  .parse(event
                                                                      .userParticipant
                                                                      .toString()) *
                                                              double.parse(event
                                                                  .winnerCriteria
                                                                  .toString()) /
                                                              100;
                                                          // print("result"+result.toString());
                                                          double newData =
                                                              double.parse(event
                                                                      .userParticipant
                                                                      .toString()) -
                                                                  result;
                                                          // print("remaining_Time:::::::"+_remainingTime.inSeconds.toString());
                                                          // if (_remainingTime.inSeconds >= 0) {
                                                          return Consumer<
                                                                  ApiProvider>(
                                                              builder: (context,
                                                                  apiProvider,
                                                                  child) {
                                                            return Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => MakeTeamPayMent(
                                                                                  team1_Id: widget.team1_Id,
                                                                                  team2_Id: widget.team2_Id,
                                                                                  text1: widget.text1,
                                                                                  text2: widget.text2,
                                                                                  Match_Id: widget.match_id,
                                                                                  logo1: widget.logo1,
                                                                                  logo2: widget.logo2,
                                                                                  time_hours: widget.time_hours,
                                                                                  app_charge: event.appCharge,
                                                                                  entry_fee: event.entryFee,
                                                                                  Number_of_user: event.numberOfUser,
                                                                                  user_participant: event.userParticipant,
                                                                                  Contest_Id: event.id,
                                                                                  first_Prize: event.firstPrize,
                                                                                  winnerCriteria: event.winnerCriteria,
                                                                                  total_Teams_allow: event.totalTeamsAllowed,
                                                                                  lineup_out: apiProvider.is_lineupOut,
                                                                                  useBonus: event.useBonus,
                                                                                  AverageScore: widget.Average_Score,
                                                                                  HeightsScore: widget.HighestScore,
                                                                                )));
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    child: Card(
                                                                      elevation:
                                                                          20,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        height: size.height *
                                                                            0.27,
                                                                        width: size.width *
                                                                            0.95,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(12)),
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.6),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              height: size.height * 0.07,
                                                                              width: size.width * 0.95,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(12),
                                                                                  topRight: Radius.circular(12),
                                                                                ),
                                                                                gradient: LinearGradient(
                                                                                  begin: Alignment.topLeft,
                                                                                  end: Alignment.bottomRight,
                                                                                  colors: [
                                                                                    Color(0xFFfce1e1), // Convert hex to Color
                                                                                    Color(0xFFf0c7df), // Convert hex to Color
                                                                                  ], // Change colors as needed
                                                                                ),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  if (event.prizeDistribution != null && event.prizeDistribution!.isNotEmpty)
                                                                                    Text(
                                                                                      "Rank ${event.prizeDistribution![0].rankFrom} : ₹ ${event.prizeDistribution![0].prizeAmount}",
                                                                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                                                                                    ),
                                                                                  if (event.prizeDistribution != null && event.prizeDistribution!.length > 1)
                                                                                    Text(
                                                                                      event.prizeDistribution![1].rankFrom == event.prizeDistribution![1].rankUpto ? " | Rank ${event.prizeDistribution![1].rankUpto} : ₹ ${event.prizeDistribution![1].prizeAmount} each" : " | Rank ${event.prizeDistribution![1].rankFrom} - ${event.prizeDistribution![1].rankUpto} : ₹ ${event.prizeDistribution![1].prizeAmount} each",
                                                                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: size.height * 0.01),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                CustomPaddedText(
                                                                                  text: event.contestName != null ? event.contestName : '',
                                                                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black),
                                                                                ),
                                                                                if (double.parse(discountedFee.toString()).toInt() != double.parse(event.entryFee.toString()).toInt())
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(right: 12),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'Entry:',
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 12,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          ' ₹ ${double.parse(discountedFee.toString()).toInt()}',
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontSize: 13,
                                                                                            color: Colors.green,
                                                                                            decoration: TextDecoration.lineThrough,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 8),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  CustomPaddedText(
                                                                                    text: () {
                                                                                      try {
                                                                                        if (event.entryFee != null) {
                                                                                          double result = double.parse(event.entryFee.toString()) * double.parse(event.userParticipant.toString()) * double.parse(event.appCharge.toString()) / 100;
                                                                                          double newData = double.parse(event.entryFee.toString()) * double.parse(event.userParticipant.toString()) - result;

                                                                                          // Check if the decimal part is zero
                                                                                          if (newData % 1 == 0) {
                                                                                            // If the decimal part is zero, display the amount without decimals
                                                                                            return '\u20B9 ' + newData.toInt().toString();
                                                                                          } else {
                                                                                            // If the decimal part is not zero, display the amount with two decimal places
                                                                                            String formattedValue = '\u20B9 ' + newData.toStringAsFixed(2);

                                                                                            // If the value is greater than 100000, display it in lakh
                                                                                            if (newData > 100000) {
                                                                                              double lakhValue = newData / 100000;
                                                                                              formattedValue = '\u20B9 ' + lakhValue.toStringAsFixed(2) + ' Lakh';
                                                                                            }

                                                                                            // Remove trailing .00
                                                                                            formattedValue = formattedValue.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

                                                                                            return formattedValue;
                                                                                          }
                                                                                        } else {
                                                                                          return '\u20B9 5487';
                                                                                        }
                                                                                      } catch (e) {
                                                                                        // Handle the parsing error
                                                                                        print("Error parsing entryFee: $e");
                                                                                        return '';
                                                                                      }
                                                                                    }(),
                                                                                    style: TextStyle(
                                                                                      fontSize: 20,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Consumer<ApiProvider>(
                                                                                    builder: (context, apiProvider, child) {
                                                                                      return InkWell(
                                                                                        onTap: () async {
                                                                                          if (apiProvider.allTeamUserCreateData != null && apiProvider.allTeamUserCreateData.length != 0) {
                                                                                            if (event.contestLimit == "not full") {
                                                                                              if (event.entryFee.toString() == "0.00") {
                                                                                                Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder: (context) => JoinContestWithTeam(
                                                                                                      logo2: widget.logo2,
                                                                                                      logo1: widget.logo1,
                                                                                                      text2: widget.text2,
                                                                                                      text1: widget.text1,
                                                                                                      time_hours: widget.time_hours,
                                                                                                      match_id: widget.match_id,
                                                                                                      team1_Id: widget.team1_Id,
                                                                                                      team_2_Id: widget.team2_Id,
                                                                                                      contest_id: event.id,
                                                                                                      total_team_Limit: event.totalTeamsAllowed,
                                                                                                      Entry_Free: event.entryFee,
                                                                                                      HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                                                                                                      Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
                                                                                                      UseBonus: event.useBonus,
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              } else {
                                                                                                showBottomSheetConfirmation(widget.logo1, widget.logo2, widget.text1, widget.text2, widget.time_hours, widget.match_id, widget.team1_Id, widget.team2_Id, event.id, event.totalTeamsAllowed, event.entryFee, event.discounts, event.useBonus, widget.HighestScore, widget.Average_Score);
                                                                                              }
                                                                                            } else {
                                                                                              Fluttertoast.showToast(msg: "Contest is already full", backgroundColor: Colors.black, textColor: Colors.white);
                                                                                            }
                                                                                          } else {
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
                                                                                                  team2_id: widget.team2_Id,
                                                                                                  HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                                                                                                  Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          }
                                                                                        },
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.only(right: 10),
                                                                                          height: size.height * 0.04,
                                                                                          width: size.width * 0.2,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.green,
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              event.entryFee != null && event.entryFee.toString() == "0.00" ? "Free" : "₹ ${double.parse(event.entryFee.toString()).toStringAsFixed(0)}",
                                                                                              style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 5,
                                                                            ),
                                                                            LinearProgressBar(
                                                                              maxSteps: event.userParticipant,
                                                                              progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                                                                              currentStep: event.numberOfUser,
                                                                              progressColor: Colors.red,
                                                                              backgroundColor: Colors.grey,
                                                                            ),
                                                                            SizedBox(
                                                                              height: size.height * 0.01,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    event.contestLimit.toString() == "not full" ? '${int.parse(event.userParticipant.toString()) - int.parse(event.numberOfUser.toString())} spots left' : "Contest Full",
                                                                                    style: TextStyle(
                                                                                      color: event.contestLimit.toString() == "not full" ? Colors.green : Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    event.number_of_full_contest > 0 ?  '${event.number_of_full_contest} Contest filled' : "",
                                                                                    style: TextStyle(
                                                                                      color: event.number_of_full_contest > 0 ? Colors.black : Colors.black,
                                                                                      fontSize: 13
                                                                                    ),
                                                                                  ),

                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: size.height * 0.05,
                                                                              width: size.width * 0.95,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.only(
                                                                                  bottomRight: Radius.circular(12),
                                                                                  bottomLeft: Radius.circular(12),
                                                                                ),
                                                                                color: Color(0xFFF0F0F0),
                                                                              ),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  ElTooltip(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.looks_one_sharp,
                                                                                          color: Colors.black54,
                                                                                          size: 15,
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
                                                                                    showChildAboveOverlay: false,
                                                                                    timeout: Duration(seconds: 4),
                                                                                    color: Colors.blue,
                                                                                    showModal: false,
                                                                                    content: Text(
                                                                                      "First Prize = ${event.firstPrize != null ? event.firstPrize : "1000 Rs"}",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                                                                    ),
                                                                                  ),

                                                                                  ElTooltip(
                                                                                    child: Row(
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
                                                                                    showChildAboveOverlay: false,
                                                                                    color: Colors.blue,
                                                                                    showModal: false,
                                                                                    timeout: Duration(seconds: 4),
                                                                                    content: Text(
                                                                                      "$newData teams win the contest",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                                                                    ),
                                                                                  ),

                                                                                  ElTooltip(
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.bookmark_sharp,
                                                                                          color: Colors.black54,
                                                                                          size: 15,
                                                                                        ),
                                                                                        Text(
                                                                                          " Upto ${event.totalTeamsAllowed.toString()}",
                                                                                          style: TextStyle(
                                                                                            color: Colors.black54,
                                                                                            fontSize: 13,
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    showChildAboveOverlay: false,
                                                                                    color: Colors.blue,
                                                                                    showModal: false,
                                                                                    timeout: Duration(seconds: 4),
                                                                                    content: Text(
                                                                                      "Max ${event.totalTeamsAllowed} entries per user in this contest",
                                                                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                                                                    ),
                                                                                  ),

                                                                                  if (event.guaranteed == 1)
                                                                                    ElTooltip(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons.check_circle,
                                                                                            color: Colors.black54,
                                                                                            size: 15,
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
                                                                                      showChildAboveOverlay: false,
                                                                                      color: Colors.blue,
                                                                                      showModal: false,
                                                                                      timeout: Duration(seconds: 4),
                                                                                      content: Text(
                                                                                        "Guaranteed to take place regardless of spots filled",
                                                                                        style: TextStyle(color: Colors.white, fontSize: 13),
                                                                                      ),
                                                                                    ),
                                                                                  // InkWell(
                                                                                  //   onTap: (){
                                                                                  //     _showDetailsPopup(context,"");
                                                                                  //   },
                                                                                  //   child: Padding(
                                                                                  //     padding: const EdgeInsets.only(right: 5),
                                                                                  //     child:
                                                                                  //   ),
                                                                                  // ),
                                                                                  if (event.guaranteed == 0)
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                          // } else {
                                                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          //   showBottomSheetDialog();
                                                          // });
                                                          return Container();
                                                          // }
                                                        },
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          }),
                                        ],
                                      )
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Container(
                                              height: 150,
                                              width: double.infinity,
                                              child: Image.asset(
                                                ImageAssets.no_events_available,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Text(
                                              "No contest available for this match",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                Consumer<ApiProvider>(
                                  builder: (context, apiProvider, child) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10, top: 10),
                                      child:
                                          apiProvider.allContestCreateData !=
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
                                                    bool isEntryVisible =
                                                        isContainerVisibleMap[
                                                                index] ??
                                                            false;
                                                    double result =
                                                        double.parse(event
                                                                .userParticipant
                                                                .toString()) *
                                                            double.parse(event
                                                                .winnerCriteria
                                                                .toString()) /
                                                            100;
                                                    print("result" +
                                                        result.toString());
                                                    double newData =
                                                        double.parse(event
                                                                .userParticipant
                                                                .toString()) -
                                                            result;
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BeforeJoiningContestView(
                                                                          team1_Id:
                                                                              widget.team1_Id,
                                                                          team2_Id:
                                                                              widget.team2_Id,
                                                                          text1:
                                                                              widget.text1,
                                                                          text2:
                                                                              widget.text2,
                                                                          Match_Id:
                                                                              widget.match_id,
                                                                          logo1:
                                                                              widget.logo1,
                                                                          logo2:
                                                                              widget.logo2,
                                                                          time_hours:
                                                                              widget.time_hours,
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
                                                                          lineup_out:
                                                                              apiProvider.is_lineupOut,

                                                                        )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.5),
                                                        child: Card(
                                                          elevation: 20,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: !isEntryVisible
                                                                ? size.height *
                                                                    0.27
                                                                : size.height *
                                                                    0.50,
                                                            width: size.width *
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
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      CustomPaddedText(
                                                                        text:
                                                                            () {
                                                                          try {
                                                                            if (event.entryFee !=
                                                                                null) {
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
                                                                  currentStep: event
                                                                      .numberOfUser,
                                                                  progressColor:
                                                                      Colors
                                                                          .red,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      size.height *
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
                                                                          BorderRadius
                                                                              .only(
                                                                        bottomRight:
                                                                            Radius.circular(12),
                                                                        bottomLeft:
                                                                            Radius.circular(12),
                                                                      ),
                                                                      color: Color(
                                                                          0xFFF0F0F0),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        ElTooltip(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.looks_one_sharp,
                                                                                color: Colors.black54,
                                                                                size: 15,
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
                                                                          showChildAboveOverlay:
                                                                              false,
                                                                          timeout:
                                                                              Duration(seconds: 8),
                                                                          color:
                                                                              Colors.blue,
                                                                          showModal:
                                                                              false,
                                                                          content:
                                                                              Text(
                                                                            "First Prize = ${event.firstPrize != null ? event.firstPrize : "1000 Rs"}",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 13),
                                                                          ),
                                                                        ),
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     _showDetailsPopup(context,"First Prize = ${event.firstPrize != null ? event.firstPrize : "1000 Rs"}");
                                                                        //   },
                                                                        //   child: Padding(
                                                                        //     padding: const EdgeInsets.only(left: 5),
                                                                        //     child: Row(
                                                                        //       children: [
                                                                        //         Icon(
                                                                        //           Icons.looks_one_sharp,
                                                                        //           color: Colors.black54,
                                                                        //           size: 13,
                                                                        //         ),
                                                                        //         Text(
                                                                        //           event.firstPrize != null ? event.firstPrize : "1000 Rs",
                                                                        //           style: TextStyle(
                                                                        //             color: Colors.black54,
                                                                        //             fontSize: 13,
                                                                        //             fontWeight: FontWeight.w600,
                                                                        //           ),
                                                                        //         ),
                                                                        //       ],
                                                                        //     ),
                                                                        //   ),
                                                                        // ),

                                                                        ElTooltip(
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
                                                                          showChildAboveOverlay:
                                                                              false,
                                                                          color:
                                                                              Colors.blue,
                                                                          showModal:
                                                                              false,
                                                                          timeout:
                                                                              Duration(seconds: 8),
                                                                          content:
                                                                              Text(
                                                                            "$newData teams win the contest",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 13),
                                                                          ),
                                                                        ),

                                                                        ElTooltip(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.bookmark_sharp,
                                                                                color: Colors.black54,
                                                                                size: 15,
                                                                              ),
                                                                              Text(
                                                                                " Upto ${event.totalTeamsAllowed.toString()}",
                                                                                style: TextStyle(
                                                                                  color: Colors.black54,
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          showChildAboveOverlay:
                                                                              false,
                                                                          color:
                                                                              Colors.blue,
                                                                          showModal:
                                                                              false,
                                                                          timeout:
                                                                              Duration(seconds: 8),
                                                                          content:
                                                                              Text(
                                                                            "Max ${event.totalTeamsAllowed} entries per user in this contest",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 13),
                                                                          ),
                                                                        ),
                                                                        // InkWell(
                                                                        //   onTap: (){
                                                                        //     _showDetailsPopup(context,"Guaranteed to take place regardless of spots filled");
                                                                        //   },
                                                                        //   child: Padding(
                                                                        //     padding: const EdgeInsets.only(right: 5),
                                                                        //     child: Row(
                                                                        //       children: [
                                                                        //         Icon(
                                                                        //           Icons.check_circle,
                                                                        //           color: Colors.black54,
                                                                        //           size: 13,
                                                                        //         ),
                                                                        //         Text(" Guaranteed",style: TextStyle(
                                                                        //           color: Colors.black54,
                                                                        //           fontSize: 13,
                                                                        //           fontWeight: FontWeight.w600,
                                                                        //         ),
                                                                        //         ),
                                                                        //       ],
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      isContainerVisibleMap[
                                                                              index] =
                                                                          !isEntryVisible;
                                                                    });
                                                                  },
                                                                  child:
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
                                                                        if (apiProvider.is_lineupOut ==
                                                                            1)
                                                                          Row(
                                                                            children: [
                                                                              Image(
                                                                                image: AssetImage(ImageAssets.green_tic),
                                                                                height: 10,
                                                                                width: 10,
                                                                              ),
                                                                              Text(
                                                                                "Lineup out",
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        Icon(
                                                                          isEntryVisible
                                                                              ? Icons.keyboard_arrow_up
                                                                              : Icons.keyboard_arrow_down,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                _isLoading
                                                                    ? Center(
                                                                        child:
                                                                             SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ))
                                                                    : Visibility(
                                                                        visible:
                                                                            isEntryVisible,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              186,
                                                                          child:
                                                                              ListView.builder(
                                                                            itemCount:
                                                                                event.joinContestUser!.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              final event_Data = event.joinContestUser![index];
                                                                              print('List length: ${event.joinContestUser!.length}, Accessing index: $index');
                                                                              return InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    _isLoading = true; // Set loading to true when Inkwell is tapped

                                                                                  });
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
                                                                                  fetchUserTeamDataByTeamPreview(widget.match_id, _token, event_Data.teamId.toString(), apiProvider).then((value) {
                                                                                    setState(() {
                                                                                      _isLoading = false; // Set loading to false after data is fetched
                                                                                    });
                                                                                  });
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      if (event_Data.joinContestTeam != null && event_Data.joinContestTeam!.isNotEmpty)
                                                                                      Container(
                                                                                        // Your container contents go here
                                                                                        width: double.infinity,
                                                                                        height: 100,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border.all(color: Colors.grey, width: 1.5),
                                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                          image: DecorationImage(
                                                                                            image: AssetImage(ImageAssets.Ground2), // Replace "assets/background_image.jpg" with your image path
                                                                                            fit: BoxFit.fitWidth,
                                                                                          ),
                                                                                        ),
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    event_Data.joinContestTeam![0].teamName,
                                                                                                    // event.teamName,
                                                                                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    onTap: () {
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

                                                                                                      fetchUserTeamDataByTeamId(widget.match_id, _token, event_Data.teamId.toString()).then((result) {
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
                                                                                                                child:  SpinKitFadingCircle(
                                                                                                                  color: Colors.redAccent,
                                                                                                                  size: 50.0,
                                                                                                                )))
                                                                                                        : Icon(
                                                                                                            Icons.edit,
                                                                                                            color: Colors.white,
                                                                                                          ),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Text(
                                                                                                      "Captain",
                                                                                                      // event.teamName,
                                                                                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                    child: Text(
                                                                                                      "Vice Captain",
                                                                                                      // event.teamName,
                                                                                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Text(
                                                                                                      event_Data.joinContestTeam![0].captainDetails!.nickName,
                                                                                                      // event.teamName,
                                                                                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                    child: Text(
                                                                                                      event_Data.joinContestTeam![0].viceCaptainDetails!.nickName,
                                                                                                      // event.teamName,
                                                                                                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                      "No Contest Join Yet"),
                                                ),
                                    );
                                  },
                                ),
                                Center(
                                  child: Text(
                                    "Coming Soon",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                ),
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
          Consumer<ApiProvider>(builder: (context, apiProvider, child) {
            return apiProvider.all_Contest_Data != null &&
                    apiProvider.all_Contest_Data!.isNotEmpty
                ? Stack(
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
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyTeams(
                                    logo2: widget.logo2,
                                    logo1: widget.logo1,
                                    text2: widget.text2,
                                    text1: widget.text1,
                                    time_hours: widget.time_hours,
                                    match_id: widget.match_id,
                                    team1_Id: widget.team1_Id,
                                    team_2_Id: widget.team2_Id,
                                    HighestScore: widget.HighestScore != null
                                        ? widget.HighestScore
                                        : '',
                                    Average_Score: widget.Average_Score != null
                                        ? widget.Average_Score
                                        : '',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              height: size.height * 0.05,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.lightBlue,
                                    width: 2,
                                    style: BorderStyle.solid),
                              ),
                              child: Consumer<ApiProvider>(
                                builder: (context, apiProvider, child) {
                                  return Center(
                                    child: Text(
                                      'My Teams(${apiProvider.allTeamUserCreateData != null ? apiProvider.allTeamUserCreateData.length : 0})',
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    var createTeam = CreateTeam(
                                      logo2: widget.logo2,
                                      logo1: widget.logo1,
                                      text2: widget.text2,
                                      text1: widget.text1,
                                      time_hours: widget.time_hours,
                                      Match_id: widget.match_id,
                                      team1_id: widget.team1_Id,
                                      team2_id: widget.team2_Id,
                                      HighestScore: widget.HighestScore != null
                                          ? widget.HighestScore
                                          : '',
                                      Average_Score:
                                          widget.Average_Score != null
                                              ? widget.Average_Score
                                              : '',
                                    );
                                    return createTeam;
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20, top: 20),
                              height: size.height * 0.05,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueAccent,
                              ),
                              child: Center(
                                child: Text(
                                  'CREATE TEAM'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container();
          }),
        ],
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(0xFFfce1e1), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
      1.0, // Opacity
    );
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
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void showBottomSheetDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Set this to false
      builder: (BuildContext context) {
        return YourBottomSheet();
      },
    );
  }

  void showBottomSheetConfirmation(
      var logo1,
      var logo2,
      var text1,
      var text2,
      var time_hours,
      var match_Id,
      var Team1_Id,
      var Team2_id,
      var id,
      var total_team_Allow,
      var entryFee,
      var discount,
      var useBonus,
      var HighestScore,
      var AverageScore) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Set this to false
      builder: (BuildContext context) {
        return ConfirmationBottomSheet(
          text1: text1,
          text2: text2,
          logo1: logo1,
          logo2: logo2,
          match_id: match_Id,
          team1_Id: Team1_Id,
          team2_Id: Team2_id,
          time_hours: time_hours,
          id: id,
          total_team_allow: total_team_Allow,
          entry_Fee: entryFee,
          discount: discount,
          useBonus: useBonus,
          Average_Score: AverageScore,
          HighestScore: HighestScore,
        );
      },
    );
  }

  Future<List<Players_>?> fetchUserTeamDataByTeamId(
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
            player_Id.add(PlayersData_(
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
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));

            if (players_Data![i].playerDetails!.roleType == "WICKET KEEPER") {
              print('Response::::::::::ewyttyData1 ${response.body}');
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
                  isPlay: players_Data![i].playerDetails!.isPlay,
                  captionByuser: players_Data![i].playerDetails!.isPlay,
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
            }
            if (players_Data![i].playerDetails!.roleType == "BATSMEN") {
              print('Response::::::::::ewyttyData2 ${response.body}');
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
                playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if (players_Data![i].playerDetails!.roleType == "ALL ROUNDER") {
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
                  isPlay: players_Data![i].playerDetails!.isPlay,
                  captionByuser: players_Data![i].playerDetails!.isPlay,
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
            }
            if (players_Data![i].playerDetails!.roleType == "BOWLER") {
              print('Response::::::::::ewyttyData4 ${response.body}');
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
                  isPlay: players_Data![i].playerDetails!.isPlay,
                  captionByuser: players_Data![i].playerDetails!.isPlay,
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
            }
          }
          print("Data___::::::::::::" + Wk_PlayersData.length.toString());
          print("Data___::::::::::::" + BatData_Player.length.toString());
          print("Data___::::::::::::" + ARData_Player.length.toString());
          print("Data___::::::::::::" + BowlData_Player.length.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateCreatedTeam(
                        time_hours: widget.time_hours,
                        team2_id: widget.team2_Id,
                        team1_id: widget.team1_Id,
                        Match_id: widget.match_id,
                        logo1: widget.logo1,
                        logo2: widget.logo2,
                        text1: widget.text1,
                        text2: widget.text2,
                        teamDataAll: player_Id,
                        captain_id: allTeamUserCreateData![0].captain!.playerId,
                        vice_captain_Id:
                            allTeamUserCreateData![0].viceCaptain!.playerId,
                        Wk_PlayersData: Wk_PlayersData,
                        BowlData_Player: BowlData_Player,
                        ARData_Player: ARData_Player,
                        BatData_Player: BatData_Player,
                        total_Points: total_Points,
                        team_Id: team_Id,
                        selected_Captain_Name:
                            allTeamUserCreateData![0].captain!.nickName,
                        selected_Vice_Captain_Name:
                            allTeamUserCreateData![0].viceCaptain!.nickName,
                        HighestScore: widget.HighestScore != null
                            ? widget.HighestScore
                            : '',
                        Average_Score: widget.Average_Score != null
                            ? widget.Average_Score
                            : '',
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

  Future<List<Players_>?> fetchUserTeamDataByTeamPreview(String matchId,
      String token, String team_id, ApiProvider apiProvider) async {
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
            player_Id.add(PlayersData_(
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
                isPlay: players_Data![i].playerDetails!.isPlay,
                captionByuser: players_Data![i].playerDetails!.isPlay,
                VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));

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
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
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
                  playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                  captain: players_Data![i].captain,
                  viceCaptain: players_Data![i].viceCaptain,
                  isPlay: players_Data![i].playerDetails!.isPlay,
                  captionByuser: players_Data![i].playerDetails!.isPlay,
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
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
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
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
                  VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay));
            }
          }
          print("Data___::::::::::::" + Wk_PlayersData.length.toString());
          print("Data___::::::::::::" + BatData_Player.length.toString());
          print("Data___::::::::::::" + ARData_Player.length.toString());
          print("Data___::::::::::::" + BowlData_Player.length.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TeamPreview(
                        batsmen: BatData_Player,
                        bowlers: BowlData_Player,
                        allrounders: ARData_Player,
                        wicketkeeper: Wk_PlayersData,
                        points: points,
                        time_hours: widget.time_hours,
                        team1: widget.text1,
                        team2: widget.text2,
                        team1_id: widget.team1_Id,
                        team2_id: widget.team2_Id,
                        credits_Points: total_Points,
                        lineup: apiProvider.is_lineupOut,
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
}

class YourBottomSheet extends StatefulWidget {
  YourBottomSheet();
  @override
  _YourBottomSheetState createState() => _YourBottomSheetState();
}

class _YourBottomSheetState extends State<YourBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Deadline Passed!',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Image.asset(
              ImageAssets.Alert_logo,
              height: 50,
              width: 50,
            ),
            SizedBox(height: 16.0),
            ListTile(
              title: Text(
                'You can not join contests for this match\n Anymore select another match to play',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.green.withOpacity(0.8);
                      }
                      return Colors.green;
                    },
                  ),
                ),
                onPressed: () {
                  // Use WidgetsBinding.instance.addPostFrameCallback to navigate
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
                child: Text('VIEW UPCOMING MATCHES'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class ConfirmationBottomSheet extends StatefulWidget {
  var logo1,
      logo2,
      text1,
      text2,
      time_hours,
      match_id,
      team1_Id,
      team2_Id,
      id,
      total_team_allow,
      entry_Fee,
      discount,
      useBonus,
      HighestScore,
      Average_Score;
  ConfirmationBottomSheet(
      {Key? key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.time_hours,
      this.Average_Score,
      this.HighestScore,
      this.match_id,
      this.team1_Id,
      this.team2_Id,
      this.id,
      this.total_team_allow,
      this.entry_Fee,
      this.discount,
      this.useBonus});
  @override
  ConfirmationBottomSheet_state createState() =>
      ConfirmationBottomSheet_state();
}

class ConfirmationBottomSheet_state extends State<ConfirmationBottomSheet> {
  double TotalFee = 0.0;
  double discountedFee = 0.0;
  double ToPay = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    // double entryFee = double.parse(widget.entry_Fee) ;
    //  discountedFee = (entryFee - widget.useBonus) - widget.discount;
    double entryFee = double.parse(widget.entry_Fee);
    double discountPercentage = widget.discount / 100;
    discountedFee = entryFee * discountPercentage;
    TotalFee = entryFee + (entryFee * discountPercentage);
    ToPay = TotalFee - discountedFee - widget.useBonus;
    print("discountedFee::::" + discountedFee.toString());
    print("TotalFee::::" + TotalFee.toString());
    print("ToPay::::" + ToPay.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              if (discountedFee.toString().isNotEmpty &&
                  discountedFee.toInt() != 0)
                Positioned.fill(
                  child: Image.asset(
                    ImageAssets
                        .Celebration, // Replace this with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              // Your existing container with content
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'CONFIRMATION',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Amount Unutilised + Winnings = ₹${widget.entry_Fee.toString()}',
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(color: Colors.grey, height: 1),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Entry',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '₹${double.parse(TotalFee.toString()).toInt()}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    if (widget.discount != null && widget.discount != 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Discount',
                                style: TextStyle(fontSize: 13),
                              ),
                              Image(
                                image: AssetImage(ImageAssets.Discount2),
                                height: 25,
                                width: 25,
                              )
                            ],
                          ),
                          Text(
                            '-₹${double.parse(discountedFee.toString()).toInt()}',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Usable Bonus Cash',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '-₹${widget.useBonus}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(color: Colors.grey, height: 1),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'To Pay',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.warning_amber_outlined,
                              size: 10,
                            )
                          ],
                        ),
                        Text(
                          '₹${double.parse(ToPay.toString()).toInt()}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'I agree with the started T&Cs',
                      style: TextStyle(fontSize: 12),
                    ),
                    ListTile(
                      title: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.green.withOpacity(0.8);
                              }
                              return Colors.green;
                            },
                          ),
                        ),
                        onPressed: () {
                          // Use WidgetsBinding.instance.addPostFrameCallback to navigate
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JoinContestWithTeam(
                                logo2: widget.logo2,
                                logo1: widget.logo1,
                                text2: widget.text2,
                                text1: widget.text1,
                                time_hours: widget.time_hours,
                                match_id: widget.match_id,
                                team1_Id: widget.team1_Id,
                                team_2_Id: widget.team2_Id,
                                contest_id: widget.id,
                                total_team_Limit: widget.total_team_allow,
                                Entry_Free: widget.entry_Fee,
                                HighestScore: widget.HighestScore != null
                                    ? widget.HighestScore
                                    : '',
                                Average_Score: widget.Average_Score != null
                                    ? widget.Average_Score
                                    : '',
                                UseBonus: widget.useBonus,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'JOIN CONTEST',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          )),
    ));
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
          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
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
