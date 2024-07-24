import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/UpdateMobile_Number/Update_Mobile_number.dart';
import 'MobileNumberChange.dart';
// import 'OtpVerifyAadhaar.dart';

class UpdateMobileNumber extends StatefulWidget {
  final appBarName;
  var mobile;
   UpdateMobileNumber({super.key,this.appBarName,this.mobile});

  @override
  State<UpdateMobileNumber> createState() => _UpdateMobileNumberState();
}

class _UpdateMobileNumberState extends State<UpdateMobileNumber> {
  TextEditingController textEditingController=TextEditingController();
  String searchResult = '';
  String searchResult2 = '';
  bool isSearching = false;
  String _token='';
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


  void searchUserByPhone(String Mob_number,String token) async {
    setState(() {
      isSearching = true;
    });
    print("phone"+Mob_number);
    final String apiUrl = 'https://admin.googly11.in/api/search_user_phone';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: {
          'phone': Mob_number,
        },
      );

      if (response.statusCode == 200) {
        UpdateMobileNumberResponse updateMobileNumber=UpdateMobileNumberResponse.fromJson(json.decode(response.body));
        if(updateMobileNumber.status== 1){
          setState(() {
            searchResult = updateMobileNumber.message;
            isSearching = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context)=> MobileChangeOtp(Mobile_number: textEditingController.text,)));
        } else if(updateMobileNumber.status == 0){
          setState(() {
            searchResult2 = updateMobileNumber.message;
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18,right: 18,top: 20),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Update Mobile Number",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                    ),),
                ),
              ),
              Divider(height: 10,color: Colors.grey,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Align(
                   alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Text("Please add your mobile number ${widget.mobile}",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400
                      ),),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color:  Color(0xFFEDF0EE),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "+91"
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8,top: 30),
                        child: Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1
                            ),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your mobile number',
                              hintStyle: TextStyle(fontSize: 12.0),
                              border: InputBorder.none, // Remove the underline
                              contentPadding: EdgeInsets.only(
                                bottom: 15,top: 0,left: 5,right: 5
                              ), // Adjust padding as needed
                              alignLabelWithHint: true, // Center the hint text
                            ),
                            controller: textEditingController,
                            keyboardType:TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10), // Set the maximum length to 10
                              FilteringTextInputFormatter.digitsOnly, // Allow only digits
                            ],
                            onTap: () {
                              // Remove "+91" when the TextField is tapped
                              if (textEditingController.text.startsWith("+91")) {
                                textEditingController.text = textEditingController.text.substring(3);
                              }
                            },
                            onChanged: (Mobile){
                              if(textEditingController.text.length ==10){
                                searchResult='';
                                searchResult2='';
                                searchUserByPhone(textEditingController.text,_token);
                              }
                            },
                          ),
                        ),
                      ),
                      isSearching
                          ? Container(
                          height: 25,
                          width: 25,
                          child: Center(child:  SpinKitFadingCircle(
          color: Colors.redAccent,
          size: 50.0,
        ))
                           )
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
                    ],
                  ),

                  // ElevatedButton(
                  //   onPressed: () {
                  //      if(textEditingController.text.length != 10  ){
                  //       Fluttertoast.showToast(msg: "Mobile number at least 10 digit",textColor: Colors.white,backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT);
                  //     } else if(textEditingController.text != null && textEditingController.text.isNotEmpty){
                  //        Fluttertoast.showToast(msg: "Please enter mobile number",textColor: Colors.white,backgroundColor: Colors.red,toastLength: Toast.LENGTH_SHORT);
                  //     } else{
                  //        _callAPI(textEditingController.text, textEditingController2.text);
                  //      }
                  //   },
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Change to your desired color
                  //   ),
                  //   child: Text("Send OTP"),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
