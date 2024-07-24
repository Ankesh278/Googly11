import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Model/EmailUpdateModel/EmailOtpSend.dart';
//import '../Model/UpdateMobile_Number/Update_Mobile_number.dart';
import 'AddEmail_SendOtp.dart';

class AddEmailAddress extends StatefulWidget {
  const AddEmailAddress({super.key});

  @override
  State<AddEmailAddress> createState() => _AddEmailAddressState();
}
class _AddEmailAddressState extends State<AddEmailAddress> {
  TextEditingController emailController=TextEditingController();
  TextEditingController ConfirmEmailController=TextEditingController();
  String searchResult = '';
  String searchResult2 = '';
  bool isSearching = false;
  String _token='';

  static final RegExp emailRegex = RegExp(
    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    setState(() {
      _token=token!;
    });
  }

  void searchUserByEmail(String Email,String token) async {
    setState(() {
      isSearching = true;
    });
    print("phone"+Email);
    final String apiUrl = 'https://admin.googly11.in/api/send_email_otp_update';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: {
          'email': Email,
        },
      );

      if (response.statusCode == 200) {
        EmailOtpSend updateMobileNumber=EmailOtpSend.fromJson(json.decode(response.body));
        if(updateMobileNumber.status== 1){
          setState(() {
            searchResult = updateMobileNumber.message!;
            isSearching = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=> EmailChange_Otp(Mobile_number: emailController.text,)));
        } else if(updateMobileNumber.status == 0){
          setState(() {
            searchResult2 = updateMobileNumber.message!;
            Fluttertoast.showToast(msg: "${updateMobileNumber.message!}",textColor: Colors.white,backgroundColor: Colors.black);
            isSearching = false;
          });
        }
      } if (response.statusCode == 401) {
        EmailOtpSend updateMobileNumber=EmailOtpSend.fromJson(json.decode(response.body));
        if(updateMobileNumber.status== 1){
          setState(() {
            Fluttertoast.showToast(msg: "${updateMobileNumber.message!}",textColor: Colors.white,backgroundColor: Colors.black);
            searchResult = updateMobileNumber.message!;
            isSearching = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=> EmailChange_Otp(Mobile_number: emailController.text,)));
        } else if(updateMobileNumber.status == 0){
          setState(() {
            Fluttertoast.showToast(msg: "${updateMobileNumber.message!}",textColor: Colors.white,backgroundColor: Colors.black);
            searchResult2 = updateMobileNumber.message!;
            isSearching = false;
          });
        }
      } else {
        // Handle the error
        print('Error: ${response.statusCode}');
        print('Error: ${response.body}');
        setState(() {
          isSearching = false;
        });
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 20),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Add Email Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.2,
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Email Address :",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  bottom: 16, top: 0, left: 5, right: 5),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Confirm Email Address :",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 30,
                          width: 250,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: ConfirmEmailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  bottom: 16, top: 0, left: 5, right: 5),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate email
                            if (!_validateEmail(emailController.text)) {
                              Fluttertoast.showToast(msg: "Please enter a valid email address",textColor: Colors.white,backgroundColor: Colors.black);
                              return;
                            }
                            if (emailController.text != ConfirmEmailController.text) {
                              // Email and confirm email do not match
                              Fluttertoast.showToast(msg: "Email and Confirm Email do not match",textColor: Colors.white,backgroundColor: Colors.black);
                              return;
                            }
                            searchUserByEmail(emailController.text, _token);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: isSearching ? Center(
                              child:  SpinKitFadingCircle(color: Colors.white,)
                          ):
                          Text("Submit",style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    return emailRegex.hasMatch(email);
  }
}
