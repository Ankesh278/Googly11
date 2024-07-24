import 'dart:convert';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/App_Widgets/CustomText.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import '../../ApiCallProviderClass/API_Call_Class.dart';
import '../../Model/GetLeaderBoard/Data.dart';
import '../../Model/GetLeaderBoard/GetLeaderBoardResponse.dart';
import '../../Model/LiveTeamPreviewModel/Data.dart';
import '../../Model/LiveTeamPreviewModel/LiveTeamPreviewResponse.dart';
import '../../Model/LiveTeamPreviewModel/Players.dart';
import '../../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../../Model/WinningsModel/PrizeDistributions.dart';
import '../../Model/WinningsModel/WinningsResponseModel.dart';
import '../JoinContextWithTeam.dart';
import '../LiveTeamPreview.dart';
import '../Team Preview.dart';
import 'createTeam.dart';

class MakeTeamPayMent extends StatefulWidget {
  var team1_Id, team2_Id, text1, text2, Match_Id,logo1,logo2,time_hours,
      entry_fee,app_charge,user_participant,Number_of_user,Contest_Id,lineup_out, useBonus,HeightsScore,AverageScore,
      first_Prize,winnerCriteria,total_Teams_allow;
  MakeTeamPayMent(
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
        this.total_Teams_allow,
        this.lineup_out,
        this.useBonus,
        this.AverageScore,
        this.HeightsScore
      }) : super(key: key);

  @override
  State<MakeTeamPayMent> createState() => _MakeTeamPayMentState();
}

