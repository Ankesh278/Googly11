import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/App_Widgets/Withdraw%20Cash.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import 'package:world11/view/AddCashChooseAmount.dart';
import 'package:world11/view/Bonus%20Cash.dart';
import 'package:world11/view/View_Transactions.dart';

import '../Model/UserAllData/GetUserAllData.dart';
import '../Model/WalletModel/Data.dart';
import '../Model/WalletModel/WallelModelData.dart';
import 'create_your_team/adharvoteridPickup/adharvoteridPickup.dart';

class AddCashInWallet extends StatefulWidget {
  const AddCashInWallet({super.key});

  @override
  State<AddCashInWallet> createState() => _AddCashInWalletState();
}

class _AddCashInWalletState extends State<AddCashInWallet> {
  String envirnment='PRODUCTION';
  String appId='';
  String merchantId='GOOGLY11ONLINE';
  bool   enableLogging=true;
  String checksum='';
  String apiEndPoint="/pg/v1/pay";
  String body = "";
  String salt_key='6507558a-b7c3-4718-8679-e61389898373';
  String salt_index='1';
  Object? result;
  String callback = "https://webhook.site/callback-url";
  String? _email;
  String? _userName;
  String _token='';
  WalletResponseData? walletResponseData;
  String? _KycStatus;
  String? _Pan_Kyc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPhonePeSdk();
    body=getChecksum().toString();
    getPackageSignatureForAndroid();
    getPrefrenceData();
  }

  void initPhonePeSdk() {

    PhonePePaymentSdk.init(envirnment, appId, merchantId, enableLogging)
        .then((isInitialized) => {
      setState(() {
        result = 'PhonePe SDK Initialized - $isInitialized';
      })
    })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }
  Future<void> getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
      getUserWalletData(_token);
      fetchUserAllData(token.toString());
    });
    print("email:::::::::"+_email.toString());
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
            _KycStatus=userAllData.user!.userKyc!.kycStatus.toString();
            _Pan_Kyc=userAllData.user!.userKyc!.pan_kyc.toString();
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

  Future<WalletResponseData?> getUserWalletData(String _token) async {
    final String apiUrl = 'https://admin.googly11.in/api/user-wallte';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    print('Error: ${response.statusCode}');
    print('Wallet data::::::: ${response.body}');
    if (response.statusCode == 200) {
      WallelModelData wallelModelData=WallelModelData.fromJson(json.decode(response.body));
      if(wallelModelData.status==1){
        setState(() {
          walletResponseData=wallelModelData.data;
        });
        return wallelModelData.data;
      }
      print('Response data: ${response.body}');
    } else if(response.statusCode == 401){
      WallelModelData wallelModelData=WallelModelData.fromJson(json.decode(response.body));
      if(wallelModelData.status==0){
        return wallelModelData.data;
      }
      print('Error: ${response.statusCode}');
    }
    return null;
  }


  void getPackageSignatureForAndroid() {
    if (Platform.isAndroid) {
      PhonePePaymentSdk.getPackageSignatureForAndroid()
          .then((packageSignature) => {
        setState(() {
          result = 'getPackageSignatureForAndroid - $packageSignature';
          appId=packageSignature!;
          print("app_id"+packageSignature);
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }
  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "9999999999",
      "callbackUrl": callback,
      "paymentInstrument": {
        "type": "PAY_PAGE"
      },
    };
    String base64Body=base64.encode(utf8.encode(json.encode(requestData)));
    checksum='${sha256.convert(utf8.encode(base64Body+apiEndPoint+salt_key)).toString()}###$salt_index';
    print("checksum"+checksum);
    return base64Body;
  }


  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'.tr,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              child: Card(
                elevation: 8,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "Total Balance".tr,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "₹ ${walletResponseData != null ? double.parse(walletResponseData!.balance.toString()) + double.parse(walletResponseData!.totalEarnings.toString()) : "0"}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewTransactions()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "View Transaction".tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                  onPressed: () async{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddCashChooseAmount()));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                  ),
                                  child: Text(
                                      "Add Cash".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                              ),
                            ),

                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Winning Balance".tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      "₹ ${walletResponseData != null && walletResponseData!.totalEarnings != "0.00" ? walletResponseData!.totalEarnings : "0"}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: walletResponseData != null && double.parse(walletResponseData!.totalEarnings.toString()) >= 100
                                    ? ElevatedButton(
                                  onPressed: () {
                                    if (_KycStatus == "1" && _Pan_Kyc == "1") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => WithdrawCash()),
                                      );
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(
                                              builder: (context)=> AdharVoterIDPickUp())
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          // If button is pressed
                                          return Colors.green; // Change to green
                                        }
                                        return Colors.green; // Default to green
                                      },
                                    ),
                                  ),
                                  child: Text(
                                    "Withdraw".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                                    : ElevatedButton(
                                  onPressed: (){
                                    Fluttertoast.showToast(msg: "Minimum withdraw balance is 100",textColor: Colors.white,backgroundColor: Colors.black);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                  ),
                                  child: Text(
                                    "Withdraw".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 10),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BonusCash()));
                },
                child: Card(
                  elevation: 8,
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Bonus Points".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6,top: 5),
                            child: Container(
                              width: 300,
                              child: Text(
                                "Use Bonus Points to avail".tr,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Image(
                                    height: 25,
                                    width: 25,
                                    image: AssetImage(ImageAssets.income)
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    "${walletResponseData != null ? walletResponseData!.bonusBalance : 0}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 10),
                                //   child: Text(
                                //     "(1 Bonus Cash = ₹ 1)",
                                //     style: TextStyle(
                                //       fontSize: 11,
                                //       color: Colors.black,
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.forward,
                                        color: Colors.black,
                                      ),
                                    )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
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
}
