import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/view/Save_Team.dart';
import 'package:world11/view/Team%20Preview.dart';
import '../../App_Widgets/mini_container.dart';
import '../../Model/PlayersTeamCreationResponse/Player_TeamCreate_Response.dart';
import '../../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../../resourses/Image_Assets/image_assets.dart';

class CreateTeam extends StatefulWidget {
  var  logo1,logo2,text1,text2 , time_hours,Match_id,team1_id,team2_id, HighestScore , Average_Score;
   CreateTeam({Key? key,this.logo1,this.logo2,this.text1,this.text2,this.time_hours,this.Match_id,this.team1_id,this.team2_id,this.HighestScore,this.Average_Score}) : super(key: key);
  @override
  State<CreateTeam> createState() => _CreateTeamState();
}
enum TtsState{playing,stopped}

class _CreateTeamState extends State<CreateTeam>with SingleTickerProviderStateMixin  {

  late FlutterTts _flutterTts;
  String? _tts="Hello How are you Good afternoon is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley";
  TtsState _ttsState=TtsState.stopped;


  initTts() async{
    _flutterTts=FlutterTts();

    await _flutterTts.awaitSpeakCompletion(true);
    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");

        _ttsState=TtsState.playing;



      });
    });

    _flutterTts.setCompletionHandler(() {

      setState(() {
        print("Completed");
        _ttsState=TtsState.stopped;
        isSpeaking=false;

      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Canceled");

        _ttsState=TtsState.stopped;
        isSpeaking=false;

      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        print("Error   "+message.toString());

        _ttsState=TtsState.stopped;
        isSpeaking=false;
      });

    });


  }


  late TabController tabController;
  List<String> selectedPlayers = []; // List to keep track of selected players
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
  List<PlayersData_> selectedTeamA = [];

  int maxPlayerLimit = 11;

  Future<List<PlayersData_>?>? Player_Data;
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> BatData_Player=[];
  List<PlayersData_> ARData_Player=[];
  List<PlayersData_> BowlData_Player=[];
  List<String> teamA=[];
  List<String> teamB=[];
  double totalCredits = 100;
  String _token='';
  PlayerTeamCreateResponse_ upcomingMatch=PlayerTeamCreateResponse_();




