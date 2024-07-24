import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/Players_Data_Store/PlayersData_response.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
// import '../App_Widgets/PlayerPrefrences.dart';
// import '../Model/PlayersTeamCreateData/PlayersData.dart';
import 'package:http/http.dart' as http;
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
// import 'create_your_team/createTeam.dart';
import 'create_your_team/create_contest.dart';

class UpdateSaveTeam extends StatefulWidget {
  final List<PlayersData_> batsmen;
  final List<PlayersData_> bowlers;
  final List<PlayersData_> wicketkeeper;
  final List<PlayersData_> allrounders;
  double credits_left=0.0;
  int Team_Id;
  var match_id, time_hours,logo1,logo2,text1,text2 ,team1_id,team2_id ,captain_id,vice_captain_Id,selected_captain_Name,selected_Vice_captain_Name, HighestScore , Average_Score;
  UpdateSaveTeam({required this.batsmen,required this.bowlers,required this.allrounders,required this.wicketkeeper,
    required this.credits_left,this.match_id,this.time_hours,this.text2,this.text1,this.logo1,this.logo2,this.team1_id,this.team2_id,
    required this.Team_Id ,this.vice_captain_Id,this.captain_id,this.selected_captain_Name,this.selected_Vice_captain_Name,this.Average_Score,this.HighestScore
  });
  @override
  State<UpdateSaveTeam> createState() => _Save_TeamState();
}

class _Save_TeamState extends State<UpdateSaveTeam> {

