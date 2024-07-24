import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/Pan%20Model/PanCardModel.dart';
import '../Model/PanCardDataSendDataResponse/PanCardSendDataResponse.dart';
import '../bottom_navigation_bar/bottom_navigation_screen.dart';

class Verify_Pan_Card extends StatefulWidget {
  const Verify_Pan_Card({super.key});

  @override
  State<Verify_Pan_Card> createState() => _Verify_Pan_CardState();
}

class _Verify_Pan_CardState extends State<Verify_Pan_Card> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textController = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  bool _isFocused = true;
  bool isButtonEnabled = false;
  String _token = '';
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
    });
  }

  String generateSignature(String clientId, String publicKeyPem) {
    // Get the current UNIX timestamp
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Concatenate client ID and timestamp
    String dataToEncrypt = '$clientId.$timestamp';

    // Convert the public key from PEM format to RSA public key
    final publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;

    // Encrypt the data using the public key
    final encrypter =
        Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
    final encryptedData = encrypter.encrypt(dataToEncrypt);

    // Encode the encrypted data to base64
    String signature = base64Encode(encryptedData.bytes);

    return signature;
  }

  Future<PanCardModel> callAPI(String input2, String name) async {
    print("number" + input2);

    final String apiUrl = 'https://api.cashfree.com/verification/pan';
    String clientId = 'CF671270CPENQSL4S4CRS94L6920';
    String clientSecret =
        'cfsk_ma_prod_bf18cce3040047b7883cdc1b1b0c1528_2102a043';
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
      'accept': 'application/json',
      'x-client-id': clientId,
      'x-client-secret': clientSecret,
      'X-CF-Signature': signature,
    };
    final Map<String, dynamic> data = {'pan': input2, "name": name};
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(data),
    );

    print("response" + response.bodyBytes.toString());

    if (response.statusCode == 200) {
      final aadharVerification =
          PanCardModel.fromJson(json.decode(response.body));
      if (aadharVerification.valid == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your Pan number is valid",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(
                top: 80), // Adjust the margin to control the position
          ),
        );
        SendPanDataToServer(
          _token,
          aadharVerification.referenceId.toString(),
          aadharVerification.registeredName,
          aadharVerification.pan,
          aadharVerification.type,
          aadharVerification.message,
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(client_Id: aadharVerification.data!.clientId,)));
      } else if (aadharVerification.valid == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your Pan number is Invalid. Please enter the correct number",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(
                top: 80), // Adjust the margin to control the position
          ),
        );
      }
      return aadharVerification;
    } else if (response.statusCode == 422) {
      final aadharVerification =
          PanCardModel.fromJson(json.decode(response.body));
      if (aadharVerification.valid == 422) {
        Fluttertoast.showToast(
          msg: "Your Pan number is Invalid. Please enter the correct number",
          toastLength: Toast.LENGTH_LONG, // You can change the duration
          gravity: ToastGravity.BOTTOM, // You can change the position
          timeInSecForIosWeb: 1, // Time in seconds for iOS and web
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
      return aadharVerification;
    } else {
      throw Exception('Failed to call API');
    }
  }

  String? validateInput(String? value) {
    if (value != null && !RegExp(r'^[A-Z]*$').hasMatch(value)) {
      return 'Only input capital letters';
    }
    return null;
  }

  Future<void> SendPanDataToServer(String token, String txn_Id, String Name,
      String number, String type_of_holder, String panStatus) async {
    var apiUrl = 'https://admin.googly11.in/api/user_pan_kyc';

    // Request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print("header" + headers.toString());
    Map<String, String> body = {
      'txn_id': '$txn_Id',
      'name': '$Name',
      'number': '$number',
      'type_of_holder': '$type_of_holder',
      'pan_status': '$panStatus',
    };

    print("Body" + body.toString());
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('API call failed with status:::::::::: ${response.statusCode}');
      print('Response:::::::::: ${response.body}');
      if (response.statusCode == 200) {
        PanCardSendDataResponse userAllData =
            PanCardSendDataResponse.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          showPanVerificationDialog(context);

          //Fluttertoast.showToast(msg: "${userAllData.message}", textColor: Colors.white,backgroundColor: Colors.black);
          // Navigator.of(context).pop();
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong",
              textColor: Colors.white,
              backgroundColor: Colors.black);
        }
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: "Token not found",
            textColor: Colors.white,
            backgroundColor: Colors.black);
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
            msg: "User not found",
            textColor: Colors.white,
            backgroundColor: Colors.black);
      } else if (response.statusCode == 422) {
        PanCardSendDataResponse userAllData =
            PanCardSendDataResponse.fromJson(jsonDecode(response.body));
        if (userAllData.status == 1) {
          Fluttertoast.showToast(
              msg: "${userAllData.message}",
              textColor: Colors.white,
              backgroundColor: Colors.black);
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong",
              textColor: Colors.white,
              backgroundColor: Colors.black);
        }
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
        title: Text(
          'KYC Verification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading:
            false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context)
                .pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter Your Pan Number",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    TextFormField(
                      controller: textController2,
                      decoration: InputDecoration(
                        hintText: 'Enter Pan Number',
                        labelText: _isFocused ? 'Enter Pan Number' : '',
                        labelStyle: TextStyle(
                          color: _isFocused ? Colors.blue : Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        setState(() {
                          _isFocused = true;
                        });
                      },
                      validator: (value) {
                        // Validate the input and return an error message if invalid
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid Pan Number';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: textController3,
                      decoration: InputDecoration(
                        hintText: 'Enter Your name',
                        labelText: _isFocused ? 'Enter Pan Name' : '',
                        labelStyle: TextStyle(
                          color: _isFocused ? Colors.blue : Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        setState(() {
                          _isFocused = true;
                        });
                      },
                      validator: (value) {
                        // Validate the input and return an error message if invalid
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid Pan Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: _onButtonPressed,
                child: Container(
                  height: 40,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() {
    if (_formKey.currentState!.validate()) {
      callAPI(textController2.text, textController3.text);
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
                        "Your PAN verification is successful.",
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
}
