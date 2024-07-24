import 'dart:async';
import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart' hide Key;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Aadhar%20card%20Verify%20otp/AadharVerifyOtp.dart';
import '../Model/newResponse.dart';
import '../bottom_navigation_bar/bottom_navigation_screen.dart';

class OtpScreen extends StatefulWidget {
  final String client_Id;
  final String aadhar_no;

  const OtpScreen({Key? key, required this.client_Id, required this.aadhar_no}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _token = '';

  Future<void> getShareprefrenceUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    setState(() {
      _token = token ?? '';
      print(":::::$_token:::::");
    });
  }

  @override
  void initState() {
    super.initState();
    getShareprefrenceUserdata();
  }

  final TextEditingController _otpController = TextEditingController();

  String generateSignature(String clientId, String publicKeyPem) {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String dataToEncrypt = '$clientId.$timestamp';
    final publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
    final encryptedData = encrypter.encrypt(dataToEncrypt);
    return base64Encode(encryptedData.bytes);
  }

  Future<Object> submitOtp(String clientId, String otp) async {
    final String apiUrl = 'https://api.cashfree.com/verification/offline-aadhaar/verify';
    String clientId = 'CF671270CPENQSL4S4CRS94L6920';
    String clientSecret = 'cfsk_ma_prod_bf18cce3040047b7883cdc1b1b0c1528_2102a043';
    final publicKey = '''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0EwNb+K9Qa4J6NhF3FAI
FOEWYn2sR4HR75nFnWT5yyKU1pa0XgmuvcTXdZ8La3IVY4my4BcGR6rZ/ecI8Q5w
7fu3Tjoa96CnCWwbSHNKENn/Hqli/gav1nf4T2fDvAAC5Kcc65Eks9usJggwdjG/
IsYH1mF0YBWmf41MEF6vbGlIweMlGcHVGd4v4pbqGDkeIOKbEfLmewGx9eoa0rSt
BKfG+6BUaTwWNBC6XOmiPAQvEBz2Kcj06+MtBpTmmttYXCNVv1COT7NuNxscDedQ
UIyWt1rK9xGsSSPT6lHJh3NVAWnaJcTudcLSvxjpx/4O8uO+f2ZVz7Cej9VFPXI6
XQIDAQAB
-----END PUBLIC KEY-----''';

    String signature = generateSignature(clientId, publicKey);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-client-id': clientId,
      'x-client-secret': clientSecret,
      'X-CF-Signature': signature,
    };
    final Map<String, dynamic> payload = {
      'ref_id': widget.client_Id,
      'otp': _otpController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(payload),
    );

    print("response::::${response.body}");
    print("Ref Id is >>>${widget.client_Id}");
    print("headers::::${headers.toString()}");
    print("response::::${response.statusCode}");

    if (response.statusCode == 200) {
      final aadharVerification = AadhaarVerificationResponse.fromJson(json.decode(response.body));
      print("Message: ${aadharVerification.message}");

      if (aadharVerification.status == 101) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wrong Otp..!",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 80),
          ),
        );
      }
      print("Status: ${aadharVerification.status}");

      if (response.statusCode == 200 && aadharVerification.status == "VALID") {

        if (mounted) {
          SnackBar(
            content: Text(
              "Aadhaar verification is successful",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 80),

    );
        }


        var data = aadharVerification;
        if (data != null) {
          AadharApiDataSend_Server(context, _token, data.name ?? '', widget.aadhar_no, data.dob ?? '', data.gender ?? '',
              data.splitAddress.country ?? '', data.splitAddress.dist ?? '', data.splitAddress.po ?? '', data.splitAddress.subdist ?? '',
              data.splitAddress.landmark ?? '', data.splitAddress.pincode ?? '', data.careOf ?? '');

        }
      }

      return aadharVerification;
    } else if (response.statusCode == 401) {
      final aadharVerification = AadharVerifyOtp.fromJson(json.decode(response.body));

      if (aadharVerification.result != null &&
          aadharVerification.result!.statusCode == 401 &&
          !aadharVerification.result!.success &&
          aadharVerification.result!.messageCode == "invalid_token") {
        Fluttertoast.showToast(
          msg: "Something went wrong, please try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }

      return aadharVerification;
    } else {
      throw Exception('Failed to call API');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Otp Verification', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        )),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter the OTP sent to your mobile number', style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Pinput(
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: size.height * .3),
                InkWell(
                  onTap: () async {
                    await submitOtp(widget.client_Id, _otpController.text);
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * .8,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Verify', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
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

  void AadharApiDataSend_Server(BuildContext context, String token, String name, String adharNumber, String d_o_b, String gender,
      String country, String district, String post, String sub_district,
      String landmark, String pincode, String fatherName) async {
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
    print("::::::::::Aadhar data"+body.toString());
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('Request successful');
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Your Aadhaar number is verified successfully",
          fontSize: 15,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        showPanVerificationDialog(context);
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
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
  }

  void showPanVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
      false, // This makes the dialog not dismissible by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 300,
              maxHeight: 300,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/successgif.gif',
                    fit: BoxFit.cover,
                    height: 300,
                    width: 300,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    "Congrats!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Text(
                        "Your Aadhar verification is successful.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 19),
                      TextButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyBottomNavigationBar()));
                          // This dismisses the dialog
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
