import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../App_Widgets/mini_container.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import '../Model/PlayersTeamCreationResponse/Player_TeamCreate_Response.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
import 'CopyTeamSave.dart';
import 'InLineupPopup.dart';
// import 'Save_Team.dart';
import 'Team Preview.dart';
// import 'UpdateSaveTeam.dart';

class CopyYourTeam extends StatefulWidget {
  var  logo1,logo2,text1,text2 , time_hours,Match_id,team1_id,team2_id,captain_id,vice_captain_Id ,total_Points,selected_Captain_Name,selected_Vice_Captain_Name, HighestScore , Average_Score;
  int team_Id;
  final List<PlayersData_>? teamDataAll;
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];
  CopyYourTeam({Key? key,this.logo1,this.logo2,this.text1,this.text2,this.time_hours,this.Match_id,this.team1_id,this.team2_id,this.teamDataAll,
    this.captain_id,this.vice_captain_Id,required this.Wk_PlayersData,required this.BowlData_Player,required this.ARData_Player,required this.BatData_Player,
    this.total_Points,required this.team_Id,this.selected_Captain_Name,this.selected_Vice_Captain_Name,this.HighestScore,this.Average_Score
  }) : super(key: key);

  @override
  State<CopyYourTeam> createState() => CopyYourTeamState();
}

class CopyYourTeamState extends State<CopyYourTeam>with SingleTickerProviderStateMixin  {
  late TabController tabController;
  List<PlayersData_> selectedPlayers = []; // List to keep track of selected players
  bool isPlusButtonVisible = true;
  bool isMinusButtonVisible = false;
  final Map<String, dynamic> points = {
    'point1': {'x': 10, 'y': 20},
    'point2': {'x': 30, 'y': 40},
    'point3': {'x': 50, 'y': 60},
    // Add more points as needed
  };
   SpinKitFadingCircle indicator =   SpinKitFadingCircle(
     color: Colors.redAccent,
     size: 50.0,
   );

  List<bool> isMinusButtonVisibleList = List.generate(40, (index) => false);
  List<bool> isPlusButtonVisibleList = List.generate(40, (index) => true);
  List<bool> isMinusButtonforBat = List.generate(40, (index) => false);
  List<bool> isPlusButtonforBat = List.generate(40, (index) => true);
  List<bool> isMinusButtonAr = List.generate(40, (index) => false);
  List<bool> isPlusButtonAr = List.generate(40, (index) => true);
  List<bool> isMinusButtonbowl = List.generate(40, (index) => false);
  List<bool> isPlusButtonbowl = List.generate(40, (index) => true);

  List<PlayersData_> selectedPlayerWk = [];
  List<PlayersData_> selectedPlayerBat = [];
  List<PlayersData_> selectedPlayerAR = [];
  List<PlayersData_> selectedPlayerBowl = [];
  int maxPlayerLimit = 11;
  Future<List<PlayersData_>?>? Player_Data;
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];
  double totalCredits = 0;
  String _token='';
  PlayerTeamCreateResponse_ upcomingMatch=PlayerTeamCreateResponse_();

