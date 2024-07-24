import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';

import 'Add Cash In Wallet.dart';

class AddCashChooseAmount extends StatefulWidget {
  const AddCashChooseAmount({super.key});

  @override
  State<AddCashChooseAmount> createState() => _AddCashChooseAmountState();
}

class _AddCashChooseAmountState extends State<AddCashChooseAmount> {
  TextEditingController _textEditingController = TextEditingController();
  bool isContainer1Selected = false;
  bool isContainer2Selected = false;
  bool isContainer3Selected = false;
  bool isContainer4Selected = false;
  int selectedContainerIndex = -1;
  String envirnment='PRODUCTION';
  String  appId='efprCNbf4PMSZWnYkPBN++UdpcI=';
  String merchantId='GOOGLY11ONLINE';
  bool enableLogging=true;
  String checksum='';
  String apiEndPoint="/pg/v1/pay";
  String body = "";
  String salt_key='6507558a-b7c3-4718-8679-e61389898373';
  String salt_index='1';
  Object? result;
  String callback = "https://webhook.site/callback-url";
  static const platform = MethodChannel('com.sabpaisa.integration/native');
  String? _email;
  String? _userName;
  String transaction_Id=DateTime.now().microsecondsSinceEpoch.toString();
  String _token='';

  Map<String, String> headers = {};
  bool enableLogs = true;
  String environmentValue = 'PRODUCTION';
  String packageName = "com.googly11.fantasy";