  List<bool>? isClickedC ; // List to track C button clicks
  List<bool>? isClickedVC ;// List to track VC button clicks
  String selectedCaptainName = ''; // Store selected captain's name
  String selectedViceCaptainName = ''; // Store selected vice captain's name
  int selectedCaptainIndex = -1; // Store the selected captain index
  int selectedViceCaptainIndex = -1; // Store the selected vice captain index
  late List<PlayersData_> players = widget.wicketkeeper+widget.batsmen+widget.allrounders+widget.bowlers;
  String? _email;
  String? _userName;
  String _token='';
  @override
  void initState() {
    super.initState();
    isClickedC = List.generate(25, (index) => false);
    isClickedVC = List.generate(25, (index) => false);
    selectedCaptainName=widget.selected_captain_Name;
    selectedViceCaptainName=widget.selected_Vice_captain_Name;
    for(int i=0;i<players.length;i++){
      if(widget.captain_id==players[i].playerId){
        selectedCaptainIndex=i;
        isClickedC![i]=true;
      }
      if(widget.vice_captain_Id== players[i].playerId){
        selectedViceCaptainIndex=i;
        isClickedVC![i]=true;
      }
    }
    getPrefrenceData();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    //String? userPhoto=prefs.getString("user_photo");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
    });
    print("email"+_email.toString());
    print("user_id"+_userName.toString());
  }
  void toggleClickC(int index, String playerName) {
    setState(() {
      if (selectedCaptainIndex != -1) {
        isClickedC![selectedCaptainIndex] = false; // Deselect the previous captain
      }

      isClickedC![index] = true; // Select the new captain
      selectedCaptainIndex = index;

      // Deselect the Vice Captain if it was the same player
      if (selectedViceCaptainIndex == index) {
        isClickedVC![index] = false;
        selectedViceCaptainName = '';
        selectedViceCaptainIndex = -1;
      }

      // Clear captain name if vice-captain was selected earlier
      if (isClickedVC![index]) {
        selectedCaptainName = '';
      } else {
        selectedCaptainName = playerName; // Store selected captain's name
      }
    });
  }

  void toggleClickVC(int index, String playerName) {
    setState(() {
      if (selectedViceCaptainIndex != -1) {
        isClickedVC![selectedViceCaptainIndex] = false; // Deselect the previous vice captain
      }

      isClickedVC![index] = true; // Select the new vice captain
      selectedViceCaptainIndex = index;

      // Deselect the Captain if it was the same player
      if (selectedCaptainIndex == index) {
        isClickedC![index] = false;
        selectedCaptainIndex = -1;
        selectedCaptainName = '';
      }

      // Clear vice-captain name if captain was selected earlier
      if (isClickedC![index]) {
        selectedViceCaptainName = '';
      } else {
        selectedViceCaptainName = playerName; // Store selected vice captain's name
      }
    });
  }


  bool isSaveButtonEnabled() {
    return selectedCaptainName.isNotEmpty && selectedViceCaptainName.isNotEmpty;
  }

  Future<void> createTeam(
      int player1, int player2, int player3, int player4, int player5, int player6, int player7, int player8, int player9, int player10,
      int player11, int match_id, int captain, int viceCaptain, int totalCreditPointsUsed,
      ) async {
    final apiUrl = 'https://admin.googly11.in/api/teams-update/${widget.Team_Id}';
    //final bearerToken = 'your_bearer_token_here';
    final body = {
      'match_id': match_id.toString(),
      'contest_id': '',
      'player_id': [player1, player2, player3, player4, player5, player6, player7, player8, player9, player10, player11].join(','), // Convert list to comma-separated string
      'captain': captain.toString(),
      'viceCaptain': viceCaptain.toString(),
      'totalCreditPointsUsed': totalCreditPointsUsed.toString(),
    };
    print('Response: ${body}');
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        // Handle successful response
        PlayersDataResponse playersDataResponse =
        PlayersDataResponse.fromJson(json.decode(response.body));

        if (playersDataResponse.status == 1) {
          Get.snackbar(
            "Your Team Updated Successfully",
            "You Pay the contest fee and join the contest",
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            backgroundColor: Colors.white,
            colorText: Colors.green[900],
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
              CreateContest(text1: widget.text1,logo1: widget.logo1,logo2: widget.logo2,
                text2: widget.text2,time_hours: widget.time_hours,match_id: widget.match_id,
                team2_Id: widget.team2_id,team1_Id: widget.team1_id,
                HighestScore: widget.HighestScore != null ? widget.HighestScore : '',
                Average_Score: widget.Average_Score != null ? widget.Average_Score : '',
              )));
        }
        print('Response: ${response.body}');
        // You can handle the response here
      } else if (response.statusCode == 400) {
        PlayersDataResponse playersDataResponse = PlayersDataResponse.fromJson(json.decode(response.body));
        if(playersDataResponse.status==0){
          Get.snackbar(
            playersDataResponse.message,
            "",
            icon: Icon(
              Icons.block,
              color: Colors.white,
            ),
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
        // Handle error status code
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // Handle request error
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff780000),
        title: Column(
          children: [
            Text(
              'Create Team'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            CountdownTimerWidget(time: widget.time_hours),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select Captain and Vice-captain".tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: selectedCaptainIndex != -1
                          ? NetworkImage(players[selectedCaptainIndex].image)
                          : AssetImage(ImageAssets.user) as ImageProvider<Object>,
                    ),
                    Container(
                      height: 20,
                      width: 75,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(
                            selectedCaptainName.length > 11
                                ? '${selectedCaptainName.substring(0, 11)}...'
                                : selectedCaptainName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,)
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Column(
                    children: [
                      Text(
                        "Captain".tr,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 11
                        ),
                      ),
                      Text(
                        "2x Points",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: selectedViceCaptainIndex != -1
                            ? NetworkImage(players[selectedViceCaptainIndex].image)
                            : AssetImage(ImageAssets.user) as ImageProvider<Object>,
                      ),
                      Container(
                        height: 20,
                        width: 75,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: Text(
                              selectedViceCaptainName.length > 11
                                  ? '${selectedViceCaptainName.substring(0, 11)}...'
                                  : selectedViceCaptainName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Vice Captain".tr,
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 11
                      ),
                    ),
                    Text(
                      "1.5x Points",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.black, // Set the color of the divider
              thickness: 0.5,        // Set the thickness of the divider
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("Team",style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                  ),
                  Icon(Icons.arrow_upward,color: Colors.black54,size: 15,),
                  Icon(Icons.arrow_downward,color: Colors.black54,size: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text("Points",style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                  ),
                  Icon(Icons.arrow_upward,color: Colors.black54,size: 15,),
                  Icon(Icons.arrow_downward,color: Colors.black54,size: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text("C %",style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                  ),
                  Icon(Icons.arrow_upward,color: Colors.black54,size: 15,),
                  Icon(Icons.arrow_downward,color: Colors.black54,size: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("VC %",style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                  ),
                  Icon(Icons.arrow_upward,color: Colors.black54,size: 15,),
                  Icon(Icons.arrow_downward,color: Colors.black54,size: 15,)
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
              thickness: 9,
            ),
            Expanded(
              child : ListView.builder(
                itemCount: players.length, // Replace with the number of items you have
                itemBuilder: (BuildContext context, int index) {

                  //print("Sel by user"+players[3].byuser.toString());
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(players[index].image)
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.black26,
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: Center(
                                            child: Text(
                                              players[index].intlTeam.length > 10
                                                  ? '${players[index].intlTeam.substring(0, 10)}...'
                                                  : players[index].intlTeam,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          players[index].nickName.length > 7
                                              ? '${players[index].nickName.substring(0, 7)}...'
                                              : players[index].nickName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),

                                        //${players[index].captionByuser} %
                                        Text(
                                          "${players[index].byuser.toString()[0]}%",

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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            toggleClickC(index,players[index].nickName);
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isClickedC![index] ? Colors.green : Colors.white,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.2,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "C",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isClickedC![index] ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${players[index].captionByuser} %",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            toggleClickVC(index,players[index].nickName);
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isClickedVC![index] ? Colors.green : Colors.white,
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.2,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "VC",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: isClickedVC![index] ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${players[index].VoiceCaptionByuser} %",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    height: size.height *0.05,
                    width: size.width *0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text('Select Substitutes'.tr,style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ),
                InkWell(
                  onTap: isSaveButtonEnabled() ? () async {


                    createTeam(players[0].playerId, players[1].playerId,
                        players[2].playerId, players[3].playerId, players[4].playerId,
                        players[5].playerId, players[6].playerId, players[7].playerId,
                        players[8].playerId, players[9].playerId, players[10].playerId,
                        int.parse(widget.match_id.toString()), players[selectedCaptainIndex].playerId, players[selectedViceCaptainIndex].playerId,
                        widget.credits_left.toInt()
                    );
                  } : null,
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: isSaveButtonEnabled() ? Color(0xff780000) : Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'Save Team'.tr,
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