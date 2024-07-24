import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/UserAllTeamContestData/Players.dart';
import 'package:http/http.dart' as http;
import '../ApiCallProviderClass/API_Call_Class.dart';
import '../Model/JoinUpcomingContestModel/JoinUpcomingModel.dart';
import '../Model/PlayersTeamCreateData/PlayersData.dart';
import '../Model/UserAllTeamContestData/Data.dart';
import '../resourses/Image_Assets/image_assets.dart';
import 'Add Cash In Wallet.dart';
import 'create_your_team/create_contest.dart';
import 'loginView/login_view.dart';

class JoinContestWithTeam extends StatefulWidget {
  final logo1,
      logo2,
      text1,
      text2,
      time_hours,
      match_id,
      team1_Id,
      team_2_Id,
      contest_id,
      total_team_Limit,
      Entry_Free,
      HighestScore,
      Average_Score,
      UseBonus;
  JoinContestWithTeam(
      {super.key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.time_hours,
      this.match_id,
      this.team1_Id,
      this.team_2_Id,
      this.contest_id,
      this.total_team_Limit,
      this.Entry_Free,
      this.HighestScore,
      this.Average_Score,
      this.UseBonus});

  @override
  State<JoinContestWithTeam> createState() => _MyTeamsState();
}

class _MyTeamsState extends State<JoinContestWithTeam> {
  bool captain = true;
  bool vice_captain = false;
  String _token = '';
  int selectedTeamID = 0;
  List<TeamDataAll>? allTeamUserCreateData;
  List<Players>? players_Data = [];
  List<String> player_Id = [];
  String total_Points = '';
  List<PlayersData> Wk_PlayersData = [];
  List<PlayersData> BatData_Player = [];
  List<PlayersData> ARData_Player = [];
  List<PlayersData> BowlData_Player = [];
  List<String> selectedTeamIDs = [];
  int team_Id = 0;
  Future<List<TeamDataAll>?>? dataListPlayer;

