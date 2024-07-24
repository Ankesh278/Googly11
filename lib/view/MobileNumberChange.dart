import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:world11/Model/Aadhar%20card%20Verify%20otp/AadharVerifyOtp.dart';
// import 'package:world11/bottom_navigation_bar/account.dart';
// import 'package:world11/view/create_your_team/adharvoteridPickup/adharvoteridPickup.dart';

import '../Model/NumberChangeOtpModel/OtpModel_Response.dart';
import '../bottom_navigation_bar/bottom_navigation_screen.dart';

class MobileChangeOtp extends StatefulWidget {
   var Mobile_number;
   MobileChangeOtp({Key? key, this.Mobile_number}) : super(key: key);

  @override
  State<MobileChangeOtp> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<MobileChangeOtp> {

  String _token='';


  Future<void> getShareprefrenceUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token").toString();
    setState(() {
      _token = token;
      print(":::::"+_token+":::::");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getShareprefrenceUserdata();
    super.initState();
  }

  final TextEditingController _otpController = TextEditingController();
  Future<void> submitOtp( String otp) async {
    final String apiUrl = 'https://admin.googly11.in/api/update_Phone_Otp_Verify';
    final Map<String, String> headers = {
      'Accept':'application/json',
      'Authorization':'Bearer $_token'
    };
    final Map<String, dynamic> body = {
      'otp': otp,
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    print("response::::"+response.body);
    print("headers::::"+body.toString());
    if(response.statusCode == 200) {
      OtpModelResponse otpModelResponse =OtpModelResponse.fromJson(json.decode(response.body));
      if(otpModelResponse.status == 1){
        Fluttertoast.showToast(msg: "Phone number change successful",textColor: Colors.green,backgroundColor: Colors.white,fontSize: 13);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
      }else{
        Fluttertoast.showToast(msg:otpModelResponse.message ,textColor: Colors.red,backgroundColor: Colors.white,fontSize: 13);
      }
    }
    else if (response.statusCode == 401) {
      OtpModelResponse otpModelResponse =OtpModelResponse.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: otpModelResponse.message,textColor: Colors.green,backgroundColor: Colors.white,fontSize: 13);
    } else {
      throw Exception('Failed to call API');
    }
  }

  @override
  Widget build(BuildContext context) {
   // var code = '';
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Otp Verification',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
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
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter the OTP sent to your mobile number', style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),

                Pinput(
                  onChanged: (value){
                    //code = value;
                  },
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.phone,
                ),



                SizedBox(height: size.height *.3,),

                InkWell(
                  onTap: () async{
                    submitOtp(_otpController.text);
                  },
                  child: Container(
                    height: size.height *0.06,
                    width: size.width *.8,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Verify',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void AadharApiDataSend_Server(String token,String name,String adharNumber,String d_o_b,String gender,
      String country,String district,
      String post,String sub_district,
      String landmark, String pincode,
      String fatherName
      )
  async {
    var apiUrl = 'https://admin.googly11.in/api/user_adhar_details';
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Your actual token here
    };
    var body = {
      'name': name,
      'adhar_number': adharNumber,
      'd_o_b': d_o_b,
      'gender': gender,
      'country': country,
      'district': district,
      'post': post,
      'sub_district': sub_district,
      'landmark': landmark,
      'pincode': pincode,
      'father_name': fatherName
    };
    print("::::::::::jsdkjhfj"+body.toString());
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('Request successful');
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
        print('Request successful');
        print('Response: ${response.body}');
      }
      else if (response.statusCode == 401) {
        print('Request failed. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        print('Request failed. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    // try {
    //   // Make the HTTP POST request
    //   final response = await http.post(
    //     Uri.parse(apiUrl),
    //     headers: headers,
    //     body: jsonEncode(body),
    //   );
    //   print('Response: ${response.body}');
    //   print('Request failed. Status code: ${response.statusCode}');
    //   // Handle the response
    //   if (response.statusCode == 200) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
    //     Navigator.of(context).pop();
    //     print('Request successful');
    //     print('Response: ${response.body}');
    //   }
    //   else if (response.statusCode == 401) {
    //     print('Request failed. Status code: ${response.statusCode}');
    //     print('Response: ${response.body}');
    //   } else if (response.statusCode == 400) {
    //     print('Request failed. Status code: ${response.statusCode}');
    //     print('Response: ${response.body}');
    //   }
    // } catch (error) {
    //   print('Error during HTTP request: $error');
    // }
  }
}