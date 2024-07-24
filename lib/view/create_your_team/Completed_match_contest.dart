import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
import '../../Model/Upcoming_New_Model/Data.dart';
import '../../Model/Upcoming_New_Model/Upcoming_New_Api_Response.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Add Cash In Wallet.dart';
import '../AfterjoinContestView.dart';
import 'create_contest.dart';

class CompleteMatch_contest extends StatefulWidget {
  var  logo1,logo2,text1,text2,stats,Match_id,team1_id,team2_id;
  CompleteMatch_contest({super.key,this.logo1,this.logo2,this.text1,this.text2,this.stats,this.Match_id,this.team1_id,this.team2_id});

  @override
  State<CompleteMatch_contest> createState() => _CompleteMatch_contestState();
}

class _CompleteMatch_contestState extends State<CompleteMatch_contest> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  String? _email;
  String? _userName;
  String _token = '';
  Future<List<UpcomingMatch_Recents_Data>?>? future;
  Future<List<LiveMatch_Players_Image_Data>?>? future_data;
  Future<List<LiveScoreNewData>?>? ScorecardData;
  bool isExpanded1 = true;
  Map<int, bool> isContainerVisibleMap = {};
  bool data_Not_Found=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
    future = fetchUpcomingMatches("upcoming");
    ScorecardData=FetchScoreCardData(widget.Match_id);
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> fetchUserTeam() async {
    final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.fetchUserTeamData(widget.Match_id, _token);
    apiProvider.fetchData(widget.Match_id, _token);
  }

  Future<List<UpcomingMatch_Recents_Data>?> fetchUpcomingMatches(String type) async {
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

  Future<List<LiveScoreNewData>?> FetchScoreCardData(String match_Id) async {
    final url = Uri.parse('https://admin.googly11.in/api/match_score_card?match_id=$match_Id');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    print('Failed to load data: ${response.body}');
    if (response.statusCode == 200) {
      LiveMatchScoreCardData liveMatchScoreCard=LiveMatchScoreCardData.fromJson(json.decode(response.body));
      data_Not_Found = liveMatchScoreCard.abandon;
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
      fetchUserTeam();
    });
    future_data = Players_Data(widget.Match_id, _token, widget.team1_id.toString(), widget.team2_id.toString());
    print("email" + _email.toString());
    print("user_id" + _userName.toString());
  }

  Future<List<LiveMatch_Players_Image_Data>?> Players_Data(String match_id, String bearerToken,String team1_id,String team2_id) async {
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
          // Check the connection state of the future
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
            // Use snapshot.data to access the latest data
            LenBack_Data_For_Live? data = snapshot.data;
            print(data_Not_Found.toString()+":::::::::::rtfd");
            if(snapshot.data != null ){
              return
                Column(
                  children: [
                    Container(
                      height: size.height * 0.15 ,
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
                                      snapshot.data!.matchScoreDetails!.inningsScoreList!.isNotEmpty &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName != null &&
                                      snapshot.data!.matchScoreDetails!.inningsScoreList![0].batTeamName.toString() ==
                                          widget.text1.toString()
                                      ? MemoryImage(base64Decode(widget.logo1))
                                      : MemoryImage(base64Decode(widget.logo2)),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(
                            snapshot.data!.matchScoreDetails!.customStatus != null ? snapshot.data!.matchScoreDetails!.customStatus : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
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
                                      borderSide: BorderSide(width: 2.0, color: Colors.red), // Set the thickness and color of the underline
                                      insets: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding of the underline
                                    ),
                                    tabs:  [
                                      Tab(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('My contest',style: TextStyle(fontSize: 11),),
                                            Expanded(
                                              child: Consumer<ApiProvider>(
                                                builder: (context, apiProvider, child) {
                                                  return Text(

                                                    ' (${apiProvider.allContestCreateData != null ? apiProvider.allContestCreateData!.length : '0'})',
                                                    style: TextStyle(fontSize: 12),
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
                                    child: Container(
                                      color: Colors.grey[300],
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          Consumer<ApiProvider>(
                                            builder: (context, apiProvider, child) {
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                                                child: apiProvider.allContestCreateData != null && apiProvider.allContestCreateData!.isNotEmpty
                                                    ? ListView.builder(
                                                  itemCount: apiProvider.allContestCreateData!.length,
                                                  itemBuilder: (context, index) {
                                                    final event = apiProvider.allContestCreateData![index];
                                                    bool isEntryVisible = isContainerVisibleMap[index] ?? false;
                                                    return InkWell(
                                                      onTap : (){
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => AfterJoinContestView(
                                                                team1_Id: widget.team1_id,
                                                                team2_Id: widget.team2_id,
                                                                text1: widget.text1,
                                                                text2: widget.text2,
                                                                Match_Id: widget.Match_id,
                                                                logo1: widget.logo1,
                                                                logo2: widget.logo2,
                                                                app_charge: event?.appCharge ?? null,
                                                                entry_fee: event?.entryFee ?? null,
                                                                Number_of_user: event?.numberOfUser ?? null,
                                                                user_participant: event?.userParticipant ?? null,
                                                                Contest_Id: event?.id ?? null,
                                                                first_Prize: event?.firstPrize ?? null,
                                                                winnerCriteria: event?.winnerCriteria ?? null,
                                                                total_Teams_allow: event?.totalTeamsAllowed ?? null,
                                                              ),
                                                            )

                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(6.5),
                                                        child: Card(
                                                          elevation: 20,
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            height: !isEntryVisible ? size.height *0.27 : size.height *0.50,
                                                            width: size.width *0.95,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: Colors.white.withOpacity(0.6),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: size.height *0.01),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    CustomPaddedText(
                                                                      text: event.contestName,
                                                                      style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w300,
                                                                          color: Colors.black
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
                                                                              double newData=double.parse(event.entryFee.toString()) * double.parse(event.userParticipant.toString())-result;
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
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(height: 5,),
                                                                LinearProgressBar(
                                                                  maxSteps: event.userParticipant,
                                                                  progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                                                                  currentStep: event.numberOfUser,
                                                                  progressColor: Colors.red,
                                                                  backgroundColor: Colors.grey,
                                                                ),
                                                                SizedBox(height: size.height *0.01,),
                                                                CustomPaddedText(
                                                                  text: '${int.parse(event.userParticipant.toString())-int.parse(event.numberOfUser.toString())} spots left',
                                                                  style: TextStyle(color: Colors.red,
                                                                  ),),
                                                                Padding(
                                                                  padding: const EdgeInsets.all(5.0),
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
                                                                        InkWell(
                                                                          onTap: (){
                                                                            _showDetailsPopup(context,"First Prize = ${event.firstPrize != null ? event.firstPrize : "1000 Rs"}");
                                                                          },
                                                                          child: Padding(
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
                                                                          onTap: (){
                                                                            double result = double.parse(event.userParticipant.toString()) * double.parse(event.winnerCriteria.toString())  / 100;
                                                                            print("result"+result.toString());
                                                                            double newData=double.parse(event.userParticipant.toString())-result;
                                                                            _showDetailsPopup(context, "$newData teams win the contest");
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Image(image: AssetImage(ImageAssets.trophyy),height: 15,),
                                                                              CustomPaddedText(
                                                                                text: '${event.winnerCriteria}%',
                                                                                style:  TextStyle(
                                                                                  color: Colors.black54,
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        InkWell(
                                                                          onTap: (){
                                                                            _showDetailsPopup(context,"Max ${event.totalTeamsAllowed} entries per user in this contest");
                                                                          },
                                                                          child: Row(
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
                                                                        InkWell(
                                                                          onTap: (){
                                                                            _showDetailsPopup(context,"Guaranteed to take place regardless of spots filled");
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
                                                                                Text(" Guaranteed",style: TextStyle(
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
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      isContainerVisibleMap[index] = !isEntryVisible;
                                                                    });
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        CustomPaddedText(
                                                                          text: 'Joined with ${event.joinContestUser!.length} team',
                                                                          style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.black,
                                                                          ),
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
                                                                Visibility(
                                                                    visible: isEntryVisible,
                                                                    child:  Container(
                                                                      height: 170,
                                                                      child: ListView.builder(
                                                                        itemCount: event.joinContestUser!.length,
                                                                        itemBuilder: (context, index) {
                                                                          final event_Data =event.joinContestUser![index];
                                                                          return  Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  // Your container contents go here
                                                                                  width: double.infinity,
                                                                                  height: 100,
                                                                                  decoration: BoxDecoration(
                                                                                      border: Border.all(color: Colors.grey,width: 1.5),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      color:  Color(0xFFFFF1C9)
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
                                                                                              style: TextStyle(
                                                                                                  color: Colors.black87,
                                                                                                  fontSize: 13,
                                                                                                  fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: (){

                                                                                              },
                                                                                              child: Icon(
                                                                                                Icons.edit,
                                                                                                color: Colors.grey,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                "Captain",
                                                                                                // event.teamName,
                                                                                                style: TextStyle(
                                                                                                    color: Colors.black87,
                                                                                                    fontSize: 12,
                                                                                                    fontWeight: FontWeight.w300
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                "Vice Captain",
                                                                                                // event.teamName,
                                                                                                style: TextStyle(
                                                                                                    color: Colors.black87,
                                                                                                    fontSize: 12,
                                                                                                    fontWeight: FontWeight.w300
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                event_Data.joinContestTeam![0].captainDetails!.nickName,
                                                                                                // event.teamName,
                                                                                                style: TextStyle(
                                                                                                    color: Colors.black87,
                                                                                                    fontSize: 13,
                                                                                                    fontWeight: FontWeight.w600
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                event_Data.joinContestTeam![0].viceCaptainDetails!.nickName,
                                                                                                // event.teamName,
                                                                                                style: TextStyle(
                                                                                                    color: Colors.black87,
                                                                                                    fontSize: 13,
                                                                                                    fontWeight: FontWeight.w600
                                                                                                ),
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
                                                                        },
                                                                      ),
                                                                    )

                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                                    :Container(
                                                  color: Colors.grey[300],
                                                  height: 400.0, // Set the height to an appropriate value
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(top: 10),
                                                        child: Text(
                                                          "Join Upcoming Match",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: FutureBuilder<List<UpcomingMatch_Recents_Data>?>(
                                                          future: future,
                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return Center(
                                                                child: SpinKitFadingCircle(
                                                                  color: Color(0xff780000),
                                                                ),
                                                              );
                                                            } else if (snapshot.hasError) {
                                                              return Text('No Internet');
                                                            } else if (!snapshot.hasData || snapshot.data == null) {
                                                              return RefreshIndicator(
                                                                color: Colors.red,
                                                                backgroundColor: Colors.white,
                                                                onRefresh: () async {
                                                                  await Future.delayed(
                                                                    const Duration(seconds: 2),
                                                                  );

                                                                  setState(() {
                                                                    future = fetchUpcomingMatches("upcoming");
                                                                  });
                                                                },
                                                                child: Text('No events available'),
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
                                                                    future = fetchUpcomingMatches("upcoming");
                                                                  });
                                                                },
                                                                child: ListView.builder(
                                                                  itemCount: snapshot.data!.length,
                                                                  itemBuilder: (context, index) {
                                                                    final event = snapshot.data![index];

                                                                    DateTime currentTime = DateTime.now();
                                                                    DateTime? eventTime;
                                                                    if (event.startDate != null) {
                                                                      eventTime =
                                                                          DateTime.fromMillisecondsSinceEpoch(int.parse(event.startDate!));
                                                                    }
                                                                    Duration timeDifference = eventTime!.difference(currentTime);
                                                                    if (timeDifference.inSeconds > 0) {
                                                                      return InkWell(
                                                                        onTap: () {
                                                                          if (timeDifference.inHours <= 24) {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => CreateContest(
                                                                                  logo1: event.firstTeam?.imageData ?? '',
                                                                                  logo2: event.secondTeam?.imageData ?? '',
                                                                                  text1: event.firstTeam?.teamSName ?? '',
                                                                                  text2: event.secondTeam?.teamSName ?? '',
                                                                                  time_hours: event.startDate ?? '',
                                                                                  match_id: event.matchId.toString(),
                                                                                  team1_Id: event.team1Id.toString(),
                                                                                  team2_Id: event.team2Id.toString(),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            print("fhsjdjfk");
                                                                          }
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.all(8.0),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 3),
                                                                            child: Container(
                                                                              height: size.height * 0.125,
                                                                              //width: size.width * 0.8,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                                color: timeDifference.inHours <= 24
                                                                                    ? Colors.white
                                                                                    : Colors.grey.withOpacity(0.15),
                                                                              ),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    margin:EdgeInsets.symmetric(horizontal: 10),
                                                                                    child: Text(
                                                                                      (event.seriesName ?? '') + "," + (event.matchFormat ?? ''),
                                                                                      style: TextStyle(fontSize: 10),
                                                                                    ),
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
                                                                                                  backgroundImage: MemoryImage(
                                                                                                    base64Decode(
                                                                                                      event.firstTeam?.imageData ?? '',
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left: 5),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    event.firstTeam?.teamSName ?? '',
                                                                                                    style: TextStyle(
                                                                                                        color: Colors.black,
                                                                                                        fontWeight: FontWeight.w800,
                                                                                                        fontSize: 14),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        event.state ?? '?',
                                                                                        style: TextStyle(
                                                                                            color: Colors.green,
                                                                                            fontWeight: FontWeight.w800,
                                                                                            fontSize: 12),
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: FractionallySizedBox(
                                                                                          widthFactor: 1.0,
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(right: 10),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(right: 5),
                                                                                                  child: Center(
                                                                                                    child: Text(
                                                                                                      event.secondTeam?.teamSName ?? '',
                                                                                                      style: TextStyle(
                                                                                                          color: Colors.black,
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                          fontSize: 14),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Center(
                                                                                                  child: CircleAvatar(
                                                                                                    backgroundImage: MemoryImage(
                                                                                                      base64Decode(
                                                                                                        event.secondTeam?.imageData ?? '',
                                                                                                      ),
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
                                                                                  Center(
                                                                                    child: CountdownTimerWidget(
                                                                                      time: event.startDate ?? '454875',
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      return Center(
                                                                        child: SpinKitFadingCircle(),
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

                                          FutureBuilder<List<LiveMatch_Players_Image_Data>?>(
                                            future: future_data,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:  SpinKitFadingCircle(
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
                                                      future_data = Players_Data(widget.Match_id, _token, widget.team1_id.toString(), widget.team2_id.toString());
                                                    });
                                                  },
                                                  child: Center(
                                                      child: Text('No events available')
                                                  ),
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
                                                      future_data = Players_Data(widget.Match_id, _token, widget.team1_id.toString(), widget.team2_id.toString());
                                                    });
                                                  },
                                                  child:
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
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
                                                                  const EdgeInsets.only(
                                                                      left: 15),
                                                                  child: Text(
                                                                    "Players",
                                                                    style: TextStyle(
                                                                      color: Colors.black54,
                                                                      fontSize: 13,
                                                                      fontWeight:
                                                                      FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_upward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_downward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Selected by",
                                                                  style: TextStyle(
                                                                    color: Colors.black54,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_upward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_downward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Points",
                                                                  style: TextStyle(
                                                                    color: Colors.black54,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_upward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                                Icon(
                                                                  Icons.arrow_downward,
                                                                  color: Colors.black54,
                                                                  size: 13,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          itemCount:snapshot.data!.length ,
                                                          itemBuilder:
                                                              (BuildContext context,
                                                              int index) {
                                                            final event = snapshot.data![index];
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 8),
                                                                  child: Container(
                                                                    height: 60,
                                                                    width: double.infinity,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              CircleAvatar(
                                                                                backgroundImage:
                                                                                MemoryImage(base64Decode(event.faceImageId)),
                                                                              ),
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .only(
                                                                                    left:
                                                                                    8),
                                                                                child: Column(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment
                                                                                      .center,
                                                                                  crossAxisAlignment:
                                                                                  CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Text(
                                                                                      event.name.length > 12 ? event.name.substring(0, 12) + '...' : event.name,
                                                                                      style: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),

                                                                                    Text(
                                                                                      event.teamName,
                                                                                      style:
                                                                                      TextStyle(
                                                                                        fontSize:
                                                                                        11,
                                                                                        fontWeight:
                                                                                        FontWeight.w300,
                                                                                        color:
                                                                                        Colors.black,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Center(
                                                                                child: Padding(
                                                                                  padding:
                                                                                  const EdgeInsets
                                                                                      .all(
                                                                                      8.0),
                                                                                  child: Text(
                                                                                    "${event.byUser.toString()} %",
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontSize:
                                                                                      13,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .bold,
                                                                                      color: Colors
                                                                                          .black,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding:
                                                                                const EdgeInsets
                                                                                    .all(8.0),
                                                                                child: Text(
                                                                                  "${event.points.toString()}",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize: 13,
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .bold,
                                                                                    color: Colors
                                                                                        .black,
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
                                                                  color: Colors.grey[200],
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
                                                if(data_Not_Found == true){
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
                                                              height: 580,
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
                                                              height: 250,
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
                                                }else{
                                                  return Center(
                                                      child: Text("Match Data Not Found",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)));
                                                }

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
            }else{
              return Center(
                  child: Text("Match Data Not Found",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)));
            }

          }
        },
      ),
    );
  }
  ImageProvider<Object>? _getTeamLogoImage(String teamSName) {
    switch (teamSName) {
      case 'IND':
        return AssetImage(ImageAssets.india_flag);
      case 'RSA':
        return AssetImage(ImageAssets.rsa_flag);
      case 'AUS':
        return AssetImage(ImageAssets.aus_img);
      case 'PAK':
        return AssetImage(ImageAssets.pak_img);
      case 'WI':
        return AssetImage(ImageAssets.aus_img);
      case 'ENG':
        return AssetImage(ImageAssets.england_img);
    // Add more cases for other teams as needed
      default:
      // Return a default image or null
        return AssetImage(
          ImageAssets.win,
        );
    }
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
