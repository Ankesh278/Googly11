import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:world11/App_Widgets/Account_Overview.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import 'package:http/http.dart'as http;

import '../Model/UserAllData/GetUserAllData.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  String text = "Share this app";
  String imagePath = "assets/images/earn.png";
  String _token = '';
  String inviteCode='';
  String Invitation_Price='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }

  void getPrefrenceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    setState(() {
      _token = token!;
      fetchUserAllData(token.toString());
    });
  }

  Future<void> fetchUserAllData(String token) async {
    var apiUrl = 'https://admin.googly11.in/api/user';

    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        GetUserAllData userAllData = GetUserAllData.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          setState(() {
            inviteCode=userAllData.user!.inviteCode;
            Invitation_Price=userAllData.user!.referralAmount;
          });
          var responseData = jsonDecode(response.body);
          print('API call successful');
          print('Response: $responseData');
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Token not found", textColor: Colors.red);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "User not found", textColor: Colors.red);
      }
    } catch (e) {
      // Handle exceptions
      print('Error making API call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Invite Friends & Earn".tr,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10,top: 10),
                        child: InkWell(child: Icon(Icons.question_mark_sharp,color: Colors.white,),onTap: (){
                          Fluttertoast.showToast(
                              msg: "This Functionality is Coming soon",
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        }

                          ,

                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Invite Friends & Earn".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "₹ ${Invitation_Price.isNotEmpty && Invitation_Price != null ? Invitation_Price : "5000"}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff780000),
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(15),
                          right: Radius.circular(15)
                      )
                    ),
                    child: Center(
                      child: Text(
                        "PER FRIEND".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Image(
                    image: AssetImage(ImageAssets.invite1),
                    width: 130,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 10,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: (){
                                  inviteViaWhatsApp();
                                },
                                child: Container(
                                  width: 235,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Invite via Whatsapp".tr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: (){
                                _shareApp(context);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Icon(
                                        Icons.keyboard_control_outlined
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "How it works".tr,style: TextStyle(
                fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black
            ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150,
                  width: 80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image(
                          image: AssetImage(ImageAssets.invite2),
                          width: 80,
                          height: 80,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Invite Your Friends",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  width: 80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image(
                          image: AssetImage(ImageAssets.invite3),
                          width: 80,
                          height: 80,

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          "Friends Join & Play",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 150,
                  width: 80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Image(
                          image: AssetImage(ImageAssets.invite1),
                          width: 80,
                          height: 80,

                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                            "You Earn Rewards",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  void inviteViaWhatsApp() async {
    final String phone = ""; // Leave empty to open WhatsApp without a specific contact
    final String message = "🌟Welcome, to the Googly11 fantasy App! Prepare for the upcoming matches and let the games begin!\n\n"
        '⭐Choose an upcoming match from your favorite sport. \n\n'
        '🌟Create your team with the best players using your skills. \n\n'
        '🌟From a wide range of contests choose the one you want to join.\n\n'
        '➡A Super Welcome Offer! INSTALL & SIGN-UP TO GET ₹500 In Your Wallet Bonus\n\n'
        '➡ Greetings, fellow competitors! May your skills be sharp and your strategies cunning as you enter the realm of fantasy matches. \n\n'
        '👉🏻 Welcome to Googly11 Fantasy Games! May your weight be as sharp as your blade as you compete for honor and rewards~!" \n\n'
        "✅ Hello, you will play the cricket and more games \n\n"
        "✅ Use my referral code $inviteCode \n\n"
        "✅ Download this app at \n\n"
        "📱https://shorturl.at/cwOSX \n\n"
        "🌎 https://googly11.in/public/ \n\n";
    final String whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(message)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);


    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }



  Future<void> _shareApp(BuildContext context) async {
    final url = Uri.parse("https://admin.googly11.in/assets/appImage/shared.jpg");
    final res = await http.get(url);
    final bytes = res.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    final file = File(path);
    await file.writeAsBytes(bytes);

    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: "🌟Welcome, to the Googly11 fantasy App! Prepare for the upcoming matches and let the games begin!\n\n"
            '⭐Choose an upcoming match from your favorite sport. \n\n'
            '🌟Create your team with the best players using your skills. \n\n'
            '🌟From a wide range of contests choose the one you want to join.\n\n'
            '➡A Super Welcome Offer! INSTALL & SIGN-UP TO GET ₹500 In Your Wallet Bonus\n\n'
            '➡ Greetings, fellow competitors! May your skills be sharp and your strategies cunning as you enter the realm of fantasy matches. \n\n'
            '👉🏻 Welcome to Googly11 Fantasy Games! May your weight be as sharp as your blade as you compete for honor and rewards~!" \n\n'
            "✅ Hello, you will play the cricket and more games \n\n"
            "✅ Use my referral code $inviteCode \n\n"
            "✅ Download this app at \n\n"
            "📱https://shorturl.at/cwOSX \n\n"
            "🌎 https://googly11.in/public/ \n\n",
      );
    } catch (e) {
      print("Error: $e");
    }
  }
  // void showPanVerificationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // This makes the dialog not dismissible by tapping outside
  //     builder: (BuildContext context) {
  //       return Center(
  //         child: Container(
  //           constraints: BoxConstraints(
  //             maxWidth: 300,
  //             maxHeight: 300,
  //           ),
  //           child: Stack(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Image.asset(
  //                   'assets/images/successgif.gif',
  //                   fit: BoxFit.cover,
  //                   height: 300,
  //                   width: 300,
  //                 ),
  //               ),
  //               Positioned(
  //                 top: 16,
  //                 left: 16,
  //                 child: Text(
  //                   "Congrats!",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 24,
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 0,
  //                 left: 16,
  //                 right: 16,
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       "Your PAN verification is successful.",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 15,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     SizedBox(height: 19),
  //                     TextButton(
  //                       child: Text(
  //                         "OK",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                         Navigator.pushReplacement(
  //                           context,
  //                           MaterialPageRoute(builder: (context) => Account_Overview()),
  //                         );
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


// void _shareApp() {
  //   Share.share('Check out this cool app!'); // Replace the message with your desired content
  // }
}
