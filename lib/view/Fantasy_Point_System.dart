import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/FantacyPointsModel/Categories.dart';
import '../Model/FantacyPointsModel/FantacyPointsSystem.dart';
import '../Model/FantacyPointsModel/MatchTypes.dart';
import '../Model/FantacyPointsModel/Points.dart';

class FantasyPointSystem extends StatefulWidget {
  const FantasyPointSystem({Key? key}) : super(key: key);

  @override
  State<FantasyPointSystem> createState() => _FantasyPointSystemState();
}

class _FantasyPointSystemState extends State<FantasyPointSystem>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _token = '';
  List<Categories> T20cat=[];
  List<Categories> IPLcat=[];
  List<Categories> ODIcat=[];
  List<Categories> TestCat=[];
  List<Categories> T10cat=[];
  List<Categories> The_hundred=[];
  Future<List<MatchTypes>?>? match_Data;
  @override

  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getPrefrenceData();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;
      match_Data=  fetchData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<MatchTypes>?> fetchData() async {
    final String apiUrl = "https://admin.googly11.in/api/match-points-get";
    final String token = _token;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Response: ${response.body}');
    print('Response: ${response}');
    if (response.statusCode == 200) {
      FantasyPointsSystem contestDataClass = FantasyPointsSystem.fromJson(json.decode(response.body));
      if(contestDataClass.status==1){
        print('Response: ${response.body}');
        for (int i = 0; i < contestDataClass.matchTypes!.length; i++) {
          switch (contestDataClass.matchTypes![i].name) {
            case "T20":
              T20cat.addAll(contestDataClass.matchTypes![i].categories);
              break;
            case "IPL":
              IPLcat.addAll(contestDataClass.matchTypes![i].categories);
              break;
            case "OD":
              ODIcat.addAll(contestDataClass.matchTypes![i].categories);
              break;
            case "Test":
              TestCat.addAll(contestDataClass.matchTypes![i].categories);
              break;
            case "T10":
              T10cat.addAll(contestDataClass.matchTypes![i].categories);
              break;
            case "The Hundred":
              The_hundred.addAll(contestDataClass.matchTypes![i].categories);
              break;
            default:
          }
        }

        return contestDataClass.matchTypes;
      }else{
        print('Response: ${response.body}');
        return contestDataClass.matchTypes;
      }
    } else if (response.statusCode == 400) {
      FantasyPointsSystem contestDataClass = FantasyPointsSystem.fromJson(json.decode(response.body));
      if(contestDataClass.status==1){
        print('Response: ${response.body}');
        return contestDataClass.matchTypes;
      }else{
        print('Response: ${response.body}');
        return contestDataClass.matchTypes;
      }
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Points'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 15, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fantasy Point System".tr,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Are you just getting started".tr,
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.03,
                      color: Colors.white,
                      child: TabBar(
                        labelColor: Colors.white,
                        indicatorColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: _tabController,
                        unselectedLabelColor: Colors.black,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF880E4F), Color(0xFF2F33D0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tabs: const [
                          Tab(
                            text: 'T20',
                          ),
                          Tab(
                            text: 'IPL',
                          ),
                          Tab(
                            text: 'ODI',
                          ),
                          Tab(
                            text: 'TEST',
                          ),
                          Tab(
                            text: 'T10',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        FutureBuilder<List<MatchTypes>?>(
                          future: match_Data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (T20cat == null || T20cat.isEmpty) {
                                return Center(child: Text('No Response from server'));
                              }
                              // Build the ListView using the data from the snapshot
                              return ListView.builder(
                                itemCount: T20cat.length,
                                itemBuilder: (context, index) {
                                  if (index >= 0 && index < T20cat.length) {
                                    final event = T20cat[index];
                                    return Column(
                                      children: [
                                        ExpansionPanelListDemo(
                                          leadingIcon: Icon(Icons.sports_cricket, color: Colors.black),
                                          title: event.categoryName,
                                          points: event.points,
                                        ),
                                        Divider(color: Colors.grey, height: 1.5),
                                      ],
                                    );
                                  } else {
                                    return Container(); // Return an empty container or handle out-of-range index case
                                  }
                                },
                              );
                            }
                          },
                        ),
                        FutureBuilder<List<MatchTypes>?>(
                          future: match_Data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        )); // Show a loading indicator while data is loading
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}'); // Handle error
                            } else {
                              // Build the ListView using the data from the snapshot
                              if (IPLcat == null || IPLcat.isEmpty) {
                                return Center(child: Text('No Data'));
                              }
                              return ListView.builder(
                                itemCount: IPLcat.length,
                                itemBuilder: (context,index) {
                                  final event=IPLcat[index];
                                  return  Column(
                                    children: [
                                      ExpansionPanelListDemo(
                                        leadingIcon: Icon(Icons.sports_cricket, color: Colors.black),
                                        title: event.categoryName,
                                        points: event.points,
                                      ),
                                      Divider(color: Colors.grey, height: 1.5),
                                    ],
                                  );
                                },

                              );
                            }
                          },
                        ),
                        FutureBuilder<List<MatchTypes>?>(
                          future: match_Data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        )); // Show a loading indicator while data is loading
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}'); // Handle error
                            } else {
                              // Build the ListView using the data from the snapshot
                              if (ODIcat == null || ODIcat.isEmpty) {
                                return Center(child: Text('No Data'));
                              }
                              return ListView.builder(
                                itemCount: ODIcat.length,
                                itemBuilder: (context,index) {
                                  final event=ODIcat[index];
                                  return  Column(
                                    children: [
                                      ExpansionPanelListDemo(
                                        leadingIcon: Icon(Icons.sports_cricket, color: Colors.black),
                                        title: event.categoryName,
                                        points: event.points,
                                      ),
                                      Divider(color: Colors.grey, height: 1.5),
                                    ],
                                  );
                                },

                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.rice_bowl, color: Colors.black,),
                                //   title: 'Bowling',
                                //   Runs: 'Wicket(except run-out)',
                                //   Runsvalue: '25',
                                //   Four_Bonus: 'Maiden over Bonus',
                                //   Four_BonusValue: '12',
                                //   Six_Bonus: 'LBW/Bowled Bonus',
                                //   Six_Bonus_value: '8',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.text_fields, color: Colors.black,),
                                //   title: 'Fielding',
                                //   Runs: 'Catch',
                                //   Runsvalue: '8',
                                //   Four_Bonus: '3 catch bonus',
                                //   Four_BonusValue: '4',
                                //   Six_Bonus: 'Stumping',
                                //   Six_Bonus_value: '12',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.strikethrough_s, color: Colors.black,),
                                //   title: 'Strike Rate',
                                //   Runs: 'Less than 30',
                                //   Runsvalue: '-6',
                                //   Four_Bonus: '30 to 39.99',
                                //   Four_BonusValue: '-4',
                                //   Six_Bonus: '40 to 49.99',
                                //   Six_Bonus_value: '-2',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.eco, color: Colors.black,),
                                //   title: 'Economy Rate',
                                //   Runs: 'Less than 5',
                                //   Runsvalue: '+6',
                                //   Four_Bonus: '5.00 to 5.99',
                                //   Four_BonusValue: '+4',
                                //   Six_Bonus: '6.00 to 6.99',
                                //   Six_Bonus_value: '+2',
                                // ),
                              );
                            }
                          },
                        ),
                        FutureBuilder<List<MatchTypes>?>(
                          future: match_Data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        )); // Show a loading indicator while data is loading
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}'); // Handle error
                            } else {
                              // Build the ListView using the data from the snapshot
                              if (TestCat == null || TestCat.isEmpty) {
                                return Center(child: Text('No Data'));
                              }
                              return ListView.builder(
                                itemCount: TestCat.length,
                                itemBuilder: (context,index) {
                                  final event=TestCat[index];
                                  return  Column(
                                    children: [
                                      ExpansionPanelListDemo(
                                        leadingIcon: Icon(Icons.sports_cricket, color: Colors.black),
                                        title: event.categoryName,
                                        points: event.points,
                                      ),
                                      Divider(color: Colors.grey, height: 1.5),
                                    ],
                                  );
                                },

                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.rice_bowl, color: Colors.black,),
                                //   title: 'Bowling',
                                //   Runs: 'Wicket(except run-out)',
                                //   Runsvalue: '25',
                                //   Four_Bonus: 'Maiden over Bonus',
                                //   Four_BonusValue: '12',
                                //   Six_Bonus: 'LBW/Bowled Bonus',
                                //   Six_Bonus_value: '8',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.text_fields, color: Colors.black,),
                                //   title: 'Fielding',
                                //   Runs: 'Catch',
                                //   Runsvalue: '8',
                                //   Four_Bonus: '3 catch bonus',
                                //   Four_BonusValue: '4',
                                //   Six_Bonus: 'Stumping',
                                //   Six_Bonus_value: '12',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.strikethrough_s, color: Colors.black,),
                                //   title: 'Strike Rate',
                                //   Runs: 'Less than 30',
                                //   Runsvalue: '-6',
                                //   Four_Bonus: '30 to 39.99',
                                //   Four_BonusValue: '-4',
                                //   Six_Bonus: '40 to 49.99',
                                //   Six_Bonus_value: '-2',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.eco, color: Colors.black,),
                                //   title: 'Economy Rate',
                                //   Runs: 'Less than 5',
                                //   Runsvalue: '+6',
                                //   Four_Bonus: '5.00 to 5.99',
                                //   Four_BonusValue: '+4',
                                //   Six_Bonus: '6.00 to 6.99',
                                //   Six_Bonus_value: '+2',
                                // ),
                              );
                            }
                          },
                        ),
                        FutureBuilder<List<MatchTypes>?>(
                          future: match_Data,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        )); // Show a loading indicator while data is loading
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}'); // Handle error
                            } else {
                              // Build the ListView using the data from the snapshot
                              if (T10cat == null || T10cat.isEmpty) {
                                return Center(child: Text('No Data'));
                              }
                              return ListView.builder(
                                itemCount: T10cat.length,
                                itemBuilder: (context,index) {
                                  final event=T10cat[index];
                                  return  Column(
                                    children: [
                                      ExpansionPanelListDemo(
                                        leadingIcon: Icon(Icons.sports_cricket, color: Colors.black),
                                        title: event.categoryName,
                                        points: event.points,
                                      ),
                                      Divider(color: Colors.grey, height: 1.5),
                                    ],
                                  );
                                },

                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.rice_bowl, color: Colors.black,),
                                //   title: 'Bowling',
                                //   Runs: 'Wicket(except run-out)',
                                //   Runsvalue: '25',
                                //   Four_Bonus: 'Maiden over Bonus',
                                //   Four_BonusValue: '12',
                                //   Six_Bonus: 'LBW/Bowled Bonus',
                                //   Six_Bonus_value: '8',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.text_fields, color: Colors.black,),
                                //   title: 'Fielding',
                                //   Runs: 'Catch',
                                //   Runsvalue: '8',
                                //   Four_Bonus: '3 catch bonus',
                                //   Four_BonusValue: '4',
                                //   Six_Bonus: 'Stumping',
                                //   Six_Bonus_value: '12',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.strikethrough_s, color: Colors.black,),
                                //   title: 'Strike Rate',
                                //   Runs: 'Less than 30',
                                //   Runsvalue: '-6',
                                //   Four_Bonus: '30 to 39.99',
                                //   Four_BonusValue: '-4',
                                //   Six_Bonus: '40 to 49.99',
                                //   Six_Bonus_value: '-2',
                                // ),
                                // Divider(color: Colors.grey, height: 1.5),
                                // ExpansionPanelListDemo(
                                //   leadingIcon: Icon(
                                //     Icons.eco, color: Colors.black,),
                                //   title: 'Economy Rate',
                                //   Runs: 'Less than 5',
                                //   Runsvalue: '+6',
                                //   Four_Bonus: '5.00 to 5.99',
                                //   Four_BonusValue: '+4',
                                //   Six_Bonus: '6.00 to 6.99',
                                //   Six_Bonus_value: '+2',
                                // ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            // Container(
            //     height: 25,
            //     width: double.infinity,
            //     child: Text(
            //       'Points to Remember'.tr,
            //       style: TextStyle(color: Colors.black,
            //           fontWeight: FontWeight.w600,
            //           fontSize: 16),
            //     )
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '.',
            //       style: TextStyle(color: Colors.black,
            //           fontWeight: FontWeight.w800,
            //           fontSize: 18),
            //     ),
            //     Text(
            //       'The New Point System'.tr,
            //       style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            //     )
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '.',
            //       style: TextStyle(color: Colors.black,
            //           fontWeight: FontWeight.w800,
            //           fontSize: 18),
            //     ),
            //     Text(
            //       'Line-up is public information'.tr,
            //       style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
class ExpansionPanelListDemo extends StatefulWidget {
  final Icon leadingIcon;
  final String title;
  final List<Points>? points;

  ExpansionPanelListDemo({
    required this.leadingIcon,
    required this.title,
    required this.points,
  });

  @override
  _ExpansionPanelListDemoState createState() => _ExpansionPanelListDemoState();
}

class _ExpansionPanelListDemoState extends State<ExpansionPanelListDemo> {
  bool _isExpanded = false; // Track expansion state of the current panel

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle expansion state
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: widget.leadingIcon,
              title: Text(widget.title),
            );
          },
          body: Column(
            children: _isExpanded && widget.points != null
                ? widget.points!.map<Widget>((point) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(
                      color: Colors.grey, // Specify the color of the border
                      width: 1.0,         // Specify the width of the border
                    ),)
                  ),
                  child: ListTile(
                    title: Text(
                      point.pointName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      '${point.value > 0 ? '+' : ''}${point.value}',
                      style: TextStyle(
                        color: point.value > 0 ? Colors.green : Colors.red,fontSize: 13
                      ),
                    ),
                  ),
                ),
              );
            }).toList()
                : [], // Generate ListTile for each point
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}


