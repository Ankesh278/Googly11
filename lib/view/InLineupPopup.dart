import 'package:flutter/material.dart';
import '../Model/PlayersTeamCreationResponse/PlayersData.dart';
import '../resourses/Image_Assets/image_assets.dart';
typedef RemoveUnannouncedPlayersCallback = void Function(List<PlayersData_> unannouncedPlayers);
class InLineupPopupClass extends StatefulWidget {
  var team1_id,team2_id,text1,text2;
  List<PlayersData_> Wk_PlayersData=[];
  List<PlayersData_> Bat_PlayersData=[];
  List<PlayersData_> Ar_PlayersData=[];
  List<PlayersData_> Bowl_PlayersData=[];
  final RemoveUnannouncedPlayersCallback onRemoveUnannouncedPlayers;
  InLineupPopupClass({super.key,
    this.team1_id,this.team2_id,this.text1,this.text2,required this.Wk_PlayersData,required this.Ar_PlayersData,
    required this.Bat_PlayersData,required this.Bowl_PlayersData,
    required this.onRemoveUnannouncedPlayers,
  });

  @override
  State<InLineupPopupClass> createState() => _InLineupPopupClassState();
}

class _InLineupPopupClassState extends State<InLineupPopupClass> {
  List<PlayersData_> AllData = [];

  List<String> selectedTeamIDs = [];

  @override
  void initState() {
    super.initState();
    AllData=widget.Bowl_PlayersData+widget.Bat_PlayersData+widget.Ar_PlayersData+widget.Wk_PlayersData;
    selectedTeamIDs = AllData.map((player) => player.playerId.toString()).toList();
    print("team_Name"+widget.text1+widget.team1_id+":::::"+widget.text2+widget.team2_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      "${AllData.length} of your players unannounced!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 280,
                  width: double.infinity,
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final event = AllData[index];
                            print("team_Name"+widget.text1+widget.team1_id+":::::"+event.playingTeamId.toString()+"::::::");
                            return  Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(event.image),
                                      ),
                                      Container(
                                        height: 15,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: event.playingTeamId != null
                                              ? widget.team1_id.toString() == event.playingTeamId.toString()
                                              ? Colors.black // Set color for team1_id match
                                              : Colors.grey[500] // Set color for other team
                                              : Colors.amberAccent, // Default color if playing_team_id is null
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            event.playingTeamId != null
                                                ? widget.team1_id.toString() == event.playingTeamId.toString()
                                                ? "${widget.text1}"
                                                : "${widget.text2}"
                                                : "NA",
                                            style: TextStyle(
                                              color: event.playingTeamId != null
                                                  ? widget.team1_id.toString() == event.playingTeamId.toString()
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
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.nickName.length > 13 ? '${event.nickName.substring(0, 13)}...' : event.nickName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          if (event.isPlay == 0)
                                            Row(
                                              children: [
                                                Image(image: AssetImage(ImageAssets.red_tic),height: 10,width: 10,),
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
                                          Text(
                                            "Sel by ${event.byuser}%",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Checkbox(
                                        value: selectedTeamIDs.contains(event.playerId.toString()),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              selectedTeamIDs.add(event.playerId.toString());
                                            } else {
                                              selectedTeamIDs.remove(event.playerId.toString());
                                            }
                                            // Update the value of the checkbox based on the selectedTeamIDs list
                                            // This ensures that the checkbox reflects the current selection state
                                            // of the player
                                            value = selectedTeamIDs.contains(event.playerId.toString());
                                            print("selectedTeamIDs: $selectedTeamIDs");
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: AllData.length,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    List<PlayersData_> unannouncedPlayers = AllData.where((player) => player.isPlay == 0).toList();
                    // Call the function from the parent widget to remove unannounced players and update credits
                    widget.onRemoveUnannouncedPlayers(unannouncedPlayers);
                    // Call the function from the parent widget to remove players from selected list
                    // Close the popup
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black,)
                      ),
                      child: Center(
                          child: Text(
                            "REMOVE ${AllData.length} UNANNOUNCED PLAYERS",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}