class _MakeTeamPayMentState extends State<MakeTeamPayMent>
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
  double newData=0.0;

  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getPrefrenceData();
    double result = double.parse(widget.user_participant.toString()) * double.parse(widget.winnerCriteria.toString())  / 100;
    print("result"+result.toString());
    newData =double.parse(widget.user_participant.toString())-result;
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

  Future<List<LeaderBoardData>?> fetchData(int match_Id,int contest_ID) async {
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
    apiProvider.fetchUserTeamData(widget.Match_Id, _token);
    // apiProvider.fetchData(widget.Match_Id, _token);
  }

  Future<List<Players_>?> fetchUserTeamDataByTeamPreview(String matchId, String token,String team_id) async {
    print("match_Id::::"+matchId.toString()+"::::::::"+"::::::"+team_id);
    final url = 'https://admin.googly11.in/api/user_All_Contest_Data?match_id=$matchId&teamID=$team_id';
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
        if (contestDataResponse.status == 1) {
          allTeamUserCreateData=contestDataResponse.data;
          total_Points =allTeamUserCreateData![0].totalCreditPointsUsed.toString();
          team_Id=allTeamUserCreateData![0].teamID!;
          players_Data!.addAll(allTeamUserCreateData![0].players ?? []);
          for(int i=0;i<players_Data!.length;i++){
            player_Id.add(players_Data![i].playerDetails!.playerId.toString());

            if(players_Data![i].playerDetails!.roleType == "WICKET KEEPER"){
              Wk_points_data.add(players_Data![i].totalMatchPoints.toString());
              Wk_PlayersData.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId!, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BATSMEN"){
              Bat_points_data.add(players_Data![i].totalMatchPoints.toString());
              BatData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId!, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "ALL ROUNDER"){
              AR_points_data.add(players_Data![i].totalMatchPoints.toString());
              ARData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId!, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!,playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
            if(players_Data![i].playerDetails!.roleType == "BOWLER"){
              Bowl_points_data.add(players_Data![i].totalMatchPoints.toString());
              BowlData_Player.add(PlayersData_(playerId: players_Data![i].playerDetails!.playerId!, teamId: players_Data![i].teamID,
                imageId: players_Data![i].playerDetails!.imageId!, roleType: players_Data![i].playerDetails!.roleType,
                bat: players_Data![i].playerDetails!.name, bowl: players_Data![i].playerDetails!.name,
                name: players_Data![i].playerDetails!.name, nickName: players_Data![i].playerDetails!.nickName,
                role: players_Data![i].playerDetails!.role, intlTeam: players_Data![i].playerDetails!.intlTeam,
                image: players_Data![i].playerDetails!.image, points: players_Data![i].playerDetails!.points!,
                byuser: players_Data![i].playerDetails!.imageId!, playingTeamId: players_Data![i].playerDetails!.playingTeamId!,
                captain: players_Data![i].captain,viceCaptain: players_Data![i].viceCaptain,
                isPlay: players_Data![i].playerDetails!.isPlay,captionByuser: players_Data![i].playerDetails!.isPlay, VoiceCaptionByuser: players_Data![i].playerDetails!.isPlay,
              ));
            }
          }
          print("Data___::::::::::::"+Wk_PlayersData.length.toString());
          print("Data___::::::::::::"+BatData_Player.length.toString());
          print("Data___::::::::::::"+ARData_Player.length.toString());
          print("Data___::::::::::::"+BowlData_Player.length.toString());
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
                team2_id: widget.team2_Id,
                credits_Points:total_Points, lineup: 0,
              )
          ));
          return contestDataResponse.data![0].players;
        } else if (contestDataResponse.status == 0) {

          return contestDataResponse.data![0].players;
        }
      } else if (response.statusCode == 401) {
        // Handle 401 unauthorized
      }else if (response.statusCode == 404) {
        final contestDataResponse = LiveTeamPreviewResponse.fromJson(json.decode(response.body));
        if (contestDataResponse.status == 1) {
        } else if (contestDataResponse.status == 0) {
          Fluttertoast.showToast(msg: "No Team Preview Allow Other Players",textColor: Colors.white,backgroundColor: Colors.black);
        }
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

  @override
  Widget build(BuildContext context) {
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.text1} VS ${widget.text2}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 13.5
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
          CustomPaddedText(
            text: 'Pool Price',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          CustomPaddedText(
            text: () {
              try {
                if (widget.entry_fee != null) {
                  double result = double.parse(widget.entry_fee.toString()) * double.parse(widget.user_participant.toString()) * double.parse(widget.app_charge.toString()) / 100;
                  double newData=double.parse(widget.entry_fee.toString()) * double.parse(widget.user_participant.toString())-result;
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5,),
          LinearProgressBar(
            maxSteps: widget.user_participant,
            progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
            currentStep: widget.Number_of_user,
            progressColor: Colors.red,
            backgroundColor: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomPaddedText(
                text: '${int.parse(widget.user_participant.toString())-int.parse(widget.Number_of_user.toString())} spots left',
                style: TextStyle(color: Colors.red,
                ),),
              CustomPaddedText(
                text: '${widget.user_participant.toString()} sopts',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02,),
          Consumer<ApiProvider>(
            builder: (context, apiProvider, child) {
              return InkWell(
                onTap: () async {
                  if (apiProvider.allTeamUserCreateData != null && apiProvider.allTeamUserCreateData.length != 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinContestWithTeam(
                          logo2: widget.logo2,
                          logo1: widget.logo1,
                          text2: widget.text2,
                          text1: widget.text1,
                          time_hours: widget.time_hours,
                          match_id: widget.Match_Id,
                          team1_Id: widget.team1_Id,
                          team_2_Id: widget.team2_Id,
                          contest_id: widget.Contest_Id,
                          total_team_Limit: widget.total_Teams_allow,
                          Entry_Free: widget.entry_fee,
                          UseBonus: widget.useBonus,
                          HighestScore: widget.HeightsScore,
                          Average_Score: widget.AverageScore,
                        ),
                      ),
                    );
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
                          Match_id: widget.Match_Id,
                          team1_id: widget.team1_Id,
                          team2_id: widget.team2_Id,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 44),
                  height: 40,
                  width: size.width * .8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'join for ₹${widget.entry_fee.toString()}'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: size.height *0.05,
              width: size.width *0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color:  Color(0xFFF0F0F0),
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
                          widget.first_Prize != null ? widget.first_Prize : "1 Rs",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    showChildAboveOverlay: false,
                    timeout: Duration(seconds: 8),
                    color: Colors.blue,
                    showModal: false,
                    content: Text("First Prize = ${widget.first_Prize != null ? widget.first_Prize : "1 Rs"}",style: TextStyle(color: Colors.white,fontSize: 13),),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     _showDetailsPopup(context,);
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
                  //           ,
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
                    child: Row(
                      children: [
                        Image(image: AssetImage(ImageAssets.trophyy),height: 15,),
                        CustomPaddedText(
                          text: '${widget.winnerCriteria}%',
                          style:  TextStyle(
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
                    timeout: Duration(seconds: 8),
                    content: Text("$newData teams win the contest",style: TextStyle(color: Colors.white,fontSize: 13),),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //
                  //     _showDetailsPopup(context, );
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Image(image: AssetImage(ImageAssets.trophyy),height: 15,),
                  //       CustomPaddedText(
                  //         text: ,
                  //         style:  TextStyle(
                  //           color: Colors.black54,
                  //           fontSize: 13,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  ElTooltip(
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_sharp,
                          color: Colors.black54,
                          size: 15,
                        ),
                        Text(
                          " Upto ${widget.total_Teams_allow.toString()}",
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
                    timeout: Duration(seconds: 8),
                    content: Text("Max ${widget.total_Teams_allow} entries per user in this contest",style: TextStyle(color: Colors.white,fontSize: 13),),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //     _showDetailsPopup(context,);
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.bookmark_sharp,
                  //         color: Colors.black54,
                  //         size: 13,
                  //       ),
                  //       Text(,style: TextStyle(
                  //         color: Colors.black54,
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
          Container(
            width: double.infinity,
            height: size.height * 0.05,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.10),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomPaddedText(
                      text: 'Earn'.tr,
                      style: TextStyle(
                          color: Color(0xff780000), fontWeight: FontWeight.bold)),
                  Icon(
                    Icons.currency_bitcoin,
                    color: Colors.yellowAccent,
                  ),
                  Text(
                    '1 for every'.tr,
                    style: TextStyle(
                        color: Color(0xff780000), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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
                        ], // Replace with your gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the border radius as needed
                    ),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Tab(text: 'Leaderboards'.tr),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Tab(text: 'Winnigs'.tr,),
                      ),
                    ],
                  ),
                ),

                Expanded(
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Rank'.tr),
                                  Text('Teams'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<LeaderBoardData>?>(
                                future: contest_Data,
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
                                          contest_Data = fetchData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
                                        });
                                      },
                                      child: Center(child: Text('No Details available. Please Join a Contest')),
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
                                          contest_Data = fetchData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
                                        });
                                      },
                                      child: _isLoading ? Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ))
                                          :  Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: ListView.separated(
                                          itemCount: snapshot.data!.length,
                                          separatorBuilder: (context, index) => Divider(
                                            color: Colors.grey,
                                            height: 0.5,
                                          ),
                                          itemBuilder: (context, index) {
                                            final event = snapshot.data![index];

                                            return InkWell(
                                              onTap: (){
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
                                                Wk_points_data=[];
                                                AR_points_data=[];
                                                Bat_points_data=[];
                                                Bowl_points_data=[];
                                                fetchUserTeamDataByTeamPreview(widget.Match_Id, _token, event.teamID.toString()).then((value) {
                                                  setState(() {
                                                    _isLoading = false; // Set loading to false after data is fetched
                                                  });
                                                });
                                              },
                                              child: Container(
                                                height: 60,
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                      Text(
                                                        event.rank.toString(),
                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                      ),
                                                      if(event.winningZone == 1)
                                                      Text(
                                                       "In winning zone",
                                                        style: TextStyle(
                                                            fontSize: 11, fontWeight: FontWeight.bold,color: Colors.green
                                                        ),
                                                      ),
                                                    ],
                                                    ),

                                                    Text(
                                                        event.userName.toString(),
                                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Rank'.tr),
                                  Text('Prizes'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: FutureBuilder<List<PrizeDistributions>?>(
                                future: winningsData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child:  SpinKitFadingCircle(
                                        color: Color(0xff780000),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('No Internet ' + snapshot.error.toString());
                                  } else if (!snapshot.hasData) {
                                    return RefreshIndicator(
                                      color: Colors.red,
                                      backgroundColor: Colors.white,
                                      onRefresh: () async {
                                        await Future.delayed(
                                          const Duration(seconds: 2),
                                        );
                                        setState(() {
                                          winningsData =  fetchWinnersData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
                                        });
                                      },
                                      child: Center(child: Text('No Details available. Please Join a Contest')),
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
                                          winningsData =  fetchWinnersData(int.parse(widget.Match_Id.toString()), int.parse(widget.Contest_Id.toString()));
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: ListView.separated(
                                          itemCount: snapshot.data!.length,
                                          separatorBuilder: (context, index) => Divider(
                                            color: Colors.grey,
                                            height: 0.5,
                                          ),
                                          itemBuilder: (context, index) {
                                            final event = snapshot.data![index];

                                            return Container(
                                              height: 45,
                                              color: Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 12),
                                                    child: Text(
                                                        '${event.rankFrom.toString() == event.rankUpto.toString() ? event.rankFrom.toString() : event.rankFrom.toString() +" - ${event.rankUpto.toString()}"}'
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(right: 12),
                                                    child: Text('${event.prizeAmount}'),
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
