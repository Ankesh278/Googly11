import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/App_Widgets/Account_Overview.dart';
import 'package:world11/App_Widgets/Other_Details.dart';
import 'package:world11/App_Widgets/Withdraw%20Cash.dart';
import 'package:world11/Model/UserAllData/GetUserAllData.dart';
import 'package:world11/Model/UserPhotoUpdate/UserPhotoUpdate.dart';
import 'package:world11/view/Add%20Email%20Address.dart';
import 'package:world11/view/Change%20UserName.dart';
import 'package:world11/view/Update%20All%20Content.dart';
import '../App_Widgets/CustomText.dart';
import '../App_Widgets/account_profile_widget.dart';
import 'package:http/http.dart' as http;
import '../resourses/Image_Assets/image_assets.dart';
import '../view/create_your_team/adharvoteridPickup/adharvoteridPickup.dart';

class Account extends StatefulWidget {
  var user;
   Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account>  {
  bool isSecondContainerVisible = true;
  String useremail ="" ;
  String userName="" ;
  String _token=''; 
  File? _image;
  String image ='';
  String? _phone ='';
  String? _email;
  String? _userName;
  String? _userPhoto;
  String? _KycStatus;
  String? adhar_status;
  String? _EmailStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getShareprefrenceUserdata();
    getPrefrenceData();
  }

  Future<void> getShareprefrenceUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token=prefs.getString("token");
    String? user_name=prefs.getString("UserName");
    String? invite_code=prefs.getString("invite_code");
    String? mobile_number=prefs.getString("mobile_number");