  bool isRadioSelected = false;
  bool _is_Loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }

  Future<void> fetchUserTeamData() async {
    // Your existing API call logic here
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    dataListPlayer = apiProvider.fetchUserTeamDataWithContest_Id(
        widget.match_id, _token, widget.contest_id.toString());
    apiProvider.fetchData(widget.match_id, _token);
  }

  Future<void> joinContestWithTeam(String Contest_Id, String Team_id,
      ApiProvider apiProvider, String match_id, String token) async {
    String apiUrl = 'https://admin.googly11.in/api/user-join-contest-with-team';
    print("Match_Id::::::::::" +
        match_id.toString() +
        ":::::" +
        Contest_Id.toString());
    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };
    // Request body
    Map<String, dynamic> body = {
      'contest_id': Contest_Id,
      'team_id': Team_id,
    };
    try {
      // Make the API call
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('API call successful');
      print('Response: ${response.body}');
      print('Response: ${response.statusCode}');
      // Check the response status code
      if (response.statusCode == 200) {
        JoinUpcomingModelContest joinUpcomingModelContest =
            JoinUpcomingModelContest.fromJson(json.decode(response.body));
        if (joinUpcomingModelContest.status == 1) {
          // apiProvider.fetchData(match_id, token);
          Fluttertoast.showToast(
              msg: joinUpcomingModelContest.message,
              textColor: Colors.white,
              backgroundColor: Colors.black);
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateContest(
                        text1: widget.text1,
                        logo1: widget.logo1,
                        logo2: widget.logo2,
                        text2: widget.text2,
                        time_hours: widget.time_hours,
                        match_id: widget.match_id,
                        team2_Id: widget.team_2_Id,
                        team1_Id: widget.team1_Id,
                        HighestScore: widget.HighestScore != null
                            ? widget.HighestScore
                            : '',
                        Average_Score: widget.Average_Score != null
                            ? widget.Average_Score
                            : '',
                      )));
          // Navigator.of(context).pop();
        }
        print('API call successful');
        print('Response: ${response.body}');
      } else if (response.statusCode == 401) {
        JoinUpcomingModelContest joinUpcomingModelContest =
            JoinUpcomingModelContest.fromJson(json.decode(response.body));
        if (joinUpcomingModelContest.status == 0) {
          Fluttertoast.showToast(
              msg: joinUpcomingModelContest.message,
              textColor: Colors.white,
              backgroundColor: Colors.black);
          final SharedPreferences sp = await SharedPreferences.getInstance();
          sp.remove("email_user");
          sp.remove("user_photo");
          sp.remove("user_name");
          sp.remove("token");
          sp.remove("mobile_number");
          sp.remove("invite_code");
          sp.remove("UserName");
          sp.clear();
          String userName = sp.getString("user_name").toString();
          String userPhoto = sp.getString("user_photo").toString();
          print("user_name:::::" + userName + "::::::" + userPhoto);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
              (route) => false);
        }
        print('API call failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        // Error in API call
        JoinUpcomingModelContest joinUpcomingModelContest =
            JoinUpcomingModelContest.fromJson(json.decode(response.body));
        if (joinUpcomingModelContest.status == 0) {
          // Fluttertoast.showToast(msg: joinUpcomingModelContest.message,textColor: Colors.white,backgroundColor: Colors.black);
          InsufficientBalancePopup(
              entry_Fee: widget.Entry_Free, useBonus: widget.UseBonus);
        }
        print('API call failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 500) {
        // Error in API call
        JoinUpcomingModelContest joinUpcomingModelContest =
            JoinUpcomingModelContest.fromJson(json.decode(response.body));
        if (joinUpcomingModelContest.status == 0) {
          Fluttertoast.showToast(
              msg: joinUpcomingModelContest.message,
              textColor: Colors.red,
              backgroundColor: Colors.black);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => AddCashInWallet()));
          print('API call failed with status code: ${response.statusCode}');
          print('Response: ${response.body}');
        }
        print('API call failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      } else {
        JoinUpcomingModelContest joinUpcomingModelContest =
            JoinUpcomingModelContest.fromJson(json.decode(response.body));
        Fluttertoast.showToast(
            msg: joinUpcomingModelContest.message,
            textColor: Colors.red,
            backgroundColor: Colors.black);
      }
    } catch (error) {
      // Handle any exceptions
      print('Error: $error');
    }
  }

  void getPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? email = prefs.getString("email_user");
    // String? userName = prefs.getString("UserName");
    String? token = prefs.getString("token");
    setState(() {
      _token = token!;
      fetchUserTeamData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApiProvider apiProvider =
        Provider.of<ApiProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFDFE4EB),
      appBar: AppBar(
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Text(
                'You can enter upto ${widget.total_team_Limit} teams in this contest',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Consumer<ApiProvider>(
              builder: (context, apiProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Select All (${apiProvider.allTeamUserCreateData_Contest_Id.length})',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 5),
                    Checkbox(
                      value: selectedTeamIDs.length ==
                          apiProvider.allTeamUserCreateData_Contest_Id
                              .where((team) =>
                                  team.joinContestId.toString() !=
                                  widget.contest_id.toString())
                              .length,
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            // Select all teams that are not already joined
                            selectedTeamIDs = apiProvider
                                .allTeamUserCreateData_Contest_Id
                                .where((team) =>
                                    team.joinContestId.toString() !=
                                    widget.contest_id.toString())
                                .map((team) => team.teamID.toString())
                                .toList();
                          } else {
                            selectedTeamIDs.clear();
                          }
                          print("${widget.contest_id.toString()}");
                          print("selected/::::TeamId" +
                              selectedTeamIDs.toString());
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Consumer<ApiProvider>(
            builder: (context, apiProvider, child) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                  child: FutureBuilder(
                    future: dataListPlayer,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitFadingCircle(
                            color: Colors.redAccent,
                            size: 50.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (apiProvider.allTeamUserCreateData_Contest_Id !=
                              null &&
                          apiProvider
                              .allTeamUserCreateData_Contest_Id.isNotEmpty) {
                        return ListView.builder(
                          itemCount: apiProvider
                              .allTeamUserCreateData_Contest_Id.length,
                          itemBuilder: (context, index) {
                            final event = apiProvider
                                .allTeamUserCreateData_Contest_Id[index];
                            bool isTeamDisabled =
                                event.joinContestId.toString() ==
                                    widget.contest_id.toString();
                            apiProvider.allTeamUserCreateData_Contest_Id.sort(
                                (a, b) => a.joinContestId
                                    .toString()
                                    .compareTo(b.joinContestId.toString()));
                            print(
                                "disable_team:::" + isTeamDisabled.toString());
                            print("joinContestId:::" +
                                event.joinContestId.toString() +
                                "::::" +
                                widget.contest_id.toString());
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 170,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors
                                        .grey, // Set the color of the border
                                    width: 2.0, // Set the width of the border
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5)),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  event.teamName,
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                if (isTeamDisabled)
                                                  Text(
                                                    'Joined',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                Checkbox(
                                                  value: selectedTeamIDs
                                                      .contains(event.teamID
                                                          .toString()),
                                                  onChanged: isTeamDisabled
                                                      ? null
                                                      : (value) {
                                                          setState(() {
                                                            if (value!) {
                                                              selectedTeamIDs
                                                                  .add(event
                                                                      .teamID
                                                                      .toString());
                                                            } else {
                                                              selectedTeamIDs
                                                                  .remove(event
                                                                      .teamID
                                                                      .toString());
                                                            }
                                                            print(
                                                                "selectedTeamIDs: $selectedTeamIDs");
                                                          });
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: Container(
                                        height: 110,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(ImageAssets
                                                  .Ground2), // Replace "assets/background_image.jpg" with your image path
                                              fit: BoxFit.fitWidth,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15,
                                                                top: 10),
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                ClipOval(
                                                                  child: Center(
                                                                    child: CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundImage: NetworkImage(event
                                                                            .captain!
                                                                            .image)),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: -2.2,
                                                                  right: 1.5,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors.blue[
                                                                            700],
                                                                    radius: 7,
                                                                    child: Center(
                                                                        child: Text(
                                                                            'C',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 10))),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 20,
                                                              width: 70,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Center(
                                                                  child: Text(
                                                                (event.captain!.nickName
                                                                            .length >
                                                                        10)
                                                                    ? '${event.captain!.nickName.substring(0, 10)}...'
                                                                    : event
                                                                        .captain!
                                                                        .nickName,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 15,
                                                                top: 10),
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                ClipOval(
                                                                  child: Center(
                                                                    child: CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundImage: NetworkImage(event
                                                                            .viceCaptain!
                                                                            .image)),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: -2.2,
                                                                  right: 1.5,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors.blue[
                                                                            700],
                                                                    radius: 7,
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          'VC',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 20,
                                                              width: 70,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Center(
                                                                  child: Text(
                                                                (event.viceCaptain!.nickName
                                                                            .length >
                                                                        10)
                                                                    ? '${event.viceCaptain!.nickName.substring(0, 10)}...'
                                                                    : event
                                                                        .viceCaptain!
                                                                        .nickName,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                right: 15),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              widget.text1
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              event
                                                                  .selectedTeamPlayer1
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 10),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              widget.text2
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Text(
                                                              event
                                                                  .selectedTeamPlayer2
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'WK 3',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      'BAT 4',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      'AR 3',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      'BOWL 1',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
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
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("No teams available"),
                        );
                      }
                    },
                  ),
                ),
              );
            },
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
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (selectedTeamIDs.isNotEmpty) {
                        setState(() {
                          _is_Loading = true;
                        });
                        joinContestWithTeam(
                                widget.contest_id.toString(),
                                selectedTeamIDs.join(','),
                                apiProvider,
                                widget.match_id,
                                _token)
                            .then((value) {
                          setState(() {
                            _is_Loading = false;
                          });
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please select a team",
                            textColor: Colors.red,
                            backgroundColor: Colors.black);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      height: size.height * .05,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: Center(
                        child: _is_Loading
                            ? Center(
                                child: SpinKitFadingCircle(color: Colors.white),
                              )
                            : Text(
                                'Join Contest',
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

class InsufficientBalancePopup extends StatefulWidget {
  final logo1,
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
      useBonus;
  InsufficientBalancePopup(
      {Key? key,
      this.logo1,
      this.logo2,
      this.text1,
      this.text2,
      this.time_hours,
      this.match_id,
      this.team1_Id,
      this.team2_Id,
      this.id,
      this.total_team_allow,
      this.entry_Fee,
      this.discount,
      this.useBonus});
  @override
  InsufficientBalancePopup_State createState() =>
      InsufficientBalancePopup_State();
}

class InsufficientBalancePopup_State extends State<InsufficientBalancePopup> {
  double discountedFee = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    double entryFee = double.parse(widget.entry_Fee);
    discountedFee = entryFee - widget.useBonus;
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
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.backspace,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Image.asset(
              ImageAssets.Add_balance,
              height: 70,
              width: 70,
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Insufficient Balance',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "You don't have sufficient balance to join this contest",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
            ),
            ListTile(
              title: Text(
                "Add ₹ ${widget.entry_Fee} to join",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCashInWallet()));
                  });
                },
                child: Text('Proceed to Add Cash',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
