import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../resourses/Image_Assets/image_assets.dart';

class TeamPreview extends StatefulWidget {
  final List<PlayersData_> batsmen;
  final List<PlayersData_> bowlers;
  final List<PlayersData_> wicketkeeper;
  final List<PlayersData_> allrounders;
  final Map<String,dynamic> points;
   var captain;
   var vice_captain;
   var total_points;
   var lineup = 0;
   var time_hours,team1,team2,credits_Points,team1_id,team2_id;

   TeamPreview({required this.batsmen,required this.bowlers,required this.allrounders,required this.wicketkeeper, required this.points,
    required this.time_hours,required this.team1,required this.team2,required this.credits_Points,required this.lineup,required this.team1_id,required this.team2_id
  });
  @override
  State<TeamPreview> createState() => _TeamPreviewState();
}

class _TeamPreviewState extends State<TeamPreview> {

  late List<PlayersData_> players = widget.wicketkeeper+widget.batsmen+widget.allrounders+widget.bowlers;
  List<PlayersData_> team1_Length=[];
  List<PlayersData_> team2_Length=[];
  @override
  void initState() {
    // TODO: implement initState
    for(int i=0; i<players.length; i++){
      if(widget.team1_id.toString() == players[i].playingTeamId.toString()){
        // print("playing_Team_Id"+widget.team1_id +"::::::::"+players[i].playingTeamId.toString());
        team1_Length.add(PlayersData_(playerId: players[i].playerId, teamId: players[i].teamId, playingTeamId: players[i].playingTeamId, imageId: players[i].imageId, roleType: players[i].roleType, bat: players[i].bat, bowl: players[i].bowl, name: players[i].name, nickName: players[i].nickName, role: players[i].role, intlTeam: players[i].intlTeam, image: players[i].image, points: players[i].points, byuser: players[i].byuser, isPlay: players[i].isPlay, captionByuser: players[i].isPlay, VoiceCaptionByuser: players[i].isPlay));
      }else  {
        // print("playing_Team_Id"+widget.team1_id +"::::::::"+players[i].playingTeamId.toString());
        team2_Length.add(PlayersData_(playerId: players[i].playerId, teamId: players[i].teamId, playingTeamId: players[i].playingTeamId, imageId: players[i].imageId, roleType: players[i].roleType, bat: players[i].bat, bowl: players[i].bowl, name: players[i].name, nickName: players[i].nickName, role: players[i].role, intlTeam: players[i].intlTeam, image: players[i].image, points: players[i].points, byuser: players[i].byuser, isPlay: players[i].isPlay, captionByuser: players[i].isPlay, VoiceCaptionByuser: players[i].isPlay));
      }
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xff780000),
        title: Column(
          children: [
            Text(
              'Team Preview',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            if(widget.time_hours != "" && widget.time_hours.toString().isNotEmpty)
            CountdownTimerWidget(time: widget.time_hours,)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark,color: Colors.white,), // Replace 'Icons.info' with your desired icon
            onPressed: () {
              Fluttertoast.showToast(
                  msg: "This Functionality is Coming soon",
                  backgroundColor: Colors.red,
                  textColor: Colors.white);

            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: Color(0xFF165722),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Text(
                          "Players",
                          style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${players.length}/11",
                          style: TextStyle(color: Colors.white,fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "${widget.team1}",
                              style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        Text(
                          "  ${team1_Length.length.toString()}",
                          style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child:Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "${widget.team2}",
                              style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        Text(
                          "  ${team2_Length.length.toString()}",
                          style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Text(
                          "Credits Left",
                          style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${widget.credits_Points != null ? widget.credits_Points : "0"}",
                          style: TextStyle(color: Colors.white,fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageAssets.Ground4),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/wk.jpg'),
                            backgroundColor: Colors.white,
                            radius: 7,
                          ),
                          SizedBox(width: 8,),
                          Text('Wicketkeeper',
                            style: TextStyle(fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (widget.wicketkeeper.length / 4).ceil(),
                        itemBuilder: (BuildContext context, int index) {
                          int startIndex = index * 4;
                          int endIndex = startIndex + 4;
                          if (endIndex > widget.wicketkeeper.length) {
                            endIndex = widget.wicketkeeper.length;
                          }
                          List<PlayersData_> playersForRow = widget.wicketkeeper.sublist(startIndex, endIndex);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: playersForRow.map((player) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: player_icon(
                                    player: player,
                                    i: widget.wicketkeeper.indexOf(player),
                                    player_type: 'wk',
                                    lineup: widget.lineup,
                                    team1_Id: widget.team1_id,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),




                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/bat.jpg'),
                            backgroundColor: Colors.white,
                            radius: 7,
                          ),
                          SizedBox(width: 8,),
                          Text('Batsmen',
                            style:TextStyle( fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (widget.batsmen.length / 4).ceil(),
                        itemBuilder: (BuildContext context, int index) {
                          int startIndex = index * 4;
                          int endIndex = startIndex + 4;
                          if (endIndex > widget.batsmen.length) {
                            endIndex = widget.batsmen.length;
                          }
                          List<PlayersData_> playersForRow = widget.batsmen.sublist(startIndex, endIndex);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: playersForRow.map((player) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: player_icon(
                                    player: player,
                                    i: widget.batsmen.indexOf(player),
                                    player_type: 'wk', // Adjust player type if necessary
                                    lineup: widget.lineup,
                                    team1_Id: widget.team1_id,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),



                      SizedBox(height:5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/bat_ball.jpg'),
                            backgroundColor: Colors.white,
                            radius: 7,
                          ),
                          SizedBox(width: 8,),
                          Text('All-rounders',
                            style: TextStyle(fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (widget.allrounders.length / 4).ceil(),
                        itemBuilder: (BuildContext context, int index) {
                          int startIndex = index * 4;
                          int endIndex = startIndex + 4;
                          if (endIndex > widget.allrounders.length) {
                            endIndex = widget.allrounders.length;
                          }
                          List<PlayersData_> playersForRow = widget.allrounders.sublist(startIndex, endIndex);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: playersForRow.map((player) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: player_icon(
                                    player: player,
                                    i: widget.allrounders.indexOf(player),
                                    player_type: 'wk', // Adjust player type if necessary
                                    lineup: widget.lineup,
                                    team1_Id: widget.team1_id,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),


                      SizedBox(height:5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/ball.jpg'),
                            backgroundColor: Colors.white,
                            radius: 7,
                          ),
                          SizedBox(width: 8,),
                          Text('Bowlers',
                            style: TextStyle( fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (widget.bowlers.length / 4).ceil(),
                        itemBuilder: (BuildContext context, int index) {
                          int startIndex = index * 4;
                          int endIndex = startIndex + 4;
                          if (endIndex > widget.bowlers.length) {
                            endIndex = widget.bowlers.length;
                          }
                          List<PlayersData_> playersForRow = widget.bowlers.sublist(startIndex, endIndex);

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: playersForRow.map((player) {
                              return Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: player_icon(
                                    player: player,
                                    i: widget.bowlers.indexOf(player),
                                    player_type: 'wk', // Adjust player type if necessary
                                    lineup: widget.lineup,
                                    team1_Id: widget.team1_id,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
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
  }

}
class player_icon extends StatelessWidget {
  const player_icon({
    Key? key,
    required this.player,
    required this.i,
    required this.player_type,
    required this.lineup,
    required this.team1_Id
  }) : super(key: key);

  final PlayersData_ player;
  final int i;
  final String player_type;
  final int lineup;
   final  team1_Id;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            ClipOval(
              child: Center(
                child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(player.image)
                ),
              ),
            ),
            if(player.captain == 1 && player.captain != null)
              Positioned(
                top: -2.2,
                right: 1.5,
                child: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  radius: 7,
                  child: Center(
                      child: Text('C', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10))
                  ),
                ),
              ),
            if( player.viceCaptain == 1 && player.viceCaptain != null)
              Positioned(
                top: -2.2,
                right: 1.5,
                child: CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  radius: 7,
                  child: Center(
                      child: Text('VC', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10))
                  ),
                ),
              ),
            if (player.isPlay == 1 && lineup == 1)
              Positioned(
                left : -2.2, // Adjusted bottom position
                right: 1.5,
                child: Image(image: AssetImage(ImageAssets.green_tic), height: 11, width: 11),
              ),
            if (player.isPlay == 0 && lineup == 1)
              Positioned(
                left: -2.2, // Adjusted bottom position
                right: 1.5,
                child: Image(image: AssetImage(ImageAssets.RedCircle), height: 11, width: 11),
              ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: player.playingTeamId != null
                ? team1_Id == player.playingTeamId.toString()
                ? Colors.black // Set color for team1_id match
                : Colors.white // Set color for other team
                : Colors.amberAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              player.nickName.length > 11
                  ? '${player.nickName.substring(0, 11)}...'
                  : player.nickName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: player.playingTeamId != null
                    ? team1_Id == player.playingTeamId.toString()
                    ? Colors.white // Set text color for team1_id match
                    : Colors.black // Set text color for other team
                    : Colors.amberAccent,
              ),
            ),
          ),
        ),
        SizedBox(height: 5,),
        Text(
          player.points.toString() +" Cr",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white // Set text color for team1_id match
          ),
        ),

      ],
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