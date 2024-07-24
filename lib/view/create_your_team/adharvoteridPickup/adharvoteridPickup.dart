  import 'dart:convert';

  import 'package:flutter/material.dart';
  import 'package:fluttertoast/fluttertoast.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:world11/resourses/Image_Assets/image_assets.dart';
  import 'package:world11/view/KYC%20AadhaarCardAndPanCard.dart';
  import 'package:world11/view/KYC%20Verification.dart';
  import 'package:world11/view/Verify_Pan_Card.dart';
  import 'package:http/http.dart' as http;
  import '../../../Model/UserAllData/GetUserAllData.dart';

  class AdharVoterIDPickUp extends StatefulWidget {
    const AdharVoterIDPickUp({Key? key}) : super(key: key);
    @override
    State<AdharVoterIDPickUp> createState() => _AdharVoterIDPickUpState();
  }

  class _AdharVoterIDPickUpState extends State<AdharVoterIDPickUp> {
    int selectedContainerIndex = -1;
    String UserAadhaar = "";
    String UserPan = "";
    String? _email;
    String? _userName;
    String? _KycStatus;
    String? PanStatus;
    String? _adhar_status;
    @override
    void initState() {
      getPrefrenceData();
      super.initState();
    }

    void getPrefrenceData() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("email_user");
      String? userName = prefs.getString("UserName");
      String? token=prefs.getString("token");
      setState(() {
        _email=email;
        _userName=userName;
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
              _userName=userAllData.user!.userName;
              _KycStatus=userAllData.user!.userKyc!.kycStatus.toString();
              PanStatus=userAllData.user!.userKyc!.pan_kyc.toString();
              _adhar_status=userAllData.user!.userKyc!.adharstatus.toString();


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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Verify Document',
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      height: 150,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      image: AssetImage(ImageAssets.NetworkImage),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select any 1 option to proceed',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    buildContainerWithRadio(
                      size,
                      ImageAssets.aadhar,
                      'Enter Aadhaar Number',
                      0,
                      'Enter valid 12 digit Aadhaar number',
                    ),
                    SizedBox(height: size.height * 0.02),
                    buildContainerWithRadio(
                      size,
                      ImageAssets.dglocker,
                      'Verify Pan Card',
                      1,
                      'Enter valid Pan Number',
                    ),
                    SizedBox(height: size.height * 0.02),
                    buildContainerWithRadio(
                      size,
                      ImageAssets.aadhar,
                      'Upload ID Proof',
                      2,
                      'Valid ID Proofs Aadhaar Card/Passport/\nVoter ID/ Driving Licence',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 130,
              width: double.infinity,
              color: Color(0xFFF2FCFC),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_sharp,
                          color: Colors.blue,
                        ),
                        Text(
                          'Googly11 is 100% Safe & Secure! KYC Verification is\nmandatory to add cash',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (selectedContainerIndex == 0) {
                        if (_adhar_status == "1") {
                          Fluttertoast.showToast(
                            msg: "Document verification is already completed.",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }else{

                          Navigator.push(context, MaterialPageRoute(builder: (context) => KYC_Verification()));
                        }

                      } else if (selectedContainerIndex == 1) {
                        if (PanStatus == "1") {
                          Fluttertoast.showToast(
                            msg: "Document verification is already completed.",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }else{

                          Navigator.push(context, MaterialPageRoute(builder: (context) => Verify_Pan_Card()));
                        }

                      } else if (selectedContainerIndex == 2) {
                        if (_KycStatus == "1") {
                          Fluttertoast.showToast(
                            msg: "Document verification is already completed.",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => KYC_AadhaarCardAndPanCardUpload()));
                        }

                      }
                    },
                    child: Container(
                      height: 40,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          'Continue'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
      );
    }

    Widget buildContainerWithRadio(Size size, String imageAsset, String text, int index, String text2) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedContainerIndex = index;
          });
        },
        child: Container(
          height: size.height * 0.095,
          width: size.width * 0.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 1.5,
              color: selectedContainerIndex == index ? Colors.green : Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Radio(
                  value: index,
                  groupValue: selectedContainerIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedContainerIndex = value as int;
                    });
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Text(
                    text2,
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              if (index == 0)
                if(_adhar_status=="0")
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 16,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(2))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Takes 1 min',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),

              if (index == 2)
                if(_KycStatus == "1")
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 16,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(2))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Center(
                          child: Text(
                            'Verified',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (index == 0)
                if(_adhar_status == "1")
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 16,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(2))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Center(
                            child: Text(
                              'Verified',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              if (index == 1)
                if(PanStatus == "1")
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 16,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(2))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Center(
                            child: Text(
                              'Verified',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
    }
  }
