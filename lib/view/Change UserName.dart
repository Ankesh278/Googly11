import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
//
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:world11/bottom_navigation_bar/account.dart';
import 'package:world11/bottom_navigation_bar/bottom_navigation_screen.dart';

import '../Model/ChangeUserName/Change_UserName.dart';
import '../Model/UserAllData/GetUserAllData.dart';
class ChangeUserName extends StatefulWidget {
  var oldUserName;
  ChangeUserName({super.key,required this.oldUserName});

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {

  TextEditingController textEditingController=TextEditingController();
  TextEditingController textEditingController2=TextEditingController();
  String searchResult = '';
  String searchResult2 = '';
  bool isSearching = false;
  String message='';
  String UserName='';
  String _token='';


  @override
  void initState() {
    super.initState();
    getPrefrenceData();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    // String? userPhoto=prefs.getString("user_photo");
    String? token=prefs.getString("token");
    setState(() {
      UserName=userName!;
      _token=token!;
      fetchUserAllData(token.toString());
    });
    // print("email"+_email.toString());
    print("user_id"+UserName.toString());
    print("Token_id"+token.toString());
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
        GetUserAllData userAllData=GetUserAllData.fromJson(jsonDecode(response.body));
        if(userAllData.status==1){
          setState(() async{
            UserName=userAllData.user!.name;
            SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            sharedPreferences.setString("UserName",userAllData.user!.userName);
          });
          var responseData = jsonDecode(response.body);
          print('API call successful');
          print('Response: $responseData');
        }

      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Token not found",textColor: Colors.red);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      }   else if(response.statusCode==400){
        Fluttertoast.showToast(msg: "User not found",textColor: Colors.red);
      }
    } catch (e) {
      // Handle exceptions
      print('Error making API call: $e');
    }
  }


  Future<void> searchUserName(String userName) async {
    setState(() {
      isSearching = true;
    });

    final String apiUrl = 'https://admin.googly11.in/api/search_user_name';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: {
          'user_name': userName,
        },
      );

      if (response.statusCode == 200) {
        ChangeUserNameResponse changeUserName=ChangeUserNameResponse.fromJson(jsonDecode(response.body));
        if(changeUserName.status==1 ){
          setState(() {
            searchResult = changeUserName.message;
            isSearching = false;
          });
        } else if(changeUserName.status ==0){
          setState(() {
            searchResult2 = changeUserName.message;
            isSearching = false;
          });
        }

      } else {
        // Handle error cases
        print('Error: ${response.statusCode}, ${response.reasonPhrase}');
        setState(() {
          isSearching = false;
        });
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18,right: 18,top: 20),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Change Username",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                Divider(height: 10,color: Colors.grey,),

                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Stack(
                    children:[
                      Container(
                      height: size.height *0.75,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFDFE6E0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Change your username here",
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.65,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Username you had requested for was not "
                                        "available. To change your username, enter new "
                                        "username below.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text("Please note that you can change your "
                                          "username only once",
                                        style: TextStyle(
                                          color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      child: Text("Old Username : ${widget.oldUserName}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("New Username :",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        height: 30,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.2,
                                          ),
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: TextField(
                                          onChanged: (userName){
                                            if(textEditingController.text.length ==8){
                                              searchResult='';
                                              searchResult2='';
                                              searchUserName(userName);
                                            }
                                        },
                                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                                          controller: textEditingController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none, // Remove the underline
                                            contentPadding: EdgeInsets.only(
                                                bottom: 16,top: 0,left: 5,right: 5
                                            ), // Adjust padding as needed
                                            alignLabelWithHint: true, // Center the hint text
                                          ),
                                        ),
                                      ),
                                    ),
                                    isSearching
                                        ? Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ))
                                        : Align(
                                      alignment: Alignment.topLeft,
                                        child: Text(
                                          searchResult,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )
                                    ),
                                    isSearching
                                        ? Center(child: Text(''
                                        ''))
                                        : Align(
                                      alignment: Alignment.topLeft,
                                        child: Text(
                                          searchResult2,
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Confirm Username :",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        height: 30,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.2,
                                            ),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: TextField(
                                          inputFormatters: [LengthLimitingTextInputFormatter(8)],
                                          controller: textEditingController2,
                                          decoration: InputDecoration(
                                            border: InputBorder.none, // Remove the underline
                                            contentPadding: EdgeInsets.only(
                                                bottom: 16,top: 0,left: 5,right: 5
                                            ), // Adjust padding as needed
                                            alignLabelWithHint: true, // Center the hint text
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if(textEditingController.text != textEditingController2.text){
                                            Fluttertoast.showToast(msg: "Please Enter same name",textColor: Colors.white,backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT);
                                          }else if(textEditingController.text.length !=8 && textEditingController2.text.length != 8 ){
                                            Fluttertoast.showToast(msg: "User name at least 8 char",textColor: Colors.white,backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT);
                                          } else{
                                            _callAPI(textEditingController.text, textEditingController2.text);
                                          }

                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Change to your desired color
                                        ),
                                        child: Text("Submit"),
                                      ),
                                    )

                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                    ),

                    ]
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callAPI(String userName,String confirmUserName) async {
    String apiUrl = 'https://admin.googly11.in/api/change_user_name';
    // String token =
    //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxMyIsImp0aSI6ImQ4ZWE2NGQ5MGI0NjVkNDNkMjRmYzkwYzI1NzkzYThkNzBhZjQyYTQ5MjFkOWUxNmExMmUyNGZlYzgxNjE2MjE2ZDg5ZmEwMGQ1OTE1YjkyIiwiaWF0IjoxNzAxNTE3OTc3Ljg0ODA5MDg4NzA2OTcwMjE0ODQzNzUsIm5iZiI6MTcwMTUxNzk3Ny44NDgwOTMwMzI4MzY5MTQwNjI1LCJleHAiOjE3MzMxNDAzNzcuODM5ODI4MDE0MzczNzc5Mjk2ODc1LCJzdWIiOiIxMyIsInNjb3BlcyI6W119.Qr-5SgfTibh-h2lYgHRFOKQtILRW0UXT-goEmfkZ2G-rG-oujcDXHj7-blKj77zNsmPFgvvrSAGG18U1JihnujGt4cO-OnqagDjJe2y1-xM0Sl-jWhvgDX9D6trCXLr_fFt2rZoZvl70e3XkcZuVfSqFkZI6cqMV6SDLdsv-TeX-aLUhttFnvBlor9K1dkpAi8OEicxUHcs1EjfEIepLS76Yaln62Q-rwXPiLyZfK4rwwzz8Hl4rQwm7pQupfPGpzVwkTkuXNUreuiId0Y3A-gTojV1sZyOFFqQbp9-vQhIjxDE7BQLrIi8jp_SaOrnuEppDLSljX-638v0pksm8eXD0ekF0h4y84HfJmBwVB8YBmfL5KRm3rBeML3XfMzs5rpI7C5ljjQcL-7uguGYaqUHwExMumPaaqUHe9ocbJgKCn0deXor9p1zDBOM9VN6bOXDqRObYJ8oi18PV_6mq6zxf-ydSVe-roRkmRRtav6aSbFCP90fau4qHqKrhvA6m1OtB4--IC-vOoOU6j64w6Z3WPe38AbiODEzy90qEXqyxtBRO0pLYgW3_rYs526Uzn6YZwCPmokI9tfpSbJikfgCfwvz9Gyvhg-R7WJWYCUClE9PXbjCoa5peEFb7-mligdpuaL2fN8tT9qPSbtK6v8Vugowyc3coO4T79ZBhiL8';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    Map<String, String> body = {
      'user_name': userName,
      'conform_user_name': confirmUserName,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        ChangeUserNameResponse changeUserName=ChangeUserNameResponse.fromJson(jsonDecode(response.body));
        if(changeUserName.status==1 ){
          setState(() {
            Fluttertoast.showToast(msg: "User Name updated successfully",textColor: Colors.white,backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT);
            UserName = changeUserName.new_user_name;
            Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
          });
        } else if(changeUserName.status ==0){
          setState(() {
            searchResult2 = changeUserName.message;
            isSearching = false;
          });
        }
        print('API Response: ${response.body}');
        // Handle the success response
      } else if(response.statusCode ==422) {
        ChangeUserNameResponse changeUserName=ChangeUserNameResponse.fromJson(jsonDecode(response.body));
        message=changeUserName.message;
      }else{
        print('API Error: ${response.statusCode}');
        // Handle the error response
      }
    } catch (e) {
      print('Exception during API call: $e');
      // Handle exceptions
    }
  }
}
