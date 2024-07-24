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

class EmailChange_Otp extends StatefulWidget {
  var Mobile_number;
  EmailChange_Otp({Key? key, this.Mobile_number}) : super(key: key);

  @override
  State<EmailChange_Otp> createState() =>  Email_Otp();
}

class Email_Otp extends State<EmailChange_Otp> {

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
  Future<void> submitOtp( String otp,String token) async {
    final String apiUrl = 'https://admin.googly11.in/api/update_Email_Otp_Verify';
    final Map<String, String> headers = {
      'Accept':'application/json',
      'Authorization':'Bearer $token'
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
        Fluttertoast.showToast(msg: "Email  change successful",textColor: Colors.green,backgroundColor: Colors.white,fontSize: 13);
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
    //var code = '';
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
                  'Enter the OTP sent to your Email: ${widget.Mobile_number.substring(0, 2)}******@gmail.com',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                Pinput(
                  onChanged: (value){
                   // code = value;
                  },
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.phone,
                ),



                SizedBox(height: size.height *.3,),

                InkWell(
                  onTap: () async{
                    if(_otpController.text.isNotEmpty && _otpController.text.length == 6){
                      submitOtp(_otpController.text,_token);
                    }else{
                      Fluttertoast.showToast(msg: "Please enter six digit otp ",textColor: Colors.white,backgroundColor: Colors.black);
                    }

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
}