// Define a variable to keep track of the selected players count
  @override
  void initState() {
    super.initState();
    initTts();



    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Get screen dimensions after the build is complete
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
    });


    getPrefrenceData();
    tabController = TabController(length: 4, vsync: this);
    // print("Data::::dsbfdhhf"+widget.HighestScore.toString()+"::::::"+widget.Average_Score);
  }
  bool isNextButtonEnabled() {
    return selectedPlayers.length == 11;
  }


  @override
  void dispose() {
    _flutterTts.stop();
    tabController.dispose();
    super.dispose();
  }

  Offset _checkBoundaries(Offset offset) {
    // Ensure the FloatingActionButton stays within the screen boundaries
    double left = offset.dx.clamp(0.0, screenWidth - 70.0); // 56 is the width of FloatingActionButton
    double top = offset.dy.clamp(0.0, screenHeight - 70.0); // 56 is the height of FloatingActionButton
    return Offset(left, top);
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

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;
    });
    Player_Data=fetchUpcomingMatches(widget.team1_id, widget.team2_id,_token);

  }

  Future<List<PlayersData_>?> fetchUpcomingMatches(String team1_Id,String team2_Id,String token) async {
    final String apiUrl =
        'https://admin.googly11.in/api/get-upcoming-match-team-player?team_id_1=$team1_Id&team_id_2=$team2_Id&match_id=${int.parse(widget.Match_id.toString())}';

    print("Upcoming Match Api is >>>>>>>>"+apiUrl);

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Upcoming match status code::::::::" + response.statusCode.toString());

      print("Upcomming Match response is >>>>>"+response.body.toString());

      if (response.statusCode == 200) {
         upcomingMatch = PlayerTeamCreateResponse_.fromJson(json.decode(response.body));

        if (upcomingMatch.status == 1) {

          if(upcomingMatch.playersData != null && upcomingMatch.playersData!.isNotEmpty){
            for(int i=0;i<upcomingMatch.playersData!.length; i++){
              switch (upcomingMatch.playersData![i].roleType) {
                case "WICKET KEEPER":
                  Wk_PlayersData.add(upcomingMatch.playersData![i]);
                  if(upcomingMatch.playersData![i].playingTeamId.toString()==widget.team1_id){
                    teamA.add(upcomingMatch.playersData![i].name.toString());
                  }else{
                    teamB.add(upcomingMatch.playersData![i].name.toString());
                  }


                  break;
                case "BATSMEN":
                  BatData_Player.add(upcomingMatch.playersData![i]);
                  if(upcomingMatch.playersData![i].playingTeamId.toString()==widget.team1_id){
                    teamA.add(upcomingMatch.playersData![i].name.toString());
                  }else{
                    teamB.add(upcomingMatch.playersData![i].name.toString());
                  }


                  break;
                case "ALL ROUNDER":
                  ARData_Player.add(upcomingMatch.playersData![i]);
                  if(upcomingMatch.playersData![i].playingTeamId.toString()==widget.team1_id){
                    teamA.add(upcomingMatch.playersData![i].name.toString());
                  }else{
                    teamB.add(upcomingMatch.playersData![i].name.toString());
                  }


                  break;
                case "BOWLER":
                  BowlData_Player.add(upcomingMatch.playersData![i]);
                  if(upcomingMatch.playersData![i].playingTeamId.toString()==widget.team1_id){
                    teamA.add(upcomingMatch.playersData![i].name.toString());
                  }else{
                    teamB.add(upcomingMatch.playersData![i].name.toString());
                  }


                  break;
              }
            }

            print("Team A data is >>>>>>>>>"+teamA.toString());
            print("Team B data is >>>>>>>>>"+teamB.toString());
          // print("Selected >>>>>>>>>"+selectedPlayers.toString());
            return upcomingMatch.playersData;
          }else{

          }
          return upcomingMatch.playersData;
        }
        return upcomingMatch.playersData;

      } else if (response.statusCode == 400) {
        PlayerTeamCreateResponse_ upcomingMatch = PlayerTeamCreateResponse_.fromJson(jsonDecode(response.body));
        if (upcomingMatch.status == 0) {
          print("No Data::::");

          return upcomingMatch.playersData;

        }
      } else {
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}'
        );
      }
    } catch (error) {
      print('Error:::::::::: $error');
    }
    return null;
  }
  Offset fabPosition = Offset(0, 0); // Initial position of the draggable button
  bool isFABVisible = true; // State to control visibility of the draggable button
  bool isDragging = false; // State to track if the button is being dragged
  bool isSpeaking = false;

  // Screen size variables
  late double screenWidth;
  late double screenHeight;


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
                    // Add your logic to discard the team here
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
                    CountdownTimerWidget( time: widget.time_hours),
                ],
              ),
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
                          // Add your logic to discard the team here
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(); // To close the dialog and then the page
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        body: Stack(
          children:[
            Column(
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
                                setState(() {
                                  totalCredits=100;
                                });

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
                Container(
                  height: 35,
                  width: double.infinity,
                  color: Color(0xFF733D39),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Fluttertoast.showToast(msg: "Coming Soon",backgroundColor: Colors.black,textColor: Colors.white,fontSize: 14);
                          },
                          child: Container(
                            height: 35,
                            // width: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.grey, Colors.black54], // Change colors according to your preference
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Expert Teams",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Pitch :",
                                style: TextStyle(color: Colors.grey[300], fontSize: 12),
                              ),
                              Text(
                                "  Batting, ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "City :",
                                style: TextStyle(color: Colors.grey[300], fontSize: 12),
                              ),
                              Text(
                                " ${widget.HighestScore.toString()}, ",
                                // "  ${widget.Average_Score.toString().isNotEmpty ? widget.Average_Score.toString() : '172'}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   "Highest Score",
                              //   style: TextStyle(color: Colors.grey[300], fontSize: 12),
                              // ),
                              // Text(
                              //   "260",
                              //   // "  ${widget.HighestScore.toString().isNotEmpty ? widget.HighestScore.toString() : '188'}",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Text(
                                "Venue :",
                                style: TextStyle(color: Colors.grey[300], fontSize: 12),
                              ),
                              Text(
                                "  ${widget.Average_Score.toString()} ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                TabBar(
                  labelStyle: TextStyle(fontSize: 12),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text("Team",style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                              ),
                              Icon(Icons.arrow_upward,color: Colors.black54,size: 12,),
                              Icon(Icons.arrow_downward,color: Colors.black54,size: 12,),
                              Container(
                                margin: EdgeInsets.only(left: 14),
                                child: Text("Sel by",style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                              ),
                              Icon(Icons.arrow_upward,color: Colors.black54,size: 12,),
                              Icon(Icons.arrow_downward,color: Colors.black54,size: 12,)
                            ]),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text("Credits",style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                            ),
                            Icon(Icons.arrow_upward,color: Colors.black54,size: 12,),
                            Icon(Icons.arrow_downward,color: Colors.black54,size: 12,)
                          ],
                        ),
                      )
                    ],
                  ),
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
                                      child: Text('Players are not announced yet')
                                  )
                              );
                            } else {
                              // List<PlayersData_> announcedPlayers = [];
                              // if (Wk_PlayersData.isNotEmpty) {
                              //   announcedPlayers = Wk_PlayersData.where((player) => player != null && player.isPlay == 1).toList();
                              // }
                              // List<PlayersData_> unannouncedPlayers = [];
                              // if (Wk_PlayersData != null) {
                              //   unannouncedPlayers = Wk_PlayersData.where((player) => player != null && player.isPlay == 0).toList();
                              // }
                              return ListView.builder(
                                  itemCount: Wk_PlayersData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    // Wk_PlayersData.sort((a, b) => a.nickName.compareTo(b.nickName));
                                    Wk_PlayersData.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                                    // Wk_PlayersData.sort((a,b) => b.points.compareTo(a.points));
                                    final event = Wk_PlayersData[index];
                                    print("WICKET KEEPER::::::"+Wk_PlayersData.length.toString());
                                    print("TeamDataaaaaa:::::::"+widget.team1_id+"::::::"+event.playingTeamId.toString());
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
                                    bool isPlayerSelected = selectedPlayers.contains(playerData);
                                    bool isPlayerNotPlaying = event.isPlay == 0;
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          // Adjust the radius here
                                        ),
                                        child: Container(
                                          height: 90,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8), // Adjust the radius here
                                            border: Border.all(
                                              color: Colors.white,
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
                                                    event.nickName.length > 13
                                                        ? '${event.nickName.substring(0, 13)}...'
                                                        : event.nickName,
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

                                                  Text(
                                                    "Points ${event.total_points_in_series}",
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.bold,
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
                                                child: isMinusButtonVisibleList[index]
                                                    ? IconButton(
                                                  icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                                  onPressed: () {
                                                    setState(() {
                                                      print("index"+index.toString());
                                                      print("selected wicket keeper"+selectedPlayerWk.length.toString());
                                                      totalCredits += event.points;
                                                      selectedPlayers.remove(playerData.name.toString());
                                                      selectedPlayerWk.removeWhere((player) => player.playerId == playerData.playerId);
                                                      isPlayerSelected = false;
                                                      isMinusButtonVisibleList[index] =
                                                      false;
                                                      isPlusButtonVisibleList[index] =
                                                      true;
                                                    });
                                                  },
                                                )
                                                    : isPlusButtonVisibleList[index]
                                                    ? IconButton(
                                                  icon: Icon(color: Colors.green,
                                                      Icons.add_circle_outline),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (selectedPlayers.length >= maxPlayerLimit) {

                                                        Fluttertoast.showToast(
                                                            msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else if(selectedPlayerWk.length >= 8){
                                                        if(selectedPlayerAR.length == 0){
                                                          Fluttertoast.showToast(
                                                              msg: "Please select max 1 All Rounder.",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );
                                                        } else if(selectedPlayerBat.length == 0){
                                                          Fluttertoast.showToast(
                                                              msg: "Please select max 1 Batter.",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );
                                                        }
                                                        else if(selectedPlayerBowl.length == 0){
                                                          Fluttertoast.showToast(
                                                              msg: "Please select max 1 Bowler.",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );

                                                        }
                                                        else if(selectedPlayerBowl.length == 0){
                                                          Fluttertoast.showToast(
                                                              msg: "Please select max 1 Bowler.",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );

                                                        }
                                                        else{
                                                          if (totalCredits >= event.points) {
                                                            // Decrease total credits by the points of the added player
                                                            totalCredits -= event.points;


                                                            print("index"+index.toString());

                                                            selectedPlayers.add(playerData.name.toString());

                                                            isPlayerSelected = true;
                                                            selectedPlayerWk.add(playerData);
                                                            selectedTeamA.add(playerData);
                                                            print("selected wicket keeper"+selectedPlayerWk.length.toString());
                                                            print("selected players length:::::::"+selectedPlayerWk.length.toString());
                                                            print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                                                            isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                                                            isPlusButtonVisibleList[index] = false; // Hide the plus button
                                                          } else {
                                                            // Handle insufficient credits scenario
                                                            Fluttertoast.showToast(
                                                                msg: "Insufficient credits",
                                                                backgroundColor: Colors.red,
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                textColor: Colors.white
                                                            );
                                                          }
                                                        }
                                                      }
                                                      else if(selectedPlayerWk.length <= 8){
                                                        if(!isPlayerSelected){
                                                          if (totalCredits >= event.points) {
                                                            // Decrease total credits by the points of the added player
                                                            totalCredits -= event.points;
                                                            print("index"+index.toString());
                                                            selectedPlayers.add(playerData.name.toString());

                                                            isPlayerSelected = true;
                                                            selectedPlayerWk.add(playerData);
                                                            print("selected wicket keeper"+selectedPlayerWk.length.toString());
                                                            print("selected players length:::::::"+selectedPlayerWk.length.toString());
                                                            print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                                                            isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                                                            isPlusButtonVisibleList[index] = false; // Hide the plus button
                                                          } else {
                                                            // Handle insufficient credits scenario
                                                            Fluttertoast.showToast(
                                                                msg: "Insufficient credits",
                                                                backgroundColor: Colors.red,
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                textColor: Colors.white
                                                            );
                                                          }

                                                        }
                                                      } else {

                                                      }
                                                    });
                                                  },
                                                )
                                                    : Container(), // You can replace this with an empty container when neither button is visible
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              );
                              // return Column(
                              //   children: [
                              //     if(upcomingMatch.lineup == 1)
                              //     Column(
                              //       children: [
                              //         CustomPaint(
                              //           size: Size(MediaQuery.of(context).size.width, 10),
                              //           painter: CurvePainter(),
                              //         ),
                              //         Center(
                              //           child: Container(
                              //             height: 25,
                              //             width: 200,
                              //             decoration: BoxDecoration(
                              //                 color: Colors.green,
                              //                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
                              //                     bottomRight: Radius.circular(10)
                              //                 )
                              //             ),
                              //             child: Center(
                              //               child: Text("Announced Players",
                              //                 style: TextStyle(color: Colors.white,
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 12
                              //                 ),),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     if(announcedPlayers.isNotEmpty)
                              //     Expanded(
                              //       child: ListView.builder(
                              //           itemCount: announcedPlayers.length,
                              //           itemBuilder: (BuildContext context, int index) {
                              //             // Wk_PlayersData.sort((a, b) => a.nickName.compareTo(b.nickName));
                              //             announcedPlayers.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                              //             announcedPlayers.sort((a,b) => b.points.compareTo(a.points));
                              //             final event = announcedPlayers[index];
                              //             print("WICKET KEEPER::::::"+announcedPlayers.length.toString());
                              //             print("TeamDataaaaaa:::::::"+widget.team1_id+"::::::"+event.playingTeamId.toString());
                              //             PlayersData_ playerData = PlayersData_(
                              //                 bat: event.bat,
                              //                 playerId: event.playerId,
                              //                 teamId: event.teamId,
                              //                 imageId: event.imageId,
                              //                 roleType: event.roleType,
                              //                 bowl: event.bowl,
                              //                 name: event.name,
                              //                 nickName: event.nickName,
                              //                 role: event.role,
                              //                 intlTeam: event.intlTeam,
                              //                 image: event.image,
                              //                 points: event.points,
                              //                 byuser: event.byuser,
                              //                 playingTeamId: event.playingTeamId,
                              //                 isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              //             );
                              //             bool isPlayerSelected = selectedPlayers.contains(playerData);
                              //             bool isPlayerNotPlaying = event.isPlay == 0;
                              //             return Padding(
                              //               padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                              //               child: Card(
                              //                 elevation: 10,
                              //                 shape: RoundedRectangleBorder(
                              //                   borderRadius: BorderRadius.circular(8),
                              //                   // Adjust the radius here
                              //                 ),
                              //                 child: Container(
                              //                   height: 90,
                              //                   width: double.infinity,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(8), // Adjust the radius here
                              //                     border: Border.all(
                              //                       color: Colors.white,
                              //                       width: 1.5,
                              //                       style: BorderStyle.solid,
                              //                     ),
                              //                   ),
                              //                   child: Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //                     crossAxisAlignment: CrossAxisAlignment.start,
                              //                     children: [
                              //                       Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         crossAxisAlignment: CrossAxisAlignment.center,
                              //                         children: [
                              //                           Center(
                              //                             child: CircleAvatar(
                              //                                 radius: 25,
                              //                                 backgroundImage: NetworkImage(event.image)
                              //                             ),
                              //                           ),
                              //                           Container(
                              //                             height: 15,
                              //                             width: 60,
                              //                             decoration: BoxDecoration(
                              //                               color: event.playingTeamId != null
                              //                                   ? widget.team1_id == event.playingTeamId.toString()
                              //                                   ? Colors.black // Set color for team1_id match
                              //                                   : Colors.white // Set color for other team
                              //                                   : Colors.amberAccent, // Default color if playing_team_id is null
                              //                               borderRadius: BorderRadius.circular(15),
                              //                             ),
                              //                             child: Center(
                              //                               child: Text(
                              //                                 event.playingTeamId != null
                              //                                     ? widget.team1_id == event.playingTeamId.toString()
                              //                                     ? "${widget.text1}"
                              //                                     : "${widget.text2}"
                              //                                     : "NA",
                              //                                 style: TextStyle(
                              //                                   color: event.playingTeamId != null
                              //                                       ? widget.team1_id == event.playingTeamId.toString()
                              //                                       ? Colors.white // Set text color for team1_id match
                              //                                       : Colors.black // Set text color for other team
                              //                                       : Colors.amberAccent, // Default text color if playing_team_id is null
                              //                                   fontSize: 10,
                              //                                   fontWeight: FontWeight.w700,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                       Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         crossAxisAlignment: CrossAxisAlignment.start,
                              //                         children: [
                              //                           Text(
                              //                             event.nickName.length > 13
                              //                                 ? '${event.nickName.substring(0, 13)}...'
                              //                                 : event.nickName,
                              //                             style: TextStyle(
                              //                               fontSize: 14,
                              //                               fontWeight: FontWeight.w500,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //                           Text(
                              //                             "Sel by ${event.byuser}%",
                              //                             style: TextStyle(
                              //                               fontSize: 11,
                              //                               fontWeight: FontWeight.w300,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //                           Text(
                              //                             "Points ${event.total_points_in_series}",
                              //                             style: TextStyle(
                              //                               fontSize: 9,
                              //                               fontWeight: FontWeight.bold,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //
                              //                           if(event.isPlay==0 && upcomingMatch.lineup == 0)
                              //                             Text(
                              //                               event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                              //                               style: TextStyle(
                              //                                 fontSize: 12,
                              //                                 fontWeight: FontWeight.w400,
                              //                                 color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                              //                               ),
                              //                             ),
                              //
                              //                           if(event.isPlay==1 && upcomingMatch.lineup == 1)
                              //                             Row(
                              //                               children: [
                              //                                 Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                              //                                 Text(
                              //                                   "In Lineup",
                              //                                   style: TextStyle(
                              //                                     fontSize: 12,
                              //                                     fontWeight: FontWeight.w400,
                              //                                     color: Colors.green,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           if(event.isPlay==0 && upcomingMatch.lineup == 1)
                              //                             Row(
                              //                               children: [
                              //                                 Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                              //                                 Text(
                              //                                   "Not Playing",
                              //                                   style: TextStyle(
                              //                                     fontSize: 12,
                              //                                     fontWeight: FontWeight.w400,
                              //                                     color: Colors.red,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                         ],
                              //                       ),
                              //                       Center(
                              //                         child: Text(
                              //                           event.points.toString(),
                              //                           style: TextStyle(
                              //                             fontSize: 13,
                              //                             fontWeight: FontWeight.w600,
                              //                             color: Colors.black,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       Center(
                              //                         child: isMinusButtonVisibleList[index]
                              //                             ? IconButton(
                              //                           icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                              //                           onPressed: () {
                              //                             setState(() {
                              //                               print("index"+index.toString());
                              //                               print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                               totalCredits += event.points;
                              //                               selectedPlayers.remove(playerData.toString());
                              //                               selectedPlayerWk.removeWhere((player) => player.playerId == playerData.playerId);
                              //                               isPlayerSelected = false;
                              //                               isMinusButtonVisibleList[index] =
                              //                               false;
                              //                               isPlusButtonVisibleList[index] =
                              //                               true;
                              //                             });
                              //                           },
                              //                         )
                              //                             : isPlusButtonVisibleList[index]
                              //                             ? IconButton(
                              //                           icon: Icon(color: Colors.green,
                              //                               Icons.add_circle_outline),
                              //                           onPressed: () {
                              //                             setState(() {
                              //                               if (selectedPlayers.length >= maxPlayerLimit) {
                              //                                 Fluttertoast.showToast(
                              //                                     msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                              //                                     backgroundColor: Colors.red,
                              //                                     toastLength: Toast.LENGTH_SHORT,
                              //                                     textColor: Colors.white
                              //                                 );
                              //                               }
                              //                               else if(selectedPlayerWk.length >= 8){
                              //                                 if(selectedPlayerAR.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 All Rounder.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 } else if(selectedPlayerBat.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 Batter.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 }
                              //                                 else if(selectedPlayerBowl.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 Bowler.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 }else{
                              //                                   if (totalCredits >= event.points) {
                              //                                     // Decrease total credits by the points of the added player
                              //                                     totalCredits -= event.points;
                              //
                              //                                     print("index"+index.toString());
                              //                                     selectedPlayers.add(playerData.toString());
                              //                                     isPlayerSelected = true;
                              //                                     selectedPlayerWk.add(playerData);
                              //                                     print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                                     print("selected players length:::::::"+selectedPlayerWk.length.toString());
                              //                                     print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                              //                                     isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                              //                                     isPlusButtonVisibleList[index] = false; // Hide the plus button
                              //                                   } else {
                              //                                     // Handle insufficient credits scenario
                              //                                     Fluttertoast.showToast(
                              //                                         msg: "Insufficient credits",
                              //                                         backgroundColor: Colors.red,
                              //                                         toastLength: Toast.LENGTH_SHORT,
                              //                                         textColor: Colors.white
                              //                                     );
                              //                                   }
                              //                                 }
                              //                               }
                              //                               else if(selectedPlayerWk.length <= 8){
                              //                                 if(!isPlayerSelected){
                              //                                   if (totalCredits >= event.points) {
                              //                                     // Decrease total credits by the points of the added player
                              //                                     totalCredits -= event.points;
                              //                                     print("index"+index.toString());
                              //                                     selectedPlayers.add(playerData.toString());
                              //                                     isPlayerSelected = true;
                              //                                     selectedPlayerWk.add(playerData);
                              //                                     print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                                     print("selected players length:::::::"+selectedPlayerWk.length.toString());
                              //                                     print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                              //                                     isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                              //                                     isPlusButtonVisibleList[index] = false; // Hide the plus button
                              //                                   } else {
                              //                                     // Handle insufficient credits scenario
                              //                                     Fluttertoast.showToast(
                              //                                         msg: "Insufficient credits",
                              //                                         backgroundColor: Colors.red,
                              //                                         toastLength: Toast.LENGTH_SHORT,
                              //                                         textColor: Colors.white
                              //                                     );
                              //                                   }
                              //
                              //                                 }
                              //                               } else {
                              //
                              //                               }
                              //                             });
                              //                           },
                              //                         )
                              //                             : Container(), // You can replace this with an empty container when neither button is visible
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             );
                              //           }
                              //       ),
                              //     ),
                              //     if(upcomingMatch.lineup == 1)
                              //     Column(
                              //       children: [
                              //         CustomPaint(
                              //           size: Size(MediaQuery.of(context).size.width, 5),
                              //           painter: CurvePainter2(),
                              //         ),
                              //         Center(
                              //           child: Container(
                              //             height: 25,
                              //             width: 200,
                              //             decoration: BoxDecoration(
                              //                 color: Colors.red,
                              //                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),
                              //                     bottomRight: Radius.circular(10)
                              //                 )
                              //             ),
                              //             child: Center(
                              //               child: Text("Unannounced Players",
                              //                 style: TextStyle(color: Colors.white,
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 12
                              //                 ),),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     if(unannouncedPlayers.isNotEmpty)
                              //     Expanded(
                              //       child: ListView.builder(
                              //           itemCount: unannouncedPlayers.length,
                              //           itemBuilder: (BuildContext context, int index) {
                              //             // Wk_PlayersData.sort((a, b) => a.nickName.compareTo(b.nickName));
                              //             unannouncedPlayers.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                              //             unannouncedPlayers.sort((a,b) => b.points.compareTo(a.points));
                              //             final event = unannouncedPlayers[index];
                              //             print("WICKET KEEPER::::::"+unannouncedPlayers.length.toString());
                              //             print("TeamDataaaaaa:::::::"+widget.team1_id+"::::::"+event.playingTeamId.toString());
                              //             PlayersData_ playerData = PlayersData_(
                              //                 bat: event.bat,
                              //                 playerId: event.playerId,
                              //                 teamId: event.teamId,
                              //                 imageId: event.imageId,
                              //                 roleType: event.roleType,
                              //                 bowl: event.bowl,
                              //                 name: event.name,
                              //                 nickName: event.nickName,
                              //                 role: event.role,
                              //                 intlTeam: event.intlTeam,
                              //                 image: event.image,
                              //                 points: event.points,
                              //                 byuser: event.byuser,
                              //                 playingTeamId: event.playingTeamId,
                              //                 isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                              //             );
                              //             bool isPlayerSelected = selectedPlayers.contains(playerData);
                              //             bool isPlayerNotPlaying = event.isPlay == 0;
                              //             return Padding(
                              //               padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                              //               child: Card(
                              //                 elevation: 10,
                              //                 shape: RoundedRectangleBorder(
                              //                   borderRadius: BorderRadius.circular(8),
                              //                   // Adjust the radius here
                              //                 ),
                              //                 child: Container(
                              //                   height: 90,
                              //                   width: double.infinity,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(8), // Adjust the radius here
                              //                     border: Border.all(
                              //                       color: Colors.white,
                              //                       width: 1.5,
                              //                       style: BorderStyle.solid,
                              //                     ),
                              //                   ),
                              //                   child: Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //                     crossAxisAlignment: CrossAxisAlignment.start,
                              //                     children: [
                              //                       Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         crossAxisAlignment: CrossAxisAlignment.center,
                              //                         children: [
                              //                           Center(
                              //                             child: CircleAvatar(
                              //                                 radius: 25,
                              //                                 backgroundImage: NetworkImage(event.image)
                              //                             ),
                              //                           ),
                              //                           Container(
                              //                             height: 15,
                              //                             width: 60,
                              //                             decoration: BoxDecoration(
                              //                               color: event.playingTeamId != null
                              //                                   ? widget.team1_id == event.playingTeamId.toString()
                              //                                   ? Colors.black // Set color for team1_id match
                              //                                   : Colors.white // Set color for other team
                              //                                   : Colors.amberAccent, // Default color if playing_team_id is null
                              //                               borderRadius: BorderRadius.circular(15),
                              //                             ),
                              //                             child: Center(
                              //                               child: Text(
                              //                                 event.playingTeamId != null
                              //                                     ? widget.team1_id == event.playingTeamId.toString()
                              //                                     ? "${widget.text1}"
                              //                                     : "${widget.text2}"
                              //                                     : "NA",
                              //                                 style: TextStyle(
                              //                                   color: event.playingTeamId != null
                              //                                       ? widget.team1_id == event.playingTeamId.toString()
                              //                                       ? Colors.white // Set text color for team1_id match
                              //                                       : Colors.black // Set text color for other team
                              //                                       : Colors.amberAccent, // Default text color if playing_team_id is null
                              //                                   fontSize: 10,
                              //                                   fontWeight: FontWeight.w700,
                              //                                 ),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                       Column(
                              //                         mainAxisAlignment: MainAxisAlignment.center,
                              //                         crossAxisAlignment: CrossAxisAlignment.start,
                              //                         children: [
                              //                           Text(
                              //                             event.nickName.length > 13
                              //                                 ? '${event.nickName.substring(0, 13)}...'
                              //                                 : event.nickName,
                              //                             style: TextStyle(
                              //                               fontSize: 14,
                              //                               fontWeight: FontWeight.w500,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //                           Text(
                              //                             "Sel by ${event.byuser}%",
                              //                             style: TextStyle(
                              //                               fontSize: 11,
                              //                               fontWeight: FontWeight.w300,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //                           Text(
                              //                             "Points ${event.total_points_in_series}",
                              //                             style: TextStyle(
                              //                               fontSize: 9,
                              //                               fontWeight: FontWeight.bold,
                              //                               color: Colors.black,
                              //                             ),
                              //                           ),
                              //
                              //
                              //                           if(event.isPlay==0 && upcomingMatch.lineup == 0)
                              //                             Text(
                              //                               event.last_match_playing != null && event.last_match_playing == 1 ? "Played last match" : "Not played last match",
                              //                               style: TextStyle(
                              //                                 fontSize: 12,
                              //                                 fontWeight: FontWeight.w400,
                              //                                 color: event.last_match_playing != null && event.last_match_playing == 1 ? Colors.green : Colors.black,
                              //                               ),
                              //                             ),
                              //
                              //                           if(event.isPlay==1 && upcomingMatch.lineup == 1)
                              //                             Row(
                              //                               children: [
                              //                                 Image(image: AssetImage(ImageAssets.green_tic),height: 12,width: 12,),
                              //                                 Text(
                              //                                   "In Lineup",
                              //                                   style: TextStyle(
                              //                                     fontSize: 12,
                              //                                     fontWeight: FontWeight.w400,
                              //                                     color: Colors.green,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           if(event.isPlay==0 && upcomingMatch.lineup == 1)
                              //                             Row(
                              //                               children: [
                              //                                 Image(image: AssetImage(ImageAssets.RedCircle),height: 12,width: 12,),
                              //                                 Text(
                              //                                   "Not Playing",
                              //                                   style: TextStyle(
                              //                                     fontSize: 12,
                              //                                     fontWeight: FontWeight.w400,
                              //                                     color: Colors.red,
                              //                                   ),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                         ],
                              //                       ),
                              //                       Center(
                              //                         child: Text(
                              //                           event.points.toString(),
                              //                           style: TextStyle(
                              //                             fontSize: 13,
                              //                             fontWeight: FontWeight.w600,
                              //                             color: Colors.black,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       Center(
                              //                         child: isMinusButtonVisibleList[index]
                              //                             ? IconButton(
                              //                           icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                              //                           onPressed: () {
                              //                             setState(() {
                              //                               print("index"+index.toString());
                              //                               print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                               totalCredits += event.points;
                              //                               selectedPlayers.remove(playerData.toString());
                              //                               selectedPlayerWk.removeWhere((player) => player.playerId == playerData.playerId);
                              //                               isPlayerSelected = false;
                              //                               isMinusButtonVisibleList[index] =
                              //                               false;
                              //                               isPlusButtonVisibleList[index] =
                              //                               true;
                              //                             });
                              //                           },
                              //                         )
                              //                             : isPlusButtonVisibleList[index]
                              //                             ? IconButton(
                              //                           icon: Icon(color: Colors.green,
                              //                               Icons.add_circle_outline),
                              //                           onPressed: () {
                              //                             setState(() {
                              //                               if (selectedPlayers.length >= maxPlayerLimit) {
                              //                                 Fluttertoast.showToast(
                              //                                     msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                              //                                     backgroundColor: Colors.red,
                              //                                     toastLength: Toast.LENGTH_SHORT,
                              //                                     textColor: Colors.white
                              //                                 );
                              //                               }
                              //                               else if(selectedPlayerWk.length >= 8){
                              //                                 if(selectedPlayerAR.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 All Rounder.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 } else if(selectedPlayerBat.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 Batter.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 }
                              //                                 else if(selectedPlayerBowl.length == 0){
                              //                                   Fluttertoast.showToast(
                              //                                       msg: "Please select max 1 Bowler.",
                              //                                       backgroundColor: Colors.red,
                              //                                       toastLength: Toast.LENGTH_SHORT,
                              //                                       textColor: Colors.white
                              //                                   );
                              //                                 }else{
                              //                                   if (totalCredits >= event.points) {
                              //                                     // Decrease total credits by the points of the added player
                              //                                     totalCredits -= event.points;
                              //
                              //                                     print("index"+index.toString());
                              //                                     selectedPlayers.add(playerData.toString());
                              //                                     isPlayerSelected = true;
                              //                                     selectedPlayerWk.add(playerData);
                              //                                     print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                                     print("selected players length:::::::"+selectedPlayerWk.length.toString());
                              //                                     print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                              //                                     isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                              //                                     isPlusButtonVisibleList[index] = false; // Hide the plus button
                              //                                   } else {
                              //                                     // Handle insufficient credits scenario
                              //                                     Fluttertoast.showToast(
                              //                                         msg: "Insufficient credits",
                              //                                         backgroundColor: Colors.red,
                              //                                         toastLength: Toast.LENGTH_SHORT,
                              //                                         textColor: Colors.white
                              //                                     );
                              //                                   }
                              //                                 }
                              //                               }
                              //                               else if(selectedPlayerWk.length <= 8){
                              //                                 if(!isPlayerSelected){
                              //                                   if (totalCredits >= event.points) {
                              //                                     // Decrease total credits by the points of the added player
                              //                                     totalCredits -= event.points;
                              //                                     print("index"+index.toString());
                              //                                     selectedPlayers.add(playerData.toString());
                              //                                     isPlayerSelected = true;
                              //                                     selectedPlayerWk.add(playerData);
                              //                                     print("selected wicket keeper"+selectedPlayerWk.length.toString());
                              //                                     print("selected players length:::::::"+selectedPlayerWk.length.toString());
                              //                                     print("Player Data: ${playerData.name}, ${playerData.points}, ${playerData.image}");
                              //                                     isMinusButtonVisibleList[index] = true; // Show the minus button for this item
                              //                                     isPlusButtonVisibleList[index] = false; // Hide the plus button
                              //                                   } else {
                              //                                     // Handle insufficient credits scenario
                              //                                     Fluttertoast.showToast(
                              //                                         msg: "Insufficient credits",
                              //                                         backgroundColor: Colors.red,
                              //                                         toastLength: Toast.LENGTH_SHORT,
                              //                                         textColor: Colors.white
                              //                                     );
                              //                                   }
                              //
                              //                                 }
                              //                               } else {
                              //
                              //                               }
                              //                             });
                              //                           },
                              //                         )
                              //                             : Container(), // You can replace this with an empty container when neither button is visible
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             );
                              //           }
                              //       ),
                              //     ),
                              //   ],
                              // );
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
                              return Center(child: Text('No Players Data available'));
                            } else {
                              return  ListView.builder(
                                itemCount: BatData_Player.length, // Replace with the number of items you have
                                itemBuilder: (BuildContext context, int index) {
                                  // BatData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                                  BatData_Player.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                                  //   BatData_Player.sort((a, b) => b.points.compareTo(a.points));
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
                                      isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                                  );
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
                                            color: Colors.white,
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
                                                  event.nickName.length > 13
                                                      ? '${event.nickName.substring(0, 13)}...'
                                                      : event.nickName,
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

                                                Text(
                                                  "Points ${event.total_points_in_series}",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
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
                                              child: isMinusButtonforBat[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                                onPressed: () {
                                                  setState(() {
                                                    // Remove the player from the selectedPlayers list
                                                    print("index"+index.toString());
                                                    // if (index >= 0  && index < selectedPlayerBat.length) {
                                                    totalCredits += event.points;
                                                    selectedPlayers.remove(playerData.name.toString());
                                                    selectedPlayerBat.removeWhere((player) => player.playerId == playerData.playerId);
                                                    print("selected players length:::::::"+selectedPlayerBat.length.toString());
                                                    isPlayerSelected = false;
                                                    isMinusButtonforBat[index] = false;
                                                    isPlusButtonforBat[index] = true;

                                                    // }
                                                  });
                                                },
                                              )
                                                  : isPlusButtonforBat[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                                onPressed: () {

                                                  setState(() {
                                                    if (selectedPlayers.length >= maxPlayerLimit) {
                                                      Fluttertoast.showToast(
                                                          msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                                                          backgroundColor: Colors.red,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          textColor: Colors.white
                                                      );
                                                    }
                                                    else if(selectedPlayerBat.length >= 8){
                                                      if(selectedPlayerAR.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 All Rounder.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      } else if(selectedPlayerBowl.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 Baller.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else if(selectedPlayerWk.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 Wicket keeper.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else{
                                                        if (totalCredits >= event.points) {
                                                          // Decrease total credits by the points of the added player
                                                          totalCredits -= event.points;

                                                          selectedPlayers.add(playerData.name.toString());
                                                          selectedPlayerBat.add(playerData);
                                                          isPlayerSelected = true;
                                                          print("selected players length:::::::"+selectedPlayers.length.toString());
                                                          isMinusButtonforBat[index] = true; // Show the minus button for this item
                                                          isPlusButtonforBat[index] = false; // Hide the plus button
                                                        } else {
                                                          // Handle insufficient credits scenario
                                                          Fluttertoast.showToast(
                                                              msg: "Insufficient credits",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );
                                                        }
                                                      }
                                                    }
                                                    else if(selectedPlayerBat.length <= 8){
                                                      if(!isPlayerSelected){
                                                        if (totalCredits >= event.points) {
                                                          // Decrease total credits by the points of the added player
                                                          totalCredits -= event.points;
                                                          selectedPlayers.add(playerData.name.toString());
                                                          selectedPlayerBat.add(playerData);
                                                          isPlayerSelected = true;
                                                          print("selected players length:::::::"+selectedPlayers.length.toString());
                                                          isMinusButtonforBat[index] = true; // Show the minus button for this item
                                                          isPlusButtonforBat[index] = false; // Hide the plus button
                                                        } else {
                                                          Fluttertoast.showToast(
                                                              msg: "Insufficient credits",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );
                                                        }
                                                      }
                                                    }
                                                    else {
                                                      Fluttertoast.showToast(
                                                          msg: "Maximum 8 Batters",
                                                          backgroundColor: Colors.red,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          textColor: Colors.white
                                                      );
                                                    }
                                                  });
                                                },
                                              )
                                                  : Container(), // You can replace this with an empty container when neither button is visible
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
                              return Center(child: Text('No Players Data available'));
                            } else {

                              return  ListView.builder(
                                itemCount: ARData_Player.length, // Replace with the number of items you have
                                itemBuilder: (BuildContext context, int index) {
                                  // ARData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                                  ARData_Player.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                                  //   ARData_Player.sort((a, b) => b.points.compareTo(a.points));
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
                                      isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                                  );
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
                                            color: Colors.white,
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      event.nickName.length > 13
                                                          ? '${event.nickName.substring(0, 13)}...'
                                                          : event.nickName,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    if(event.role.toString() == "Bowling Allrounder")
                                                      Image(image: AssetImage(ImageAssets.boll),width: 15,height: 15),
                                                    if(event.role.toString() == "Batting Allrounder")
                                                      Image(image: AssetImage('assets/images/bat.jpg'),width: 15,height: 15)
                                                  ],
                                                ),
                                                Text(
                                                  "Sel by ${event.byuser}%",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                  ),
                                                ),

                                                Text(
                                                  "Points ${event.total_points_in_series}",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
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
                                              child: isMinusButtonAr[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                                onPressed: () {
                                                  setState(() {
                                                    // Remove the player from the selectedPlayers list
                                                    print("index"+index.toString());
                                                    print("selected wicket keeper"+selectedPlayerAR.length.toString());
                                                    totalCredits += event.points;
                                                    selectedPlayers.remove(playerData.name.toString());
                                                    selectedPlayerAR.removeWhere((player) => player.playerId == playerData.playerId);
                                                    print("selected players length:::::::" + selectedPlayerAR.length.toString());
                                                    isPlayerSelected = false;
                                                    isMinusButtonAr[index] = false;
                                                    isPlusButtonAr[index] = true;
                                                  });
                                                },
                                              )
                                                  : isPlusButtonAr[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                                onPressed: () {
                                                  setState(() {
                                                    if (selectedPlayers.length >= maxPlayerLimit) {
                                                      Fluttertoast.showToast(
                                                          msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                                                          backgroundColor: Colors.red,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          textColor: Colors.white
                                                      );
                                                    }
                                                    else if(selectedPlayerAR.length >= 8){
                                                      if(selectedPlayerBat.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 Batter.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else if(selectedPlayerBowl.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 Baller.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else if(selectedPlayerWk.length == 0){
                                                        Fluttertoast.showToast(
                                                            msg: "Please select max 1 Wicket keeper.",
                                                            backgroundColor: Colors.red,
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                      else{
                                                        if (totalCredits >= event.points) {
                                                          // Decrease total credits by the points of the added player
                                                          totalCredits -= event.points;

                                                          selectedPlayers.add(playerData.name.toString());
                                                          selectedPlayerAR.add(playerData);
                                                          isPlayerSelected = true;
                                                          print("selected players length:::::::" +
                                                              selectedPlayers.length.toString());
                                                          isMinusButtonAr[index] = true; // Show the minus button for this item
                                                          isPlusButtonAr[index] = false; // Hide the plus button
                                                        } else {
                                                          // Handle insufficient credits scenario
                                                          Fluttertoast.showToast(
                                                              msg: "Insufficient credits",
                                                              backgroundColor: Colors.red,
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              textColor: Colors.white
                                                          );
                                                        }
                                                      }
                                                    }
                                                    else if(selectedPlayerAR.length <=8) {
                                                      if (!isPlayerSelected) {
                                                        if (totalCredits >=
                                                            event.points) {
                                                          totalCredits -=
                                                              event.points;
                                                          selectedPlayers.add(
                                                              playerData.name.
                                                              toString());
                                                          selectedPlayerAR.add(
                                                              playerData);
                                                          isPlayerSelected = true;
                                                          print(
                                                              "selected players length:::::::" +
                                                                  selectedPlayers
                                                                      .length
                                                                      .toString());
                                                          isMinusButtonAr[index] =
                                                          true; // Show the minus button for this item
                                                          isPlusButtonAr[index] =
                                                          false; // Hide the plus button
                                                        }
                                                        // else if(selectedPlayers. == ) {
                                                        //   Fluttertoast.showToast(
                                                        //       msg: "You have reached the maximum player limit from one team $maxPlayerLimit.",
                                                        //       backgroundColor: Colors.red,
                                                        //       toastLength: Toast.LENGTH_SHORT,
                                                        //       textColor: Colors.white
                                                        //   );
                                                        // }
                                                        else {
                                                          // Handle insufficient credits scenario
                                                          Fluttertoast.showToast(
                                                              msg: "Insufficient credits",
                                                              backgroundColor: Colors
                                                                  .red,
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              textColor: Colors
                                                                  .white
                                                          );
                                                        }
                                                      }

                                                      else {
                                                        Fluttertoast.showToast(
                                                            msg: "Maximum 8 AllRounders",
                                                            backgroundColor: Colors
                                                                .red,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            textColor: Colors.white
                                                        );
                                                      }
                                                    }
                                                  });
                                                },
                                              )
                                                  : Container(), // You can replace this with an empty container when neither button is visible
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
                              return Center(
                                  child: Text(
                                      'No Players available'
                                  ));
                            } else {
                              return  ListView.builder(
                                itemCount: BowlData_Player.length, // Replace with the number of items you have
                                itemBuilder: (BuildContext context, int index) {
                                  // BowlData_Player.sort((a, b) => a.nickName.compareTo(b.nickName));
                                  BowlData_Player.sort((a, b) => b.isPlay.compareTo(a.isPlay));
                                  //   BowlData_Player.sort((a, b) => b.points.compareTo(a.points));
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
                                      isPlay: event.isPlay, captionByuser: event.captionByuser, VoiceCaptionByuser: event.VoiceCaptionByuser
                                  );
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
                                            color: Colors.white,
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      event.nickName.length > 13
                                                          ? '${event.nickName.substring(0, 13)}...'
                                                          : event.nickName,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    if(event.role.toString() == "Bowler")
                                                      Image(image: AssetImage(ImageAssets.boll),width: 15,height: 15),
                                                  ],
                                                ),
                                                Text(
                                                  "Sel by ${event.byuser}%",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                  ),
                                                ),

                                                Text(
                                                  "Points ${event.total_points_in_series}",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
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
                                                      Image(image: AssetImage(ImageAssets.green_tic),height: 13,width: 13,),
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
                                                      Image(image: AssetImage(ImageAssets.RedCircle),height: 13,width: 13,),
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
                                              child: isMinusButtonbowl[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.red,Icons.remove_circle_outline),
                                                onPressed: () {
                                                  setState(() {
                                                    // Remove the player from the selectedPlayers list
                                                    print("index"+index.toString());
                                                    totalCredits += event.points;
                                                    selectedPlayers.remove(playerData.name.toString());
                                                    selectedPlayerBowl.removeWhere((player) => player.playerId == playerData.playerId);
                                                    print("selected players length:::::::"+selectedPlayerBowl.length.toString());
                                                    print("Selected Playeyr>>>>>>>>>>>"+selectedPlayers.toString());
                                                    isPlayerSelected = false;
                                                    isMinusButtonbowl[index] = false;
                                                    isPlusButtonbowl[index] = true;
                                                    // }
                                                  });
                                                },
                                              )
                                                  : isPlusButtonbowl[index]
                                                  ? IconButton(
                                                icon: Icon(color: Colors.green,Icons.add_circle_outline),
                                                onPressed: () {
                                                  setState(() {
                                                    if (selectedPlayers.length >= maxPlayerLimit) {
                                                      Fluttertoast.showToast(
                                                          msg: "You have reached the maximum player limit of $maxPlayerLimit.",
                                                          backgroundColor: Colors.red,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          textColor: Colors.white
                                                      );
                                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      //   content: Text('You have reached the maximum player limit of $maxPlayerLimit.'),
                                                      // ));
                                                    }
                                                    else if(selectedPlayerBowl.length >=8){
                                                      if(selectedPlayerAR.length == 0){
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 All Rounder.'),
                                                        ));
                                                      } else if(selectedPlayerBat.length == 0){
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 Batter.'),
                                                        ));
                                                      }
                                                      else if(selectedPlayerWk.length == 0){
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text('Please select max 1 Wicket keeper.'),
                                                        ));
                                                      } else
                                                      {
                                                        if (totalCredits >= event.points) {
                                                          // Decrease total credits by the points of the added player
                                                          totalCredits -= event.points;
                                                          selectedPlayers.add(playerData.name.toString());
                                                          selectedPlayerBowl.add(playerData);
                                                          isPlayerSelected = true;
                                                          print("selected players length:::::::"+selectedPlayers.length.toString());
                                                          isMinusButtonbowl[index] = true; // Show the minus button for this item
                                                          isPlusButtonbowl[index] = false; // Hide the plus button
                                                        } else {
                                                          // Handle insufficient credits scenario
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Insufficient credits'),
                                                          ));
                                                        }
                                                      }
                                                    }
                                                    else if(selectedPlayerBowl.length <= 8){
                                                      if(!isPlayerSelected){
                                                        if (totalCredits >= event.points) {
                                                          // Decrease total credits by the points of the added player
                                                          totalCredits -= event.points;

                                                          selectedPlayers.add(playerData.name.toString());
                                                          selectedPlayerBowl.add(playerData);
                                                          isPlayerSelected = true;
                                                          print("selected players length:::::::"+selectedPlayers.length.toString());
                                                          isMinusButtonbowl[index] = true; // Show the minus button for this item
                                                          isPlusButtonbowl[index] = false; // Hide the plus button
                                                        } else {
                                                          // Handle insufficient credits scenario
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text('Insufficient credits'),
                                                          ));
                                                        }
                                                        // Add the player to the selectedPlayers list
                                                        // Hide the plus button
                                                      }
                                                    } else{
                                                      Fluttertoast.showToast(
                                                          msg: "Maximum 8 Bowlers",
                                                          backgroundColor: Colors.red,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          textColor: Colors.white
                                                      );
                                                    }
                                                  });
                                                },
                                              )
                                                  : Container(), // You can replace this with an empty container when neither button is visible
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>
                                TeamPreview(
                                  batsmen: selectedPlayerBat,
                                  bowlers: selectedPlayerBowl,
                                  allrounders: selectedPlayerAR,
                                  wicketkeeper: selectedPlayerWk,
                                  points: points,
                                  time_hours: widget.time_hours,
                                  team1: widget.text1,
                                  team2: widget.text2,
                                  team1_id: widget.team1_id,
                                  team2_id: widget.team2_id,
                                  credits_Points: totalCredits,
                                  lineup: upcomingMatch.lineup,
                                )
                            ));
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
                        else if(!teamA.any((name) => selectedPlayers.toString().contains(name)) )
                        {
                          print("Selected Player list is "+selectedPlayers.toString());
                          Fluttertoast.showToast(msg: 'Dont Select only from one team');
                          // Fluttertoast.showToast(msg: 'Dont Select only from one team');

                        }
                        else if(!teamB.any((name) => selectedPlayers.toString().contains(name)))
                        {
                          Fluttertoast.showToast(msg: 'You cant choose all players from one team ');
                        }
                        else
                        {
                          print("Selected Player Length is >>>>>>>>>>>>>"+selectedPlayers.first);
                          selectedPlayers.forEach((player) => print(player));
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  Save_Team(
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
                                    HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                                    Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
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
            Positioned(
              left: fabPosition.dx,
              top: fabPosition.dy,
              child: Draggable(
                feedback: FloatingActionButton(
                  onPressed: () {
                  },
                  child: Icon(Icons.stop,color: Colors.white,),
                  backgroundColor: Colors.black45.withOpacity(0.7),
                    elevation: 6.0,
                  mini: true,
                ),
                child: isFABVisible
                    ? FloatingActionButton(
                  backgroundColor: isSpeaking ? Colors.green : Colors.red,
                    elevation: 6.0,
                  mini: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Custom shape
                    // You can also use other shapes like StadiumBorder, CircleBorder, etc.
                  ),
                  onPressed: () {
                    // Handle button press
                    if(!isSpeaking){
                      speak();
                    }else{
                      stop();
                    }

                  },
                  child: isSpeaking? Image.asset("assets/images/commentarygif.gif",fit: BoxFit.cover,):Icon(Icons.stop)
                )
                    : FloatingActionButton(
                  onPressed: stop,
                  child: Icon(Icons.stop),

                ),
                onDragStarted: () {
                  setState(() {
                    // Show the close button when dragging starts
                    isDragging = true;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    // Hide the close button and update position when dragging ends
                    isDragging = false;
                    fabPosition = _checkBoundaries(details.offset);
                  });
                },
                onDraggableCanceled: (velocity, offset) {
                  setState(() {
                    // Hide the close button when drag is canceled
                    isDragging = false;
                    fabPosition = _checkBoundaries(offset);

                  });
                },
              ),
            ),

            // Close button at the bottom
            if (isDragging)
              Positioned(
                bottom: 16, // Adjust this value as needed
                left: 40,
                right: 30,// Adjust this value as needed
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle visibility of the draggable button
                      isFABVisible = !isFABVisible;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
          ]
        ),
      ),
    );
  }

  Future speak() async{
    List<dynamic> voices = await _flutterTts.getVoices;
    print("Available voices: $voices");
    setState(() {
      isSpeaking = true;
    });
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1);
    await _flutterTts.setPitch(0.5);
    await _flutterTts.getDefaultVoice;
    await _flutterTts.getMaxSpeechInputLength;
    //await _flutterTts.setLanguage("hi-IN");
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.getEngines;
   

    if(_tts !=null){
      if(_tts!.isNotEmpty){
        await _flutterTts.speak(_tts!);
      }
    }

  }

  Future stop() async{
    setState(() {
      isSpeaking = false;
    });
    var result=  await _flutterTts.stop();
    if(result==1){
      setState(() {
        _ttsState=TtsState.stopped;
      });
    }

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

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 1.5, size.width, 0);
    path.quadraticBezierTo(size.width / 2, -size.height / 1.5, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class CurvePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 1.5, size.width, 0);
    path.quadraticBezierTo(size.width / 2, -size.height / 1.5, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}








