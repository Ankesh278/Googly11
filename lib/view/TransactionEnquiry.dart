import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import '../Model/EnquiryApi/EnquiryApiModel.dart';

class TransactionEnquiry extends StatefulWidget {
  const TransactionEnquiry({super.key});

  @override
  State<TransactionEnquiry> createState() => _TransactionEnquiryState();
}

class _TransactionEnquiryState extends State<TransactionEnquiry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textController2 = TextEditingController();
  String AUTH_KEY = 'uTR54CMVm1oTC25h';
  String AUTH_IV = 's4cE9ZbOA7w1cJDY';
  bool _isFocused = true;
  bool isButtonEnabled = false;
  bool isRecordNotFound=true;
  String payerName="";
  String payerEmail="";
  String payerMobile="";
  String clientTxn="";
  String Payment_Mode="";
  String TxnId="";
  String Status="";
  String Paid_Amount="";
  Future<void> _submitForm() async {
    String clientTxnId = textController2.text.trim();

    String query = 'clientCode=GGP11&clientTxnId=$clientTxnId';

    String encryptedString = await encryptString(AUTH_KEY,AUTH_IV,query);

    Map<String, dynamic> jsonData = {
      'clientCode': "GGP11",
      'statusTransEncData': encryptedString,
    };

    String apiUrl = 'https://txnenquiry.sabpaisa.in/SPTxtnEnquiry/getTxnStatusByClientxnId';
    EnquiryApiModel? data = await performPostCall(apiUrl, json.encode(jsonData));
    if (data != null && data.statusResponseData.isNotEmpty) {
      String response = data.statusResponseData;
      String decryptedString = await decryptString(AUTH_KEY, AUTH_IV, response);
      print("decrypted $decryptedString");
      Map<String, String> queryParams = Uri.splitQueryString(decryptedString);

      // Extract variables
       payerName = queryParams['payerName'] ?? '';
       payerEmail = queryParams['payerEmail'] ?? '';
       payerMobile = queryParams['payerMobile'] ?? '';
       clientTxn = queryParams['clientTxnId'] ?? '';
      Payment_Mode = queryParams['paymentMode'] ?? '';
      TxnId = queryParams['sabpaisaTxnId'] ?? '';
      Status = queryParams['status'] ?? '';
      Paid_Amount = queryParams['amount'] ?? '';
      // Add more variables as needed

      // Print the extracted variables
      print('Name: $payerName');
      print('Email: $payerEmail');
      print('Mobile: $payerMobile');
      print('Client Transaction ID: $clientTxn');

      // Check if the response contains the expected data
      if (decryptedString.contains('payerName')) {
        setState(() {
          isRecordNotFound=true;
          isButtonEnabled = true;
        });
      } else {
        // Handle the case when the response is not as expected
        setState(() {
          isRecordNotFound=false;
          isButtonEnabled = false;
        });
      }
    } else {
      // Handle the case when the API call fails
      setState(() {
        isRecordNotFound=false;
        isButtonEnabled = false;
      });
    }



  }

  Future<String> encryptString(String authKey, String authIV, String input) async {
    final key = encrypt.Key.fromUtf8(authKey);
    final iv = encrypt.IV.fromUtf8(authIV);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(input, iv: iv);
    print("sdfhkjdshf"+encrypted.toString());
    return encrypted.base64;
  }

  Future<String> decryptString(String authKey, String authIV, String encryptedInput) async {
    try {
      final key = encrypt.Key.fromUtf8(authKey);
      final iv = encrypt.IV.fromUtf8(authIV);

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      // Clean up the Base64 input before decoding
      final cleanedInput = cleanBase64(encryptedInput);

      print('Cleaned Input: $cleanedInput');

      final encrypted = encrypt.Encrypted.fromBase64(cleanedInput);

      print('Encrypted: $encrypted');

      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      // String queryString =
      //     "payerName=Vinay Rawat&payerEmail=developerndmeaatechnology@gmail.com&payerMobile=7388980325&clientTxnId=CRrsWu8m2q1700133946&payerAddress=no address&amount=1.0&clientCode=GGP11&paidAmount=1.0&paymentMode=BHIM UPI QR&bankName=BOB&amountType=INR&udf1=NA&udf2=NA&udf3=NA&udf4=NA&udf5=NA&udf6=NA&udf7=NA&udf8=NA&udf9=null&udf10=null&udf11=null&udf12=null&udf13=null&udf14=null&udf15=null&udf16=null&udf17=null&udf18=null&udf19=null&udf20=null&status=SUCCESS&responseCode=0000&statusCode=0000&challanNumber=null&sabpaisaTxnId=363951611230435297&sabpaisaMessage=null&bankMessage=null&bankErrorCode=null&sabpaisaErrorCode=null&bankTxnId=101202332016993991&programId=GGP11&mcc=null&transDate=2023-11-16 16:56:26.0&refundStatusCode=null&chargeBackStatus=null&settlementStatus=null";

      // Parse the query string

      print('Decrypted: $decrypted');

      return decrypted;
    } catch (e) {
      print('Error during decryption: $e');
      rethrow; // rethrow the exception for further analysis
    }
  }

  String cleanBase64(String input) {
    // Remove any characters that are not part of the Base64 character set
    final cleanedInput = input.replaceAll(RegExp('[^a-zA-Z0-9+/]'), '');

    // Remove excess padding characters
    final indexOfLastNonPadding = cleanedInput.lastIndexOf(RegExp('[^=]'));
    var withoutExcessPadding = cleanedInput.substring(0, indexOfLastNonPadding + 1);

    // Ensure that the length is a multiple of four
    while (withoutExcessPadding.length % 4 != 0) {
      withoutExcessPadding += '=';
    }

    return withoutExcessPadding;
  }

  Future<EnquiryApiModel?> performPostCall(String requestURL, String postDataParams) async {
    try {
      final response = await http.post(
        Uri.parse(requestURL),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Accept': 'application/json',
        },
        body: postDataParams,
      );

      if (response.statusCode == 200) {
        print("response: " + response.body);
        print("response status code: " + response.statusCode.toString());

        // Parse the response body into EnquiryApiModel
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return EnquiryApiModel.fromJson(jsonResponse);
      } else {
        // Handle the error case
        // You can use response.body to get the error response
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Enquiry',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
           child: Column(
             children: [
               Align(
                 alignment: Alignment.topLeft,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text('View Your Transaction',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 15,
                     ),
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
                           hintText: 'Enter Transaction Id',
                           labelText: _isFocused ? 'Enter Client Transaction Id' : '',
                           labelStyle: TextStyle(
                             color: _isFocused ? Colors.blue : Colors.grey,
                           ),
                           focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
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
                             return 'Please enter a valid Transaction Id';
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
                   onTap:  _onButtonPressed ,
                   child: Container(
                     height: 40,
                     width: 350,
                     decoration: BoxDecoration(
                         color: Colors.cyan,
                         borderRadius: BorderRadius.circular(12)
                     ),
                     child: Center(
                       child: Text("View",style:TextStyle(
                           color: Colors.black,
                           fontWeight: FontWeight.bold,
                           fontSize: 15
                       ),),
                     ),
                   ),
                 ),
               ),

               if (!isRecordNotFound)
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(
                     "No record found",
                     style: TextStyle(
                       color: Colors.red,
                       fontWeight: FontWeight.bold,
                       fontSize: 15,
                     ),
                   ),
                 ),
               if(isButtonEnabled)
               Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Transaction Id',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                     Text(clientTxn,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                   ],
                 ),
               ),
               if(isButtonEnabled)
               Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('PayerName',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                     Text(payerName,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                   ],
                 ),
               ),
               if(isButtonEnabled)
               Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('PayerEmail',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                     Text(payerEmail,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                   ],
                 ),
               ),
               if(isButtonEnabled)
               Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('PayerMobile',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                     Text(payerMobile,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 13,
                       ),
                     ),
                   ],
                 ),
               ),
               if(isButtonEnabled)
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Payment_Mode',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                       Text(Payment_Mode,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                     ],
                   ),
                 ),
               if(isButtonEnabled)
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('TxnId',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                       Text(TxnId,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                     ],
                   ),
                 ),
               if(isButtonEnabled)
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Status',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                       Text(Status,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                     ],
                   ),
                 ),
               if(isButtonEnabled)
                 Padding(
                   padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Paid_Amount',
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                       Text(Paid_Amount,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 13,
                         ),
                       ),
                     ],
                   ),
                 ),
             ],
           ),
        ),
      ),
    );
  }
  void _onButtonPressed() {
    if (_formKey.currentState!.validate()) {
      _submitForm();
    }
  }
}
