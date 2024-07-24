import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';

import '../Model/Winners_Model/Data.dart';
import '../Model/Winners_Model/Winners_Model_Response.dart';


class League extends StatefulWidget {
  const League({Key? key}) : super(key: key);

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  String _token = '';
  Future<List<WinnersDataModel>?>? data_Winner;
  void getPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    setState(() {
      _token = token!;
    data_Winner=  fetchDataTransactions(_token);
    });
  }


  Future<List<WinnersDataModel>?> fetchDataTransactions(String token) async {
    final String apiUrl =
        'https://admin.googly11.in/api/top-winners';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );
      print('API Response: ${response.body}');
      print('Error: ${response.statusCode}');
      if (response.statusCode == 200) {
        WinnersModelResponse transactionHistroryModel =
        WinnersModelResponse.fromJson(json.decode(response.body));
        print('API Response::::::: ${response.body}');
        print('Error:::::: ${response.statusCode}');
        if(transactionHistroryModel != null) {
          if (transactionHistroryModel.status == 1) {
            return transactionHistroryModel.data;
          } else {
            return transactionHistroryModel.data;
          }
        }
      } else if (response.statusCode == 400) {
        WinnersModelResponse transactionHistroryModel =
        WinnersModelResponse.fromJson(json.decode(response.body));
        print('API Response::: ${response.body}');
        print('Error::: ${response.statusCode}');
        if (transactionHistroryModel.status == 1) {
          return transactionHistroryModel.data;
        } else {
          Fluttertoast.showToast(
              msg: "UnAuthenticated", textColor: Colors.redAccent);
          return transactionHistroryModel.data;
        }
      } else if (response.statusCode == 402) {
        WinnersModelResponse transactionHistroryModel =
        WinnersModelResponse.fromJson(json.decode(response.body));
        if (transactionHistroryModel.status == 1) {
          return transactionHistroryModel.data;
        } else {
          Fluttertoast.showToast(
              msg: "UnExpected Error", textColor: Colors.redAccent);
          return transactionHistroryModel.data;
        }
      }
    } catch (error) {
      print('Exception: $error');
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefrenceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Row(
          children: [
            // Winners logo or icon
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Image.asset(
                ImageAssets.win, // Replace with the path to your winners logo
                height: 30, // Adjust the height as needed
                width: 30, // Adjust the width as needed
              ),
            ),
            // Winners Speak text
            Text(
              'Top Winners',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff780000),
      ),
      body: Container(
        height: size.height,
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              child: Image.asset(
                ImageAssets.champion_logo,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<WinnersDataModel>?>(
                future:  data_Winner,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:  SpinKitFadingCircle(
                        color: Color(0xff780000),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('No Internet'+snapshot.hasError.toString());
                  } else if (!snapshot.hasData) {
                    return RefreshIndicator(
                        color: Colors.red,
                        backgroundColor: Colors.white,
                        onRefresh: () async{
                          await Future.delayed(
                            const Duration(seconds: 2),
                          );

                          setState(() {
                            data_Winner=  fetchDataTransactions(_token);
                          });
                        },
                        child: Text('No events available'));
                  } else {
                    return RefreshIndicator(
                      color: Colors.red,
                      backgroundColor: Colors.white,
                      onRefresh: () async{
                        await Future.delayed(
                          const Duration(seconds: 2),
                        );
                        setState(() {
                          data_Winner=  fetchDataTransactions(_token);
                        });
                      },
                      child:ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final event = snapshot.data![index];
                          return Container(
                            color: Color(0xff780000),
                            margin: EdgeInsets.only(top: 2,bottom: 2),
                            child: Card(
                              margin: EdgeInsets.only(left: 50,right: 50,top: 5,bottom: 5), // Adjust the margin values as needed
                              elevation: 35,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5), // Shadow color
                                          spreadRadius: 2, // Spread radius
                                          blurRadius: 5, // Blur radius
                                          offset: Offset(0, 3), // Offset in x and y direction
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],

                                    ),
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: event.userImage != null && Uri.parse(event.userImage!).isAbsolute
                                          ? NetworkImage(event.userImage!)
                                          : AssetImage(ImageAssets.user) as ImageProvider,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    "₹ ${double.parse(event.winnings.toString()).toInt()}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xff780000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    event.name.toString().isNotEmpty ? event.name.toString() : event.userName.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      "${event.team1Name} vs ${event.team2Name}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
  }
}
