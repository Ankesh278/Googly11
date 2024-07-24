import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/bottom_navigation_bar/account.dart';
import 'package:world11/bottom_navigation_bar/bottom_navigation_screen.dart';
import '../Model/BonusCash_Model/BonusCashResponse.dart';
import '../Model/WalletModel/Data.dart';
import '../Model/WalletModel/WallelModelData.dart';
import '../resourses/Image_Assets/image_assets.dart';
import 'VipPaas.dart';
import 'package:http/http.dart' as http;

class BonusCash extends StatefulWidget {
  const BonusCash({super.key});

  @override
  State<BonusCash> createState() => _BonusCashState();
}

class _BonusCashState extends State<BonusCash> {
  String? _email;
  String? _userName;
  String _token='';
  WalletResponseData? walletResponseData;
  BonusCashResponse? bonusCashResponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }
  Future<void> getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
   // String? userPhoto=prefs.getString("user_photo");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
      getUserWalletData(_token);
      getBonusDetails(_token);
    });
    print("email:::::::::"+_email.toString());
    print("user_id"+_userName.toString());
  }

  Future<WalletResponseData?> getUserWalletData(String _token) async {
    final String apiUrl = 'https://admin.googly11.in/api/user-wallte';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    print('Error: ${response.statusCode}');
    print('Wallet data::::::: ${response.body}');
    if (response.statusCode == 200) {
      WallelModelData wallelModelData=WallelModelData.fromJson(json.decode(response.body));
      if(wallelModelData.status==1){
        setState(() {
          walletResponseData=wallelModelData.data;
        });
        return wallelModelData.data;
      }
      print('Response data: ${response.body}');
    } else if(response.statusCode == 401){
      WallelModelData wallelModelData=WallelModelData.fromJson(json.decode(response.body));
      if(wallelModelData.status==0){
        return wallelModelData.data;
      }
      print('Error: ${response.statusCode}');
    }
    return null;
  }
  Future<BonusCashResponse?> getBonusDetails(String _token) async {
    final String apiUrl = 'https://admin.googly11.in/api/bonus-details';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    print('Error: ${response.statusCode}');
    print('Wallet data::::::: ${response.body}');
    if (response.statusCode == 200) {
      BonusCashResponse wallelModelData=BonusCashResponse.fromJson(json.decode(response.body));
      if(wallelModelData.status==1){
        setState(() {
          bonusCashResponse=wallelModelData;
        });
        return wallelModelData;
      }
      print('Response data: ${response.body}');
    } else if(response.statusCode == 401){
      BonusCashResponse wallelModelData=BonusCashResponse.fromJson(json.decode(response.body));
      if(wallelModelData.status==0){
        setState(() {
          bonusCashResponse=wallelModelData;
        });
        return wallelModelData;
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bonus Point',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body:SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                height: 40,
                color: Colors.black87,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        height: 25,
                        width: 25,
                        image: AssetImage(ImageAssets.income)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "1 Bonus Point = ₹ 1 * ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10),
                child: Container(
                  width: double.infinity,
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hey! ${_userName != null ? _userName :"Abcd@123"}",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "let's start earning Bonus Point",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> VipPassScreen()));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 70,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                width: 100,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color:  Color(0xFFAD951A),
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft:Radius.circular(6),
                                                    bottomRight: Radius.circular(6)
                                                  )
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Bonus Point",
                                                    style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              bonusCashResponse != null
                                                  ? " ${bonusCashResponse!.currentBonusAmount} /₹ ${bonusCashResponse!.totalDeposits}"
                                                  : "0", // If bonusCashResponse is null, display an empty string
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
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
                      Text(
                        "my balance",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          " ${walletResponseData != null ? walletResponseData!.bonusBalance : "00"}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Image(
                              height: 20,
                              width: 20,
                              image: AssetImage(ImageAssets.income)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Bonus Point",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),


                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF0C1AAD),
                              ),
                              child: Center(
                                child: Text("View account details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: (){

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Account()),
                                  //,
                            );

                        }

                        ,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right : 18,top : 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40.0),
                                  bottomRight: Radius.circular(40.0),
                                ),
                              ),
                              child: Container(
                                width: 140,
                                height: 90,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "5 %",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Discount*",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "on contest Joins",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Save Your Money",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "by using Bonus Point",
                                style: TextStyle(
                                  fontSize: 11,
                                  color:  Color(0xFFAD951A),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18,top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Text(
                              "*VIP users get 15% off on contest joins",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        InkWell(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                              width: 80,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text("Play now",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,top: 15,bottom: 5),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child:  Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bonus Point",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "spend ₹1500 on contests to  get Bonus benefits",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                color:Color(0xFFF2EFAC),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(ImageAssets.win),
                      height: 75,
                      width: 75,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enjoy Bonus benefit by playing for",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "₹1500 In a month",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              bonusCashResponse != null
                                  ? "₹ ${bonusCashResponse!.currentBonusAmount} /₹ ${bonusCashResponse!.totalDeposits}"
                                  : "0",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> VipPassScreen()));
                                },
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all( color: Color(0xFF0C1AAD),width: 1),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text("Know more",
                                      style: TextStyle(
                                        color: Color(0xFF0C1AAD),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ) ,
    );
  }
}