// Define a variable to keep track of the selected players count
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getPrefrenceData();
    selectedPlayers=widget.teamDataAll!;
    selectedPlayerWk=widget.Wk_PlayersData;
    selectedPlayerBat=widget.BatData_Player;
    selectedPlayerAR=widget.ARData_Player;
    selectedPlayerBowl=widget.BowlData_Player;
    totalCredits=double.parse(widget.total_Points);
  }

  void removeUnannouncedPlayersAndAdjustCredits(List<PlayersData_> unannouncedPlayers) {
    setState(() {
      // Remove unannounced players from selected players lists
     // List<String> unannouncedPlayerIds  = unannouncedPlayers.map((player) => player.playerId.toString()).toList();
      selectedPlayerWk.removeWhere((player) => unannouncedPlayers.map((p) => p.playerId).contains(player.playerId));
      selectedPlayerBat.removeWhere((player) => unannouncedPlayers.map((p) => p.playerId).contains(player.playerId));
      selectedPlayerAR.removeWhere((player) => unannouncedPlayers.map((p) => p.playerId).contains(player.playerId));
      selectedPlayerBowl.removeWhere((player) => unannouncedPlayers.map((p) => p.playerId).contains(player.playerId));
      selectedPlayers.removeWhere((player) => unannouncedPlayers.map((p) => p.playerId).contains(player.playerId));
      // selectedPlayers.removeWhere((playerId) => unannouncedPlayerIds.contains(playerId));
      print("Selected Players: $selectedPlayers");
      // Update total credits
      totalCredits += unannouncedPlayers.fold(0, (previousValue, player) => previousValue + player.points);
    });
  }


  bool isNextButtonEnabled() {
    return selectedPlayers.length == 11;
  }
  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;
      Player_Data=fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);
      print("team_Name:::"+widget.text1+widget.team1_id+":::::"+widget.text2+widget.team2_id);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  void clearSelectedPlayers() {
    setState(() {
      selectedPlayerBowl.clear();
      selectedPlayerAR.clear();
      selectedPlayerBat.clear();
      selectedPlayerWk.clear();
      selectedPlayers.clear();
      print("selected players length:::::::"+selectedPlayers.length.toString());
      isPlusButtonVisibleList = List.generate(40, (index) => true);
      isMinusButtonVisibleList = List.generate(40, (index) => false);
      isPlusButtonforBat = List.generate(40, (index) => true);
      isMinusButtonforBat = List.generate(40, (index) => false);
      isPlusButtonAr = List.generate(40, (index) => true);
      isMinusButtonAr = List.generate(40, (index) => false);
      isPlusButtonbowl = List.generate(40, (index) => true);
      isMinusButtonbowl = List.generate(40, (index) => false);
    });
  }

  Future<List<PlayersData_>?> fetchUpcomingMatches(String team1_Id,String team2_Id,String token) async {
    final String apiUrl =
        'https://admin.googly11.in/api/get-upcoming-match-team-player?team_id_1=$team1_Id&team_id_2=$team2_Id&match_id=${int.parse(widget.Match_id.toString())}';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Data::::::::" + response.toString());
      print("Dataaaa::::::::" + response.body);
      if (response.statusCode == 200) {
        upcomingMatch = PlayerTeamCreateResponse_.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 1) {
          if(upcomingMatch.playersData != null && upcomingMatch.playersData != ""){
            for (int i = 0; i < upcomingMatch.playersData!.length; i++) {
              if (upcomingMatch.playersData![i].roleType == "WICKET KEEPER") {
                Wk_PlayersData.add(upcomingMatch.playersData![i]);
                print('Wicket Keeper Added: ${upcomingMatch.playersData![i].isPlay}');
              }
              if (upcomingMatch.playersData![i].roleType == "BATSMEN") {
                BatData_Player.add(upcomingMatch.playersData![i]);
                print('Batsmen Added: ${upcomingMatch.playersData![i].isPlay}');
              }
              if (upcomingMatch.playersData![i].roleType == "ALL ROUNDER") {
                ARData_Player.add(upcomingMatch.playersData![i]);
                print('All Rounder Added: ${upcomingMatch.playersData![i].isPlay}');
              }
              if (upcomingMatch.playersData![i].roleType == "BOWLER") {
                BowlData_Player.add(upcomingMatch.playersData![i]);
                print('Bowler Added: ${upcomingMatch.playersData![i].isPlay}');
              }
            }

            // if (upcomingMatch.lineup == 1) {
            // SchedulerBinding.instance.addPostFrameCallback((_) {
            //   print("Upcoming:::::::" + upcomingMatch.lineup.toString());
            //   if (upcomingMatch.lineup == 1) {
            //     List<PlayersData_> Wk_not_InLineup = widget.Wk_PlayersData
            //         .where((player) => player.isPlay == 0)
            //         .toList();
            //
            //     List<PlayersData_> Bat_not_InLineup = widget.BatData_Player
            //         .where((player) => player.isPlay == 0)
            //         .toList();
            //
            //     List<PlayersData_> Ar_not_InLineup = widget.ARData_Player
            //         .where((player) => player.isPlay == 0)
            //         .toList();
            //
            //     List<PlayersData_> Bowl_in_Lineup = widget.BowlData_Player
            //         .where((player) => player.isPlay == 0)
            //         .toList();
            //
            //     bool hasUnannouncedPlayers =
            //         Wk_not_InLineup.isNotEmpty ||
            //             Bat_not_InLineup.isNotEmpty ||
            //             Ar_not_InLineup.isNotEmpty ||
            //             Bowl_in_Lineup.isNotEmpty;
            //
            //     print("Dataa:::::::" +
            //         Wk_not_InLineup.length.toString() +
            //         "::::" +
            //         Bat_not_InLineup.length.toString() +
            //         ":::::::" +
            //         Ar_not_InLineup.length.toString() +
            //         ":::::::" +
            //         Bowl_in_Lineup.length.toString());
            //
            //     // Show the bottom sheet dialog only if there are unannounced players
            //     if (hasUnannouncedPlayers) {
            //       showBottomSheetDialog(
            //           Wk_not_InLineup, Ar_not_InLineup, Bat_not_InLineup, Bowl_in_Lineup);
            //     }
            //   }
            // });


            // }
            return upcomingMatch.playersData;
          }else{
            print("No Data::::");
          }
          return upcomingMatch.playersData;
        }
        return upcomingMatch.playersData;
      } else if (response.statusCode == 400) {
        PlayerTeamCreateResponse_ upcomingMatch =
        PlayerTeamCreateResponse_.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          return upcomingMatch.playersData;
        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}'
        );
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do you want to discard the team?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Discard Team"),
                  onPressed: () {
                    selectedPlayerBowl.clear();
                    selectedPlayerAR.clear();
                    selectedPlayerBat.clear();
                    selectedPlayerWk.clear();
                    selectedPlayers.clear();
                    totalCredits=0;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // To close the dialog and then the page
                  },
                ),
              ],
            );
          },
        );
        return await completer.future;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff780000),
          title: Column(
            children: [
              Text(
                '${widget.text1 != null ? widget.text1 : "No Data"} vs ${widget.text2 != null ? widget.text2 : "No Data"}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              CountdownTimerWidget( time: widget.time_hours),

            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("Do you want to discard the team?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Discard Team"),
                        onPressed: () {
                          selectedPlayerBowl.clear();
                          selectedPlayerAR.clear();
                          selectedPlayerBat.clear();
                          selectedPlayerWk.clear();
                          selectedPlayers.clear();
                          totalCredits=0;
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              height: size.height *0.2,
              width: double.infinity,
              color: Color(0xff780000),
              child: Column(
                children: [
                  Text('Max Seven'.tr,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.logo1 != null
                            ? MemoryImage(base64Decode(widget.logo1))
                            : AssetImage(ImageAssets.user) as ImageProvider<Object>,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 22),
                        child:  Text(
                          '${widget.text1 != null ? widget.text1 : "No Data"}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text( 'V/S',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child:  Text(
                          '${widget.text2 != null ? widget.text2 : "No Data"}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: widget.logo1 != null
                            ? MemoryImage(base64Decode(widget.logo2))
                            : AssetImage(ImageAssets.user) as ImageProvider<Object>,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height *0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Text(
                            'Players(${selectedPlayers.length})', style: TextStyle(color: Colors.white)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Text( "Credits left: $totalCredits",style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height *0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: size.width * 0.03),
                      for (int i = 0; i < 11; i++) ...[
                        MiniContainer(
                          filled: i < selectedPlayers.length, // Check if the MiniContainer should be filled
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.only(left : 20),
                        child: GestureDetector(
                          onTap: () {
                            clearSelectedPlayers();
                          },
                          child: Image(
                            image: AssetImage(ImageAssets.minusbutton),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              labelColor: Color(0xff780000),
              indicatorColor: Color(0xff780000),
              controller: tabController,
              unselectedLabelColor : Colors.grey,
              tabs: [
                Tab(text: 'WK(${selectedPlayerWk.length})'),
                Tab(text: 'BAT(${selectedPlayerBat.length})'),
                Tab(text: 'AR(${selectedPlayerAR.length})'),
                Tab(text: 'BOWL(${selectedPlayerBowl.length})'),
              ],
            ),
            Flexible(
              child: TabBarView(
                  controller: tabController,
                  children: [
                    FutureBuilder<List<PlayersData_>?>(
                      future: Player_Data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                              onRefresh: ()
                              async {
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                setState(() {
                                  Player_Data = fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);
                                });
                              },
                              child: Center(
                                  child: Text('No Players Data available'+snapshot.hasData.toString())
                              )
                          );
                        } else {
                          return ListView.builder(
                            itemCount: Wk_PlayersData.length, // Replace with the number of items you have
                            itemBuilder: (BuildContext context, int index) {
                              Wk_PlayersData.sort((a, b) => a.nickName.compareTo(b.nickName));
                              final event = Wk_PlayersData[index];
                              PlayersData_ playerData = PlayersData_(
                                  bat: event.bat,
                                  playerId: event.playerId,
                                  teamId: event.teamId,
                                  imageId: event.imageId,
                                  roleType: event.roleType,
                                  bowl: event.bowl,
                                  name: event.name,
                                  nickName: event.nickName,
                                  role: event.role,
                                  intlTeam: event.intlTeam,
                                  image: event.image,
                                  points: event.points,
                                  byuser: event.byuser,
                                  playingTeamId: event.playingTeamId,
                                  isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              );

                              bool isPlayerMatchCondition = widget.Wk_PlayersData.any((player) => player.playerId == event.playerId);
                              print("team_Name"+widget.text1+widget.team1_id+":::::"+event.playingTeamId.toString()+"::::::");
                              // print("data::::::::::::::::::3454::::"+Not_in_Lineup.length.toString());
                              bool isPlayerSelected = selectedPlayers.contains(playerData);
                              return Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(event.image)
                                              ),
                                            ),
                                            Container(
                                              height: 15,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: event.playingTeamId != null
                                                    ? widget.team1_id == event.playingTeamId.toString()
                                                    ? Colors.black // Set color for team1_id match
                                                    : Colors.white // Set color for other team
                                                    : Colors.amberAccent, // Default color if playing_team_id is null
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  event.playingTeamId != null
                                                      ? widget.team1_id == event.playingTeamId.toString()
                                                      ? "${widget.text1}"
                                                      : "${widget.text2}"
                                                      : "NA",
                                                  style: TextStyle(
                                                    color: event.playingTeamId != null
                                                        ? widget.team1_id == event.playingTeamId.toString()
                                                        ? Colors.white // Set text color for team1_id match
                                                        : Colors.black // Set text color for other team
                                                        : Colors.amberAccent, // Default text color if playing_team_id is null
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.nickName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Sel by ${event.byuser}%",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 0)
                                              Text(
                                                event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                                                ),
                                              ),

                                            if(event.isPlay==1 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                                                  Text(
                                                    "In Lineup",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                                                  Text(
                                                    "Not Playing",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            event.points.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: isPlayerMatchCondition
                                                ? IconButton(
                                              icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the player from the selectedPlayers list
                                                  print("index"+index.toString());
                                                  // if (index >= 0 && index < selectedPlayerWk.length) {
                                                  totalCredits += event.points;
                                                  selectedPlayers.removeWhere((playerId) => playerId.playerId == playerData.playerId);
                                                  selectedPlayerWk.removeWhere((player) => player.playerId == playerData.playerId);
                                                  print("selected players lengt:::::::Data"+selectedPlayers.length.toString());
                                                  print("selected players length:::::::"+selectedPlayerWk.length.toString());
                                                  isPlayerSelected = false;
                                                  isMinusButtonVisibleList[index] = false;
                                                  isPlusButtonVisibleList[index] = true;
                                                  // }
                                                });
                                              },
                                            )
                                                : isPlayerSelected
                                                ? Container() // If player is selected, show nothing
                                                :IconButton(
                                              icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedPlayers.length >= maxPlayerLimit) {
                                                    Future.delayed(Duration(seconds: 10), () {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('You have reached the maximum player limit of $maxPlayerLimit.'),
                                                      ));
                                                    });

                                                  }
                                                  else if(selectedPlayers.length==10){
                                                    if(selectedPlayerAR.length == 0){
                                                      Future.delayed(Duration(seconds: 10), () {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 All Rounder.'),
                                                        ));
                                                      });


                                                    } else if(selectedPlayerBowl.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Baller.'),
                                                      ));
                                                    }
                                                    else if(selectedPlayerBat.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Batsman.'),
                                                      ));
                                                    }else{
                                                      if (totalCredits >= event.points) {
                                                        // Decrease total credits by the points of the added player
                                                        totalCredits -= event.points;

                                                        selectedPlayers.add(playerData);
                                                        selectedPlayerWk.add(playerData);
                                                        isPlayerSelected = true;
                                                        print("selected players length:::::::"+selectedPlayers.length.toString());
                                                        isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                                                        isPlusButtonVisibleList[index] = false; // Hide the plus button
                                                      } else {
                                                        // Handle insufficient credits scenario
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Center(child: Text('Insufficient credits')),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else if(!isPlayerSelected){
                                                    if (totalCredits >= event.points) {
                                                      // Decrease total credits by the points of the added player
                                                      totalCredits -= event.points;

                                                      selectedPlayers.add(playerData);
                                                      selectedPlayerWk.add(playerData);
                                                      isPlayerSelected = true;
                                                      print("selected players length:::::::"+selectedPlayers.length.toString());
                                                      isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                                                      isPlusButtonVisibleList[index] = false; // Hide the plus button
                                                    } else {
                                                      // Handle insufficient credits scenario
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Center(child: Text('Insufficient credits')),
                                                        ),
                                                      );
                                                    }

                                                  }
                                                });
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        }
                      },
                    ),
                    FutureBuilder<List<PlayersData_>?>(
                      future: Player_Data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                              onRefresh: ()
                              async {
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                setState(() {
                                  Player_Data = fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);
                                });
                              },
                              child: Center(
                                  child: Text('No Players Data available'+snapshot.hasData.toString())
                              )
                          );
                        } else {
                          return ListView.builder(
                            itemCount: BatData_Player.length, // Replace with the number of items you have
                            itemBuilder: (BuildContext context, int index) {
                              BatData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                              final event = BatData_Player[index];
                              PlayersData_ playerData = PlayersData_(
                                  bat: event.bat,
                                  playerId: event.playerId,
                                  teamId: event.teamId,
                                  imageId: event.imageId,
                                  roleType: event.roleType,
                                  bowl: event.bowl,
                                  name: event.name,
                                  nickName: event.nickName,
                                  role: event.role,
                                  intlTeam: event.intlTeam,
                                  image: event.image,
                                  points: event.points,
                                  byuser: event.byuser,
                                  playingTeamId: event.playingTeamId,
                                  isPlay: event.isPlay,captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              );

                              bool isPlayerMatchCondition = widget.BatData_Player.any((player) => player.playerId == event.playerId);

                              bool isPlayerSelected = selectedPlayers.contains(playerData);

                              return Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(event.image)
                                              ),
                                            ),
                                            Container(
                                              height: 15,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: event.playingTeamId != null
                                                    ? widget.team1_id == event.playingTeamId.toString()
                                                    ? Colors.black // Set color for team1_id match
                                                    : Colors.white // Set color for other team
                                                    : Colors.amberAccent, // Default color if playing_team_id is null
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  event.playingTeamId != null
                                                      ? widget.team1_id == event.playingTeamId.toString()
                                                      ? "${widget.text1}"
                                                      : "${widget.text2}"
                                                      : "NA",
                                                  style: TextStyle(
                                                    color: event.playingTeamId != null
                                                        ? widget.team1_id == event.playingTeamId.toString()
                                                        ? Colors.white // Set text color for team1_id match
                                                        : Colors.black // Set text color for other team
                                                        : Colors.amberAccent, // Default text color if playing_team_id is null
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.nickName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Sel by ${event.byuser}%",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 0)
                                              Text(
                                                event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                                                ),
                                              ),

                                            if(event.isPlay==1 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                                                  Text(
                                                    "In Lineup",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                                                  Text(
                                                    "Not Playing",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            event.points.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: isPlayerMatchCondition
                                                ? IconButton(
                                              icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  print("index"+index.toString());
                                                  totalCredits += event.points;
                                                  selectedPlayers.removeWhere((playerId) => playerId.playerId == playerData.playerId);
                                                  selectedPlayerBat.removeWhere((player) => player.playerId == playerData.playerId);
                                                  print("selected players lengt:::::::Data"+selectedPlayers.length.toString());
                                                  print("selected players length:::::::"+selectedPlayerBat.length.toString());
                                                  isPlayerSelected = false;
                                                  isMinusButtonforBat[index] = false;
                                                  isPlusButtonforBat[index] = true;
                                                });
                                              },
                                            )
                                                : isPlayerSelected
                                                ? Container() // If player is selected, show nothing
                                                :IconButton(
                                              icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedPlayers.length >= maxPlayerLimit) {
                                                    Future.delayed(Duration(seconds: 10), () {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('You have reached the maximum player limit of $maxPlayerLimit.'),
                                                      ));
                                                    });

                                                  }
                                                  else if(selectedPlayers.length==10){
                                                    if(selectedPlayerAR.length == 0){
                                                      Future.delayed(Duration(seconds: 10), () {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 All Rounder.'),
                                                        ));
                                                      });


                                                    } else if(selectedPlayerBowl.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Baller.'),
                                                      ));
                                                    }
                                                    else if(selectedPlayerWk.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Wicket keeper.'),
                                                      ));
                                                    }else{
                                                      if (totalCredits >= event.points) {
                                                        // Decrease total credits by the points of the added player
                                                        totalCredits -= event.points;

                                                        selectedPlayers.add(playerData);
                                                        selectedPlayerBat.add(playerData);
                                                        isPlayerSelected = true;
                                                        print("selected players length:::::::"+selectedPlayers.length.toString());
                                                        isMinusButtonforBat[index] = true; // Show the minus button for this item
                                                        isPlusButtonforBat[index] = false; // Hide the plus button
                                                      } else {
                                                        // Handle insufficient credits scenario
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Center(child: Text('Insufficient credits')),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else if(!isPlayerSelected){
                                                    if (totalCredits >= event.points) {
                                                      // Decrease total credits by the points of the added player
                                                      totalCredits -= event.points;
                                                      selectedPlayers.add(playerData);
                                                      selectedPlayerBat.add(playerData);
                                                      isPlayerSelected = true;
                                                      print("selected players length:::::::"+selectedPlayers.length.toString());
                                                      isMinusButtonforBat[index] = true; // Show the minus button for this item
                                                      isPlusButtonforBat[index] = false; // Hide the plus button
                                                    } else {
                                                      // Handle insufficient credits scenario
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Insufficient credits'),
                                                      ));
                                                    }

                                                  }
                                                });
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        }
                      },
                    ),
                    FutureBuilder<List<PlayersData_>?>(
                      future: Player_Data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                              onRefresh: ()
                              async {
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                setState(() {
                                  Player_Data = fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);
                                });
                              },
                              child: Center(
                                  child: Text('No Players Data available'+snapshot.hasData.toString())
                              )
                          );
                        } else {
                          return ListView.builder(
                            itemCount: ARData_Player.length, // Replace with the number of items you have
                            itemBuilder: (BuildContext context, int index) {
                              ARData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                              final event = ARData_Player[index];
                              PlayersData_ playerData = PlayersData_(
                                  bat: event.bat,
                                  playerId: event.playerId,
                                  teamId: event.teamId,
                                  imageId: event.imageId,
                                  roleType: event.roleType,
                                  bowl: event.bowl,
                                  name: event.name,
                                  nickName: event.nickName,
                                  role: event.role,
                                  intlTeam: event.intlTeam,
                                  image: event.image,
                                  points: event.points,
                                  byuser: event.byuser,
                                  playingTeamId: event.playingTeamId,
                                  isPlay: event.isPlay,captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              );

                              bool isPlayerMatchCondition = widget.ARData_Player.any((player) => player.playerId == event.playerId);

                              bool isPlayerSelected = selectedPlayers.contains(playerData);

                              return Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(event.image)
                                              ),
                                            ),
                                            Container(
                                              height: 15,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: event.playingTeamId != null
                                                    ? widget.team1_id == event.playingTeamId.toString()
                                                    ? Colors.black // Set color for team1_id match
                                                    : Colors.white // Set color for other team
                                                    : Colors.amberAccent, // Default color if playing_team_id is null
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  event.playingTeamId != null
                                                      ? widget.team1_id == event.playingTeamId.toString()
                                                      ? "${widget.text1}"
                                                      : "${widget.text2}"
                                                      : "NA",
                                                  style: TextStyle(
                                                    color: event.playingTeamId != null
                                                        ? widget.team1_id == event.playingTeamId.toString()
                                                        ? Colors.white // Set text color for team1_id match
                                                        : Colors.black // Set text color for other team
                                                        : Colors.amberAccent, // Default text color if playing_team_id is null
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.nickName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Sel by ${event.byuser}%",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 0)
                                              Text(
                                                event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                                                ),
                                              ),

                                            if(event.isPlay==1 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                                                  Text(
                                                    "In Lineup",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                                                  Text(
                                                    "Not Playing",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            event.points.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: isPlayerMatchCondition
                                                ? IconButton(
                                              icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the player from the selectedPlayers list
                                                  print("index"+index.toString());
                                                  // if (index >= 0 && index < selectedPlayerAR.length) {
                                                  totalCredits += event.points;
                                                  selectedPlayers.removeWhere((playerId) => playerId.playerId == playerData.playerId);
                                                  selectedPlayerAR.removeWhere((player) => player.playerId == playerData.playerId);
                                                  print("selected players lengt:::::::Data"+selectedPlayers.length.toString());
                                                  print("selected players length:::::::"+selectedPlayerBat.length.toString());
                                                  isPlayerSelected = false;
                                                  isMinusButtonAr[index] = false;
                                                  isPlusButtonAr[index] = true;
                                                  // }
                                                });
                                              },
                                            )
                                                : isPlayerSelected
                                                ? Container() // If player is selected, show nothing
                                                :IconButton(
                                              icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedPlayers.length >= maxPlayerLimit) {
                                                    Future.delayed(Duration(seconds: 10), () {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('You have reached the maximum player limit of $maxPlayerLimit.'),
                                                      ));
                                                    });

                                                  }
                                                  else if(selectedPlayers.length==10){
                                                    if(selectedPlayerBat.length == 0){
                                                      Future.delayed(Duration(seconds: 10), () {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 Batter.'),
                                                        ));
                                                      });


                                                    } else if(selectedPlayerBowl.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Baller.'),
                                                      ));
                                                    }
                                                    else if(selectedPlayerWk.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Wicket keeper.'),
                                                      ));
                                                    }else{
                                                      if (totalCredits >= event.points) {
                                                        // Decrease total credits by the points of the added player
                                                        totalCredits -= event.points;

                                                        selectedPlayers.add(playerData);
                                                        selectedPlayerAR.add(playerData);
                                                        isPlayerSelected = true;
                                                        print("selected players length:::::::"+selectedPlayers.length.toString());
                                                        isMinusButtonAr[index] = true; // Show the minus button for this item
                                                        isPlusButtonAr[index] = false; // Hide the plus button
                                                      } else {
                                                        // Handle insufficient credits scenario
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Center(child: Text('Insufficient credits')),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else if(!isPlayerSelected){
                                                    if (totalCredits >= event.points) {
                                                      // Decrease total credits by the points of the added player
                                                      totalCredits -= event.points;

                                                      selectedPlayers.add(playerData);
                                                      selectedPlayerAR.add(playerData);
                                                      isPlayerSelected = true;
                                                      print("selected players length:::::::"+selectedPlayers.length.toString());
                                                      isMinusButtonAr[index] = true; // Show the minus button for this item
                                                      isPlusButtonAr[index] = false; // Hide the plus button
                                                    } else {
                                                      // Handle insufficient credits scenario
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Center(child: Text('Insufficient credits')),
                                                        ),
                                                      );
                                                    }

                                                  }
                                                });
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        }
                      },
                    ),
                    FutureBuilder<List<PlayersData_>?>(
                      future: Player_Data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                              onRefresh: ()
                              async {
                                await Future.delayed(
                                  const Duration(seconds: 2),
                                );
                                setState(() {
                                  Player_Data = fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);
                                });
                              },
                              child: Center(
                                  child: Text('No Players Data available'+snapshot.hasData.toString())
                              )
                          );
                        } else {
                          return ListView.builder(
                            itemCount: BowlData_Player.length, // Replace with the number of items you have
                            itemBuilder: (BuildContext context, int index) {
                              BowlData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                              final event = BowlData_Player[index];
                              PlayersData_ playerData = PlayersData_(
                                  bat: event.bat,
                                  playerId: event.playerId,
                                  teamId: event.teamId,
                                  imageId: event.imageId,
                                  roleType: event.roleType,
                                  bowl: event.bowl,
                                  name: event.name,
                                  nickName: event.nickName,
                                  role: event.role,
                                  intlTeam: event.intlTeam,
                                  image: event.image,
                                  points: event.points,
                                  byuser: event.byuser,
                                  playingTeamId: event.playingTeamId,
                                  isPlay: event.isPlay,captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              );

                              bool isPlayerMatchCondition = widget.BowlData_Player.any((player) => player.playerId == event.playerId);

                              bool isPlayerSelected = selectedPlayers.contains(playerData);

                              return Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                  ),
                                  child: Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                  radius: 25,
                                                  backgroundImage: NetworkImage(event.image)
                                              ),
                                            ),
                                            Container(
                                              height: 15,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                color: event.playingTeamId != null
                                                    ? widget.team1_id == event.playingTeamId.toString()
                                                    ? Colors.black // Set color for team1_id match
                                                    : Colors.white // Set color for other team
                                                    : Colors.amberAccent, // Default color if playing_team_id is null
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  event.playingTeamId != null
                                                      ? widget.team1_id == event.playingTeamId.toString()
                                                      ? "${widget.text1}"
                                                      : "${widget.text2}"
                                                      : "NA",
                                                  style: TextStyle(
                                                    color: event.playingTeamId != null
                                                        ? widget.team1_id == event.playingTeamId.toString()
                                                        ? Colors.white // Set text color for team1_id match
                                                        : Colors.black // Set text color for other team
                                                        : Colors.amberAccent, // Default text color if playing_team_id is null
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              event.nickName,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Sel by ${event.byuser}%",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 0)
                                              Text(
                                                event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                                                ),
                                              ),

                                            if(event.isPlay==1 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                                                  Text(
                                                    "In Lineup",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if(event.isPlay==0 && upcomingMatch.lineup == 1)
                                              Row(
                                                children: [
                                                  Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                                                  Text(
                                                    "Not Playing",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Center(
                                          child: Text(
                                            event.points.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: isPlayerMatchCondition
                                                ? IconButton(
                                              icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the player from the selectedPlayers list
                                                  print("index"+index.toString());
                                                  // if (index >= 0 && index < selectedPlayerBowl.length) {
                                                  totalCredits += event.points;
                                                  selectedPlayers.removeWhere((playerId) => playerId.playerId == playerData.playerId);
                                                  selectedPlayerBowl.removeWhere((player) => player.playerId == playerData.playerId);
                                                  print("selected players lengt:::::::Data"+selectedPlayers.length.toString());
                                                  print("selected players length:::::::"+selectedPlayerBowl.length.toString());
                                                  isPlayerSelected = false;
                                                  isMinusButtonAr[index] = false;
                                                  isPlusButtonAr[index] = true;
                                                  // }
                                                });
                                              },
                                            )
                                                : isPlayerSelected
                                                ? Container() // If player is selected, show nothing
                                                :IconButton(
                                              icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedPlayers.length >= maxPlayerLimit) {
                                                    Future.delayed(Duration(seconds: 10), () {
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('You have reached the maximum player limit of $maxPlayerLimit.'),
                                                      ));
                                                    });

                                                  }
                                                  else if(selectedPlayers.length==10){
                                                    if(selectedPlayerBat.length == 0){
                                                      Future.delayed(Duration(seconds: 10), () {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 Batter.'),
                                                        ));
                                                      });


                                                    } else if(selectedPlayerAR.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 AllRounder.'),
                                                      ));
                                                    }
                                                    else if(selectedPlayerWk.length == 0){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text('Please select max 1 Wicket keeper.'),
                                                      ));
                                                    }else{
                                                      if (totalCredits >= event.points) {
                                                        // Decrease total credits by the points of the added player
                                                        totalCredits -= event.points;
                                                        selectedPlayers.add(playerData);
                                                        selectedPlayerBowl.add(playerData);
                                                        isPlayerSelected = true;
                                                        print("selected players length:::::::"+selectedPlayers.length.toString());
                                                        isMinusButtonbowl[index] = true; // Show the minus button for this item
                                                        isPlusButtonbowl[index] = false; // Hide the plus button
                                                      } else {
                                                        // Handle insufficient credits scenario
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Center(child: Text('Insufficient credits')),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else if(!isPlayerSelected){
                                                    if (totalCredits >= event.points) {
                                                      // Decrease total credits by the points of the added player
                                                      totalCredits -= event.points;

                                                      selectedPlayers.add(playerData);
                                                      selectedPlayerBowl.add(playerData);
                                                      isPlayerSelected = true;
                                                      print("selected players length:::::::"+selectedPlayers.length.toString());
                                                      isMinusButtonbowl[index] = true; // Show the minus button for this item
                                                      isPlusButtonbowl[index] = false; // Hide the plus button
                                                    } else {
                                                      // Handle insufficient credits scenario
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Center(child: Text('Insufficient credits')),
                                                        ),
                                                      );
                                                    }

                                                  }
                                                });
                                              },
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        }
                      },
                    ),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: isNextButtonEnabled() ? () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        TeamPreview(
                          batsmen: selectedPlayerBat,
                          bowlers: selectedPlayerBowl,
                          allrounders: selectedPlayerAR,
                          wicketkeeper: selectedPlayerWk,
                          points: points,
                          time_hours: widget.time_hours,
                          team1: widget.text1,
                          team2: widget.text2,
                          team2_id: widget.team2_id,
                          team1_id: widget.team1_id,
                          credits_Points: totalCredits,
                          lineup: upcomingMatch.lineup,
                        )));
                  } : null,
                  child: Container(
                    height: size.height *0.05,
                    width: size.width *0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isNextButtonEnabled() ? Colors.green : Colors.grey,
                    ),
                    child: Center(
                      child: Text('Preview'.tr,style: TextStyle(
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: isNextButtonEnabled() ? () {
                    if(selectedPlayers.length!=11)
                    {
                      Fluttertoast.showToast(msg: "Please Select 11 Players");
                    }
                    else if(selectedPlayerWk.length==0)
                    {
                      Fluttertoast.showToast(msg: 'At-least 1 Wicketkeeper should be selected');
                    }
                    else if(selectedPlayerBowl.length==0)
                    {
                      Fluttertoast.showToast(msg: 'At-least 1 Bowler should be selected');
                    }
                    else if(selectedPlayerBat.length==0)
                    {
                      Fluttertoast.showToast(msg: 'At-least 1 Batsman should be selected');
                    }
                    else if(selectedPlayerAR.length==0)
                    {
                      Fluttertoast.showToast(msg: 'At-least 1 All rounder should be selected');
                    }
                    else
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              Copy_Team_Save(
                                batsmen: selectedPlayerBat,
                                bowlers: selectedPlayerBowl,
                                allrounders: selectedPlayerAR,
                                wicketkeeper: selectedPlayerWk,
                                credits_left: totalCredits,
                                match_id: widget.Match_id,
                                time_hours: widget.time_hours,
                                text1: widget.text1,
                                text2: widget.text2,
                                logo2: widget.logo2,
                                logo1: widget.logo1,
                                team1_id: widget.team1_id,
                                team2_id: widget.team2_id,
                              )
                          ));
                    }
                  } : null,
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isNextButtonEnabled() ? Color(0xff780000) : Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'Next'.tr,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
  void showBottomSheetDialog(List<PlayersData_> wk_InLineupData,List<PlayersData_> Ar_InLineupData,List<PlayersData_> Bat_InLineupData,List<PlayersData_> Bowl_InLineupData) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return InLineupPopupClass(
          team1_id: widget.team1_id,
          team2_id: widget.team2_id,
          Wk_PlayersData: wk_InLineupData,
          text1: widget.text1,
          text2: widget.text2,
          Ar_PlayersData: Ar_InLineupData,
          Bat_PlayersData: Bat_InLineupData,
          Bowl_PlayersData: Bowl_InLineupData,
          onRemoveUnannouncedPlayers: removeUnannouncedPlayersAndAdjustCredits,
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