  String merchantTransactionId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPhonePeSdk();
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
  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
    });
    print("email"+_email.toString());
    print("user_id"+_userName.toString());
  }

  Future<void> addAmountToWallet(String _token,String amount,String transaction_id,String payment_Status) async {
    final String apiUrl = 'https://admin.googly11.in/api/add_amount_in_wallet';

    // Set up the request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token'
    };

    // Set up the request body
    Map<String, dynamic> body = {
      'amount': amount,
      'transaction_type': 'deposits-amount',
      'payment_status': payment_Status,
      'transaction': transaction_id,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      print('Response _Data Wallet: ${response.body}');

      if(response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: payment_Status,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.of(context).pop();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddCashInWallet()));
        print('Response: ${response.body}');
        // Handle the successful response here
      } else if(response.statusCode == 400){
        print('API call failed with status 400${response.statusCode}');
        print('Response: ${response.body}');
      }else if(response.statusCode == 404){
        print('API call failed with status 404${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
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

  void getInstalledUpiAppsForiOS() {
    if (Platform.isIOS) {
      PhonePePaymentSdk.getInstalledUpiAppsForiOS()
          .then((apps) => {
        setState(() {
          result = 'getUPIAppsInstalledForIOS - $apps';

          // For Usage
          List<String> stringList = apps
              ?.whereType<
              String>() // Filters out null and non-String elements
              .toList() ??
              [];

          // Check if the string value 'Orange' exists in the filtered list
          String searchString = 'PHONEPE';
          bool isStringExist = stringList.contains(searchString);

          if (isStringExist) {
            print('$searchString app exist in the device.');
          } else {
            print('$searchString app does not exist in the list.');
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  getChecksum() {
     // Prefixing with a fixed string
    merchantTransactionId="Googly11"+DateTime.now().millisecondsSinceEpoch.toString();
    transaction_Id= DateTime.now().millisecondsSinceEpoch.toString();
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": merchantTransactionId,
      "merchantUserId": transaction_Id,
      "amount": _textEditingController.text.toString()+"00",
      "mobileNumber": "9450787858",
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

  void startTransaction() async {
    try {
      PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
          .then((response) => {
        setState(() {
          if (response != null) {
            String status = response['status'].toString();
            String error = response['error'].toString();
            print("response:::::::::"+response.toString());
            if (status == 'SUCCESS') {
              check_Status();
              result = "Flow Completed - Status: Success!";
            } else {
              check_Status();
              Fluttertoast.showToast(msg: "${status}");
              result = "Flow Completed - Status: $status and Error: $error";
            }
          } else {
            result = "Flow Incomplete";
          }
        })
      })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Amount',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSelectableContainer(0, '50', ''),
                SizedBox(width: 12),
                buildSelectableContainer(1, '10', ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSelectableContainer(2, '1', ''),
                SizedBox(width: 12),
                buildSelectableContainer(3, '20', ''),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 20,bottom: 5),
            child: Align(
              alignment: Alignment.topLeft,
                child: Text(
                  "Enter Amount",
                  style: TextStyle(color: Colors.black,fontSize: 12),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      // Handle changes to the text field value
                      print('Text field value changed: $value');
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\u20B9 Enter Amount', // Unicode character for Rupee symbol
                      hintStyle: TextStyle(color: Colors.grey), // Optional: Customize hint text color
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                elevation: 5, // Add elevation for a shadow effect (optional)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  height: 130,
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_user_sharp,
                                color: Colors.blue,
                              ),
                              Text(
                                '100% SECURE ',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_textEditingController.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "Please Enter an amount",
                                  textColor: Colors.red,
                                  backgroundColor: Colors.black,
                                );
                              } else {
                                String cleanedAmount = _textEditingController.text.replaceAll('₹', ''); // Remove Rupee symbol
                                int enteredAmount;

                                try {
                                  enteredAmount = int.parse(cleanedAmount);
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: "Invalid amount",
                                    textColor: Colors.red,
                                    backgroundColor: Colors.black,
                                  );
                                  return; // Exit the function if parsing fails
                                }

                                if (enteredAmount < 1) {
                                  Fluttertoast.showToast(
                                    msg: "Amount must be at least 1",
                                    textColor: Colors.red,
                                    backgroundColor: Colors.black,
                                  );
                                } else {
                                  _showPaymentOptions(context);
                                  // Perform your action when the amount is not less than 100
                                  // body=getChecksum().toString();
                                  // startTransaction();
                                 //  final List<Object?> result = await platform.invokeMethod('callSabPaisaSdk',
                                 //      ["Googly", "Technology", "support@googly11.in", "9005958999", "${_textEditingController.text}"]);
                                 //  print("print:::ResultData::::"+result.toString());
                                 //
                                 // await addAmountToWallet(_token,_textEditingController.text, result[1].toString(), result[0].toString());
                                }
                              }
                            },
                            child: Container(
                              height: 40,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  'Next',
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
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all( 5),
                          child: Text(
                            'By continuing, I confirm that I am 18+ years old & play from a permitted  state. ',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
   }
//Commented on 19-06-24 for direct payment from sab paisa
  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: AssetImage(ImageAssets.combo),
                  ),
                  title: Text('PhonePe'),
                  onTap: () async {
                    Navigator.pop(context);
                    if (_textEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please Enter an amount",
                        textColor: Colors.red,
                        backgroundColor: Colors.black,
                      );
                    } else {
                      String cleanedAmount = _textEditingController.text.replaceAll('₹', ''); // Remove Rupee symbol
                      int enteredAmount;

                      try {
                        enteredAmount = int.parse(cleanedAmount);
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "Invalid amount",
                          textColor: Colors.red,
                          backgroundColor: Colors.black,
                        );
                        return; // Exit the function if parsing fails
                      }

                      if (enteredAmount < 1) {
                        Fluttertoast.showToast(
                          msg: "Amount must be at least 1",
                          textColor: Colors.red,
                          backgroundColor: Colors.black,
                        );
                      } else {
                        body=getChecksum().toString();
                        startTransaction();
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    backgroundImage: AssetImage(ImageAssets.Sub_Paisa),
                  ),
                  title: Text('SabPaisa'),
                  onTap: () async {
                    Navigator.pop(context);
                    if (_textEditingController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please Enter an amount",
                        textColor: Colors.red,
                        backgroundColor: Colors.black,
                      );
                    } else {
                      String cleanedAmount = _textEditingController.text.replaceAll('₹', ''); // Remove Rupee symbol
                      int enteredAmount;

                      try {
                        enteredAmount = int.parse(cleanedAmount);
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: "Invalid amount",
                          textColor: Colors.red,
                          backgroundColor: Colors.black,
                        );
                        return; // Exit the function if parsing fails
                      }

                      if (enteredAmount < 1) {
                        Fluttertoast.showToast(
                          msg: "Amount must be at least 1",
                          textColor: Colors.red,
                          backgroundColor: Colors.black,
                        );
                      } else {
                        final List<Object?> result = await platform.invokeMethod('callSabPaisaSdk',
                            ["Googly", "Technology", "support@googly11.in", "9005958999", "${_textEditingController.text}"]);
                        print("print:::ResultData::::"+result.toString());

                        await addAmountToWallet(_token,_textEditingController.text, result[1].toString(), result[0].toString());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget buildSelectableContainer(int index, String amount, String bonus) {
  return GestureDetector(
    onTap: () {
      setState(() {
        if (selectedContainerIndex == index) {
          selectedContainerIndex = -1; // Unselect if already selected
          _textEditingController.text = '';
        } else {
          selectedContainerIndex = index; // Select the tapped container
          _textEditingController.text = amount;
        }
      });
    },
    child: Container(
      height: 50,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedContainerIndex == index
              ? Colors.green
              : Colors.blueGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  bonus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: selectedContainerIndex == index
                ? Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 18,
            )
                : null,
          )
        ],
      ),
    ),
  );
}

  Future<void> check_Status() async{
   try{
     final url="https://api.phonepe.com/apis/hermes/pg/v1/status/$merchantId/$merchantTransactionId";

     String concat_String="/pg/v1/status/$merchantId/$merchantTransactionId$salt_key";
     var byts=utf8.encode(concat_String);
     var digits=sha256.convert(byts).toString();
     String xVerify="$digits###$salt_index";

     Map<String,String>  headers={
       "Content-Type" : "application/json",
       "X-VERIFY" : xVerify,
       "X-MERCHANT-ID" : merchantId
     };

     await http.get(Uri.parse(url),headers: headers).then((value) {
       Map<String,dynamic> res = jsonDecode(value.body);
       print("Data:::::res"+res.toString());
       try{
         if(res["success"] && res["code"] == "PAYMENT_SUCCESS" && res['data']['state'] == 'COMPLETED'){
           addAmountToWallet(_token,_textEditingController.text, res['data']['merchantTransactionId'], res['data']['responseCode']);
         }else{
           addAmountToWallet(_token,_textEditingController.text, res['data']['merchantTransactionId'], res['data']['responseCode']);
         }
       }catch(e){

       }
     });
   }catch(e){
     print("Error::::"+e.toString());
   }

  }

  //This method is create for the direct payment through the sab Paisa without bottom sheet
  //
  // Future<void> sabPaisa( BuildContext context) async{
  //   Navigator.pop(context);
  //   if (_textEditingController.text.isEmpty) {
  //     Fluttertoast.showToast(
  //       msg: "Please Enter an amount",
  //       textColor: Colors.red,
  //       backgroundColor: Colors.black,
  //     );
  //   } else {
  //     String cleanedAmount = _textEditingController.text.replaceAll('₹', ''); // Remove Rupee symbol
  //     int enteredAmount;
  //
  //     try {
  //       enteredAmount = int.parse(cleanedAmount);
  //     } catch (e) {
  //       Fluttertoast.showToast(
  //         msg: "Invalid amount",
  //         textColor: Colors.red,
  //         backgroundColor: Colors.black,
  //       );
  //       return; // Exit the function if parsing fails
  //     }
  //
  //     if (enteredAmount < 1) {
  //       Fluttertoast.showToast(
  //         msg: "Amount must be at least 1",
  //         textColor: Colors.red,
  //         backgroundColor: Colors.black,
  //       );
  //     } else {
  //       final List<Object?> result = await platform.invokeMethod('callSabPaisaSdk',
  //           ["Googly", "Technology", "support@googly11.in", "9005958999", "${_textEditingController.text}"]);
  //
  //       print("print:::ResultData::::"+result.toString());
  //
  //       await addAmountToWallet(_token,_textEditingController.text, result[1].toString(), result[0].toString());
  //     }
  //   }
  // }
}
