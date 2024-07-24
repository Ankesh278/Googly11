import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../resourses/Image_Assets/image_assets.dart';

class LiveTeamPreview extends StatefulWidget {
  final List<PlayersData_> batsmen;
  final List<PlayersData_> bowlers;
  final List<PlayersData_> wicketkeeper;
  final List<PlayersData_> allrounders;
  final List<String> Wk_points_Data;
  final List<String> Bat_points_Data;
  final List<String> AR_points_Data;
  final List<String> Bowl_points_Data;
  final time_hours,team1_id,team2_id;
  LiveTeamPreview({
    required this.batsmen,required this.bowlers,required this.allrounders,
    required this.wicketkeeper,required this.Wk_points_Data,required this.Bat_points_Data,
    required this.AR_points_Data,required this.Bowl_points_Data,
    required this.time_hours,required this.team1_id,required this.team2_id
  });
  @override
  State<LiveTeamPreview> createState() => _TeamPreviewState();
}

class _TeamPreviewState extends State<LiveTeamPreview> {
  late List<PlayersData_> players = widget.wicketkeeper+widget.batsmen+widget.allrounders+widget.bowlers;
  List<PlayersData_> team1_Length=[];
  List<PlayersData_> team2_Length=[];
  final _screenshotController= ScreenshotController();

  bool is_Downloading = false;

  @override
  void initState() {
    // TODO: implement initState
    for(int i=0; i<players.length; i++){

      if(widget.team1_id.toString() == players[i].playingTeamId.toString()){
        // print("playingTeamId"+players[i].playingTeamId.toString()+":::::::::::::::"+widget.team1_id);
        team1_Length.add(PlayersData_(playerId: players[i].playerId, teamId: players[i].teamId, playingTeamId: players[i].playingTeamId, imageId: players[i].imageId, roleType: players[i].roleType, bat: players[i].bat, bowl: players[i].bowl, name: players[i].name, nickName: players[i].nickName, role: players[i].role, intlTeam: players[i].intlTeam, image: players[i].image, points: players[i].points, byuser: players[i].byuser, isPlay: players[i].isPlay, captionByuser: players[i].isPlay, VoiceCaptionByuser: players[i].isPlay));
      }else  {
        // print("playingTeamId"+players[i].playingTeamId.toString()+":::::::::::::::"+widget.team2_id);
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
          widget.time_hours != null && widget.time_hours != "0" ?  CountdownTimerWidget(time: widget.time_hours,) :Text("Live",style: TextStyle(color: Colors.white),)
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        // actions: [
        //    is_Downloading
        //       ? Container(
        //          height: 20,
        //           width: 20,
        //         child:   SpinKitFadingCircle(
        //           color: Colors.redAccent,
        //           size: 50.0,
        //         )
        //       )  : IconButton(
        //     icon: Icon(Icons.download_outlined,color: Colors.white,size: 20,), // Replace 'Icons.info' with your desired icon
        //     onPressed: () {
        //       setState(() {
        //         is_Downloading = true;
        //       });
        //
        //       take_ScreenShot().then((value) {
        //         setState(() {
        //           is_Downloading = false;
        //         });
        //       });
        //     },
        //   ),
        // ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: _screenshotController,
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
                              radius: 10,
                            ),
                            SizedBox(width: 8,),
                            Text('Wicketkeeper',
                              style: TextStyle( fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for(int i=0;i<widget.wicketkeeper.length;i++)
                              player_icon(
                                  player: widget.wicketkeeper,
                                  i: i,player_type: 'wk',
                                  points_teamData: widget.Wk_points_Data,
                                  team1_Id: widget.team1_id),
                          ],
                        ),
                        SizedBox(height:5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/bat.jpg'),
                              backgroundColor: Colors.white,
                              radius: 10,
                            ),
                            SizedBox(width: 8,),
                            Text('Batsmen',
                              style: TextStyle( fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for(int i=0;i<widget.batsmen.length;i++)
                              player_icon(
                                  player: widget.batsmen,
                                  i: i,player_type: 'bat',
                                  points_teamData: widget.Bat_points_Data,
                                  team1_Id: widget.team1_id),
                          ],
                        ),

                        SizedBox(height:5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/bat_ball.jpg'),
                              backgroundColor: Colors.white,
                              radius: 10,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for(int i=0;i<widget.allrounders.length;i++)
                              player_icon(
                                  player: widget.allrounders,
                                  i: i,player_type: 'bat_ball',
                                  points_teamData: widget.AR_points_Data,
                                  team1_Id: widget.team1_id),
                          ],
                        ),

                        SizedBox(height:5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/images/ball.jpg'),
                              backgroundColor: Colors.white,
                              radius: 10,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for(int i=0;i<widget.bowlers.length;i++)
                              player_icon(
                                  player: widget.bowlers,
                                  i: i,player_type: 'ball',
                                  points_teamData: widget.Bowl_points_Data,
                                  team1_Id: widget.team1_id),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> take_ScreenShot() async {
    // Check storage permission
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus != PermissionStatus.granted) {
      // Handle if permission is not granted
      return;
    }

    // Capture the screenshot
    // You may need to adjust the pixelRatio based on your device's screen density
    Uint8List? bytes = await _screenshotController.capture(pixelRatio: 3);

    if (bytes != null) {
      // Save the screenshot to the image gallery
      await ImageGallerySaver.saveImage(bytes);
      Fluttertoast.showToast(
        msg: "Screenshot saved successfully",
        textColor: Colors.white,
        backgroundColor: Colors.black,
      );
    }
  }


}

class player_icon extends StatelessWidget {
  const player_icon({
    Key? key,
    required this.player,
    required this.i,
    required this.player_type,
    required this.points_teamData,
    required this.team1_Id
  }) : super(key: key);

  final List<PlayersData_> player;
  final List<String> points_teamData;
  final int i;
  final String player_type;
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
                    backgroundImage: NetworkImage(player[i].image)
                ),
              ),
            ),
            if(player[i].captain == 1 && player[i].captain != null)
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
            if( player[i].viceCaptain == 1 && player[i].viceCaptain != null)
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
            if (player[i].isPlay == 0)
              Positioned(
                bottom: -2.2, // Adjusted bottom position
                right: 1.5,
                child: Image(image: AssetImage(ImageAssets.RedCircle), height: 13, width: 13),
              ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
            color: player[i].playingTeamId != null
                ? team1_Id.toString() == player[i].playingTeamId.toString()
                ? Colors.black // Set color for team1_id match
                : Colors.white // Set color for other team
                : Colors.amberAccent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              player[i].nickName.length > 10
                  ? '${player[i].nickName.substring(0, 10)}..'
                  : player[i].nickName,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: player[i].playingTeamId != null
                    ? team1_Id.toString() == player[i].playingTeamId.toString()
                    ? Colors.white // Set text color for team1_id match
                    : Colors.black // Set text color for other team
                    : Colors.amberAccent,
              ),
            ),
          ),
        ),
        SizedBox(height: 3,),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            points_teamData[i].toString()+" pts",
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white // Set text color for team1_id match
            ),
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