    setState(() {
      _phone=mobile_number;
      _token=token!;
      print(_token+":::::");
      userName = user_name!;
    });
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? userPhoto=prefs.getString("user_photo");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _userPhoto=userPhoto;
      _token=token!;
      fetchUserAllData(token.toString());
    });
    print("email"+_email.toString());
    print("user_id"+_userName.toString());
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
          setState(() {
            image=userAllData.user!.userKyc!.userImage;
            userName=userAllData.user!.userName;
            useremail=userAllData.user!.email;
            _phone=userAllData.user!.phone;
            _userName=userAllData.user!.userName;
            _userPhoto=userAllData.user!.userKyc!.userImage;
            _KycStatus=userAllData.user!.userKyc!.kycStatus.toString();
            adhar_status=userAllData.user!.userKyc!.adhar_status.toString();

            _EmailStatus=userAllData.user!.email_status.toString();


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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xff780000),
      ),
      body:SingleChildScrollView(
        child:  Column(
          children: [
            SizedBox(
              height:size.height *0.01,
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Account_Overview()));
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the color of the divider line
                      width: 1.0,         // Set the width of the divider line
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_2_outlined),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'Account Overview',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  isSecondContainerVisible = !isSecondContainerVisible;
                  print("sgddfyuawyu:::"+isSecondContainerVisible.toString());
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the color of the divider line
                      width: 1.0,         // Set the width of the divider line
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          // width: 24, // Set the desired width
                          // height: 24, // Set the desired height
                          child: Transform.rotate(
                            angle: isSecondContainerVisible ? 0.5 * 3.14 : 0, // Rotate 180 degrees if the container is visible
                            child: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            if(isSecondContainerVisible)
              Container(
                width: double.infinity,
                //height: 800,
                color: Color(0xDEDCDCFF), // Use the 0xFF prefix to specify an opaque color
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.person_2_rounded , color: Colors.black,),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Account Details',style: TextStyle(color: Colors.black,fontSize: 16),),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7,top: 10),
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height * 0.2,
                        width:  size.width * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border: Border.all(color: Color(0xff780000),
                              width: 0.1,strokeAlign:BorderSide.strokeAlignInside),
                          boxShadow: [BoxShadow(
                            color: Color(0xff780000),
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),],
                        ),
                        child:  Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 15),
                                  child:
                                  CircleAvatar(
                                    radius: 37,
                                    backgroundImage: _userPhoto != null && Uri.parse(_userPhoto.toString()).isAbsolute
                                        ? NetworkImage(_userPhoto.toString())
                                        : AssetImage(ImageAssets.user) as ImageProvider,
                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                    _pickImage();
                                  },
                                  child: _isLoading ?
                                      Center(
                                          child: Container(
                                            height: 20,width: 20,
                                              child:  SpinKitFadingCircle(
                                                color: Colors.red,)
                                          )) :
                                  CustomPaddedText(
                                    text: 'Change Photo',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8,left: 30),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:size.height *0.05,),
                                  CustomPaddedText(
                                    text: userName.isNotEmpty ? userName : "Abcd@1233",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),

                                  CustomPaddedText(
                                    text: useremail.isNotEmpty ? useremail : "Update Your Email Address",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isSecondContainerVisible)
                      SizedBox(height: size.height * 0.03,),
                    if (isSecondContainerVisible)
                      AccountProfileWidget(
                        text: useremail.isNotEmpty ? useremail : "Update Your Email Address",
                        textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    if (isSecondContainerVisible)
                      SizedBox(height: size.height * 0.02,),
                    if (isSecondContainerVisible)
                      AccountProfileWidget(
                        text: userName.isNotEmpty ? userName : "Abcd@1233",
                        textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8)),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.green, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            top: BorderSide(
                              color: Colors.green, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            left: BorderSide(
                              color: Colors.green, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            right: BorderSide(
                              color: Colors.green, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.mobile_friendly_sharp,color: Colors.black,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Mobile Number',style: TextStyle(color: Colors.grey),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      '+91 XXXXXX${_phone != null && _phone!.length >= 4 ? _phone!.substring(_phone!.length - 4) : ''}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator
                                          .push(context,
                                          MaterialPageRoute(
                                              builder: (context)=>
                                                  UpdateMobileNumber(mobile: _phone,)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Change Number',style: TextStyle(color: Colors.blue),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 18,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight:Radius.circular(5))
                                  ),
                                  child: Center(
                                    child: Text(
                                      'VERIFIED',
                                      style: TextStyle(color: Colors.white,fontSize: 12.5,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8)
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: _KycStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            top: BorderSide(
                              color: _KycStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            left: BorderSide(
                              color: _KycStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            right: BorderSide(
                              color: _KycStatus == "1" ? Colors.green : Colors.orange,// Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.document_scanner_rounded)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Document Verification',style: TextStyle(color: Colors.grey),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      _KycStatus == "1" ? 'Document Uploaded ' : '---------',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if(_KycStatus=="1"){
                                        Fluttertoast.showToast(msg: "Document Uploaded Successfully", fontSize: 15, backgroundColor: Colors.green, textColor: Colors.white);
                                      } else{
                                        Navigator
                                            .push(context,
                                            MaterialPageRoute(
                                                builder: (context)=>
                                                    AdharVoterIDPickUp())
                                        );
                                      }

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        _KycStatus == "1" ? 'VERIFIED' : 'Verify Document',
                                        style: TextStyle(color: Colors.blue),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 18,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: _KycStatus == "1" ? Colors.green : Colors.orange,
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight:Radius.circular(5))
                                  ),
                                  child: Center(
                                    child: Text(
                                      _KycStatus == "1" ? 'VERIFIED' : 'PENDING',
                                      style: TextStyle(color: Colors.white,fontSize: 12.5,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // Expanded(
                            //   child: Align(
                            //     alignment: Alignment.topRight,
                            //     child: Container(
                            //       height: 18,
                            //       width: 70,
                            //       decoration: BoxDecoration(
                            //           color: _KycStatus == "1" ? Colors.green : Colors.orange,
                            //           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight:Radius.circular(5))
                            //       ),
                            //       child: Center(
                            //         child: Text(
                            //           _KycStatus == "1" ? 'VERIFIED' : 'PENDING',
                            //           style: TextStyle(color: Colors.white,fontSize: 8.5,fontWeight: FontWeight.w600),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8)),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.purpleAccent, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            top: BorderSide(
                              color: Colors.purpleAccent, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            left: BorderSide(
                              color: Colors.purpleAccent, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            right: BorderSide(
                              color: Colors.purpleAccent, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.key,color: Colors.black,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('User Name',style: TextStyle(color: Colors.grey),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(userName.toString(),style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  Navigator
                                      .push(context,
                                      MaterialPageRoute(
                                          builder: (context)=>
                                              ChangeUserName(oldUserName: userName,)
                                      )
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 17,
                                    width: 70,
                                    child: Center(
                                      child: Text(
                                        'Change',
                                        style: TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(8)),
                          border: Border(
                            bottom: BorderSide(
                              color: _EmailStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            top: BorderSide(
                              color: _EmailStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            left: BorderSide(
                              color: _EmailStatus == "1" ? Colors.green : Colors.orange, // Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                            right: BorderSide(
                              color: _EmailStatus == "1" ? Colors.green : Colors.orange,// Set the color of the divider line
                              width: 2.5,         // Set the width of the divider line
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Icon(Icons.email)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('Email Id ',style: TextStyle(color: Colors.grey),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      _EmailStatus == "1"  && _EmailStatus!.isNotEmpty ? useremail : '------------',style: TextStyle(color: Colors.black),),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator
                                          .push(context,
                                          MaterialPageRoute(
                                              builder: (context)=>
                                                  AddEmailAddress()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Add email',style: TextStyle(color: Colors.blue),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: 18,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: _EmailStatus == "1" ? Colors.green : Colors.orange,
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight:Radius.circular(5))
                                  ),
                                  child: Center(
                                    child: Text(
                                      _EmailStatus == "1" ? 'VERIFIED' : 'PENDING',
                                      style: TextStyle(color: Colors.white,fontSize: 12.5,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            InkWell(
              onTap: (){
                Navigator
                    .push(
                    context,
                    MaterialPageRoute(
                        builder: (context)
                        =>WithdrawCash()
                    )
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the color of the divider line
                      width: 2.0,         // Set the width of the divider line
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.castle_sharp),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'Withdraw Cash',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator
                    .push(
                    context,
                    MaterialPageRoute(
                        builder: (context)
                        =>OtherDetails()
                    )
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Set the color of the divider line
                      width: 1.0,         // Set the width of the divider line
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.devices_other),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        'Other details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _image = File(pickedFile.path);// Set loading state to true when starting the API call
      });
      _callAPI(_image).then((value) {
        setState(() {
          _isLoading = false; // Set loading state to false after API call completes
        });
      });
    }
  }

  Future<void> _callAPI(File? userPhoto) async {
    var apiUrl = 'https://admin.googly11.in/api/user_image_update';
    String token = _token;

    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    print("data::::::" + headers.toString());
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers.addAll(headers)
        ..files.add(http.MultipartFile(
          'user_profile',
          userPhoto!.readAsBytes().asStream(),
          userPhoto.lengthSync(),
          filename: 'user_profile.jpg',
        ));


      var response = await http.Response.fromStream(await request.send());
      print("data::::::" +response.body);
      print("data::::::" +response.headers.toString());
      if (response.statusCode == 200) {
        UserPhotoUpdate update = UserPhotoUpdate.fromJson(jsonDecode(response.body));
        print(response.body);
        print("data::::::" + update.message);
        setState(() {
          image = update.imageUrl;
          _userPhoto = update.imageUrl;
          Fluttertoast.showToast(msg: "User Photo uploaded successfully", textColor: Colors.white,backgroundColor: Colors.black);
        });
        print('API call successful');
        print('Response: ${response.body}');
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(msg: "Please login then upload the image", textColor: Colors.red);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "Please select an image less than 2MB", textColor: Colors.red);
      }
    } catch (e) {
      print('Error making API call: $e');
    }
  }



  Future<void> fetchData(String token) async {
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
          setState(() {

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

}


