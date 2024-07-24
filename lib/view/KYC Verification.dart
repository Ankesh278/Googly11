import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pointycastle/api.dart' hide Padding;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/pkcs1.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/digests/sha256.dart';




import 'package:pointycastle/signers/rsa_signer.dart' as pointycastle;
import '../Model/AadharVerificationModel/AadharCardVerification.dart';
import 'OtpVerifyAadhaar.dart';


class KYC_Verification extends StatefulWidget {
  const KYC_Verification({super.key});

  @override
  State<KYC_Verification> createState() => _KYC_VerificationState();
}

class _KYC_VerificationState extends State<KYC_Verification> {
  TextEditingController textController = TextEditingController();
  bool isButtonEnabled = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    textController.addListener(_checkInputLength);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _checkInputLength() {
    setState(() {
      isButtonEnabled = textController.text.length == 12;
    });
  }

  Future<AadharVerification> callAPI(BuildContext context, String input) async {
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
    print("Aadhaar Number: $input");

    final String apiUrl =
        'https://api.cashfree.com/verification/offline-aadhaar/otp';

    // Generate signature
    // String currentTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    // String dataToEncrypt = '$clientId.$currentTimeStamp';
    // Perform RSA encryption of dataToEncrypt using the provided public key

    String signature = generateSignature(clientId, publicKey);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'x-client-id': clientId,
      'x-client-secret': clientSecret,
      'X-CF-Signature': signature, // Add the signature to the headers
    };

    print("Headers: $headers");
    print("helloooo   "+signature);

    final Map<String, String> body = {
      'aadhaar_number': input,
    };

    print("Body: $body");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(body),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("Url: ${response.request}");

    if (response.statusCode == 200) {
      final aadharVerification =
          AadharVerification.fromJson(json.decode(response.body));

      Fluttertoast.showToast(
        msg: "Your Aadhaar number is valid. OTP sent to your registered number",
        fontSize: 15,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpScreen(client_Id: aadharVerification.refId.toString(),aadhar_no:input),
        ),
      );
      return aadharVerification;
    } else {
      print(
          'Failed to call API: ${response.statusCode} ${response.reasonPhrase}');
      final errorBody = json.decode(response.body);
      throw Exception('${errorBody['type']}: ${errorBody['message']}');
    }
  }

/// Function to generate RSA signature

  String generateSignature(String clientId, String publicKeyPem) {
    // Get the current UNIX timestamp
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Concatenate client ID and timestamp
    String dataToEncrypt = '$clientId.$timestamp';

    // Convert the public key from PEM format to RSA public key
    final publicKey = RSAKeyParser().parse(publicKeyPem) as RSAPublicKey;

    // Encrypt the data using the public key
    final encrypter = Encrypter(RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP));
    final encryptedData = encrypter.encrypt(dataToEncrypt);

    // Encode the encrypted data to base64
    String signature = base64Encode(encryptedData.bytes);


    return signature;
  }

  //
  // Future<AadharVerification> callAPI(String input) async {
  //   print("number"+input);
  //  //final String apiUrl = 'https://api.emptra.com/aadhaarVerification/requestOtp';
  //  final String apiUrl = 'https://api.cashfree.com/verification/offline-aadhaar/otp';
  //
  //
  //   final Map<String, String> headers = {
  //     //'Content-Type': 'application/json',
  //     'Content-Type': 'application/json',
  //     //'clientId': '9899a03dbe943a4b8cfbf42b6dffe329:f10777d9177394b0b52aa4fa623aba7d',
  //     'x-client-id': '9899a03dbe943a4b8cfbf42b6dffe329:f10777d9177394b0b52aa4fa623aba7d',
  //     //'secretKey': 'sw1PRticKzthNupFgSfMnVKIBTtaJMDyeW2PZK6zPbGg3JCNAHvI7zHeMD8aAkeh0',
  //     'x-client-secret': 'sw1PRticKzthNupFgSfMnVKIBTtaJMDyeW2PZK6zPbGg3JCNAHvI7zHeMD8aAkeh0',
  //   };
  //
  //   print("headers"+headers.toString());
  //   final Map<String, String> body = {
  //     //'aadhaarNumber': input,
  //     'aadhaar_number': input,
  //   };
  //   print("body"+body.toString());
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );
  //   print("response"+response.bodyBytes.toString());
  //   print("response"+response.body.toString());
  //   if (response.statusCode == 200) {
  //     final aadharVerification = AadharVerification.fromJson(json.decode(response.body));
  //     if (aadharVerification.code == 100 && aadharVerification.result!.success == true && aadharVerification.result!.messageCode == "success") {
  //       Fluttertoast.showToast(msg: "Your Aadhaar number is valid otp send on your registered number",fontSize: 15,backgroundColor: Colors.green,textColor: Colors.white);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(client_Id: aadharVerification.result!.data!.clientId,)));
  //     } else  if (aadharVerification.code==500) {
  //       Fluttertoast.showToast(msg: "Your Aadhaar number is Invalid. Please enter the correct number",fontSize: 15,backgroundColor: Colors.green,textColor: Colors.white);
  //
  //     }
  //     return aadharVerification;
  //   }
  //   else if (response.statusCode == 401) {
  //     final aadharVerification = AadharVerification.fromJson(json.decode(response.body));
  //     if ( aadharVerification.result!.success==false && aadharVerification.result!.messageCode == "invalid_token") {
  //       Fluttertoast.showToast(
  //         msg:  "Something went wrong, please try again",
  //         toastLength: Toast.LENGTH_LONG, // You can change the duration
  //         gravity: ToastGravity.BOTTOM, // You can change the position
  //         timeInSecForIosWeb: 1, // Time in seconds for iOS and web
  //         backgroundColor: Colors.pinkAccent,
  //         textColor: Colors.white,
  //         fontSize: 15.0,
  //       );
  //     }
  //     return aadharVerification;
  //   } else {
  //     throw Exception('Failed to call API');
  //   }
  // }

  bool _isFocused = true;
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
              padding: const EdgeInsets.only(top: 25,left: 25),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter Aadhaar Number",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'XXXX XXXX XXXX',
                        labelText: _isFocused ? 'Enter Aadhaar Number' : '',
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
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a 12-digit Aadhaar number.';
                        } else if (value.length != 12) {
                          return 'Aadhaar Card number must be 12 digits long.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isButtonEnabled ? _onButtonPressed : null,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() {
    if (_formKey.currentState!.validate()) {
      callAPI(context, textController.text);
    }
  }
}
