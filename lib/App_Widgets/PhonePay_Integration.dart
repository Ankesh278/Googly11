// import 'dart:convert';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
// import 'package:world11/App_Widgets/upi_app.dart';
//
// class MerchantApp extends StatefulWidget {
//   const MerchantApp({super.key});
//
//   @override
//   State<MerchantApp> createState() => MerchantScreen();
// }
//
// class MerchantScreen extends State<MerchantApp> {
//  String body = jsonEncode(
//   {
//   "merchantId": "GOOGLY11ONLINE",
//   "merchantTransactionId": "transaction_123",
//   "merchantUserId": "90223250",
//   "amount": 1000,
//   "mobileNumber": "9335380325",
//   "callbackUrl": "https://webhook.site/callback-url",
//   "paymentInstrument": {
//   "type": "UPI_INTENT",
//   "targetApp": "com.phonepe.app"
//   },
//   "deviceContext": {
//   "deviceOS": "ANDROID"
//   }
//   }
//   );
//   String callback = "flutterDemoApp";
//   String checksum = "";
//
//   Map<String, String> headers = {};
//   Map<String, String> pgHeaders = {"Content-Type": "application/json"};
//   List<String> apiList = <String>['Container', 'PG'];
//   List<String> environmentList = <String>['UAT', 'UAT_SIM', 'PRODUCTION'];
//   String apiEndPoint = "/pg/v1/pay";
//   bool enableLogs = true;
//   Object? result;
//   String dropdownValue = 'PG';
//   String environmentValue = 'UAT_SIM';
//   String appId = "";
//   String merchantId = "";
//   String packageName = "com.phonepe.simulator";
//
//   void startTransaction() {
//     dropdownValue == 'Container'
//         ? ""
//         : startPGTransaction();
//   }
//
//   void initPhonePeSdk() {
//     PhonePePaymentSdk.init(environmentValue, "6507558a-b7c3-4718-8679-e61389898373", "GOOGLY11ONLINE", enableLogs)
//         .then((isInitialized) => {
//       setState(() {
//         result = 'PhonePe SDK Initialized - $isInitialized';
//       })
//     })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void isPhonePeInstalled() {
//     PhonePePaymentSdk.isPhonePeInstalled()
//         .then((isPhonePeInstalled) => {
//       setState(() {
//         result = 'PhonePe Installed - $isPhonePeInstalled';
//       })
//     }).catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void isGpayInstalled() {
//     PhonePePaymentSdk.isGPayAppInstalled()
//         .then((isGpayInstalled) => {
//       setState(() {
//         result = 'GPay Installed - $isGpayInstalled';
//       })
//     })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void isPaytmInstalled() {
//     PhonePePaymentSdk.isPaytmAppInstalled()
//         .then((isPaytmInstalled) => {
//       setState(() {
//         result = 'Paytm Installed - $isPaytmInstalled';
//       })
//     })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//   }
//
//   void getPackageSignatureForAndroid() {
//     if (Platform.isAndroid) {
//       PhonePePaymentSdk.getPackageSignatureForAndroid()
//           .then((packageSignature) => {
//         setState(() {
//           result = 'getPackageSignatureForAndroid - $packageSignature';
//         })
//       })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     }
//   }
//
//   void getInstalledUpiAppsForAndroid() {
//     if (Platform.isAndroid) {
//       PhonePePaymentSdk.getInstalledUpiAppsForAndroid()
//           .then((apps) => {
//         setState(() {
//           if (apps != null) {
//             Iterable l = json.decode(apps);
//             List<UPIApp> upiApps = List<UPIApp>.from(
//                 l.map((model) => UPIApp.fromJson(model)));
//             String appString = '';
//             for (var element in upiApps) {
//               appString +=
//               "${element.applicationName} ${element.version} ${element.packageName}";
//             }
//             result = 'Installed Upi Apps - $appString';
//           } else {
//             result = 'Installed Upi Apps - 0';
//           }
//         })
//       })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     }
//   }
//   String generateChecksum(Map<String, dynamic> requestData, String secretKey) {
//     final jsonRequest = jsonEncode(requestData);
//     final bytes = utf8.encode('$jsonRequest$secretKey');
//     final checksum = sha256.convert(bytes);
//     print("checksum"+checksum.toString());
//     return checksum.toString();
//   }
//   Map<String, dynamic> requestData = {
//     "merchantId": "GOOGLY11ONLINE",
//     "merchantTransactionId": "transaction_123",
//     "merchantUserId": "90223250",
//     "amount": 1000,
//     "mobileNumber": "9335380325",
//     "callbackUrl": "https://webhook.site/callback-url",
//     "paymentInstrument": {
//       "type": "UPI_INTENT",
//       "targetApp": "com.phonepe.app"
//     },
//     "deviceContext": {
//       "deviceOS": "ANDROID"
//     }
//   };
//
//   String secretKey = '6507558a-b7c3-4718-8679-e61389898373';
//
//
//   void startPGTransaction() async {
//     try {
//       PhonePePaymentSdk.startPGTransaction(
//           "ewogICJtZXJjaGFudElkIjogIlBHVEVTVFBBWVVBVDg5IiwKICAibWVyY2hhbnRUcmFuc2FjdGlvbklkIjogInRyYW5zYWN0aW9uXzEyMyIsCiAgIm1lcmNoYW50VXNlcklkIjogIjkwMjIzMjUwIiwKICAiYW1vdW50IjogMTAwMCwKICAibW9iaWxlTnVtYmVyIjogIjk5OTk5OTk5OTkiLAogICJjYWxsYmFja1VybCI6ICJodHRwczovL3dlYmhvb2suc2l0ZS9jYWxsYmFjay11cmwiLAogICJwYXltZW50SW5zdHJ1bWVudCI6IHsKICAgICJ0eXBlIjogIlVQSV9JTlRFTlQiLAogICAgInRhcmdldEFwcCI6ICJjb20ucGhvbmVwZS5zaW11bGF0b3IiCiAgfSwKICAiZGV2aWNlQ29udGV4dCI6IHsKICAgICJkZXZpY2VPUyI6ICJBTkRST0lEIgogIH0KfQ==",
//           callback, "5010a272214513dac330001d69c00260dbb8d645af17302777a9234bcedb787c###1", pgHeaders, "/pg/v1/pay", "com.phonepe.simulator")
//           .then((response) => {
//         setState(() {
//           if (response != null) {
//             String status = response['status'].toString();
//             String error = response['error'].toString();
//             if (status == 'SUCCESS') {
//               result = "Flow Completed - Status: Success!";
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(result.toString()),
//                 ),
//               );
//             } else {
//               result =
//               "Flow Completed - Status: $status and Error: $error";
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(result.toString()),
//                 ),
//               );
//             }
//           } else {
//             result = "Flow Incomplete";
//           }
//         })
//       })
//           .catchError((error) {
//         handleError(error);
//         return <dynamic>{};
//       });
//     } catch (error) {
//       handleError("djsfkdkfllclx:::::"+error.toString());
//     }
//   }
//
//   void handleError(error) {
//     setState(() {
//       if (error is Exception) {
//         result = error.toString();
//       } else {
//         result = {"error": error};
//       }
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Make Payment',style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),),
//             automaticallyImplyLeading: false, // Set this to false to hide the default back button
//             backgroundColor: Color(0xff780000),
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 // Add your back button functionality here
//                 Navigator.of(context).pop(); // This example assumes you want to navigate back
//               },
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Container(
//               margin: const EdgeInsets.all(7),
//               child: Column(
//                 children: <Widget>[
//                   TextField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Merchant Id',
//                     ),
//                     onChanged: (text) {
//                       merchantId = text;
//                     },
//                   ),
//                   TextField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'App Id',
//                     ),
//                     onChanged: (text) {
//                       appId = text;
//                     },
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       const Text('Select the environment'),
//                       DropdownButton<String>(
//                         value: environmentValue,
//                         icon: const Icon(Icons.arrow_downward),
//                         elevation: 16,
//                         underline: Container(
//                           height: 2,
//                           color: Colors.black,
//                         ),
//                         onChanged: (String? value) {
//                           setState(() {
//                             environmentValue = value!;
//                             if (environmentValue == 'PRODUCTION') {
//                               packageName = "com.googly11.fantasy";
//                             } else if (environmentValue == 'UAT') {
//                               packageName = "com.googly11.fantasy";
//                             } else if (environmentValue == 'UAT_SIM') {
//                               packageName = "com.googly11.fantasy";
//                             }
//                           });
//                         },
//                         items: environmentList
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       )
//                     ],
//                   ),
//                   Visibility(
//                       maintainSize: false,
//                       maintainAnimation: false,
//                       maintainState: false,
//                       visible: Platform.isAndroid,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             const SizedBox(height: 10),
//                             Text("Package Name: $packageName"),
//                           ])),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: <Widget>[
//                       Checkbox(
//                           value: enableLogs,
//                           onChanged: (state) {
//                             setState(() {
//                               enableLogs = state!;
//                             });
//                           }),
//                       const Text("Enable Logs")
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Warning: Init SDK is Mandatory to use all the functionalities*',
//                     style: TextStyle(color: Colors.red),
//                   ),
//
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                     ),
//                     onPressed: initPhonePeSdk,
//                     child: const Text('INIT SDK'),
//                   ),
//                   const SizedBox(width: 5.0),
//                   TextField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'body',
//                     ),
//                     onChanged: (text) {
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'checksum',
//                     ),
//                     onChanged: (text) {
//                       checksum = text;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: <Widget>[
//                       const Text('Select the transaction type'),
//                       DropdownButton<String>(
//                         value: dropdownValue,
//                         icon: const Icon(Icons.arrow_downward),
//                         elevation: 16,
//                         underline: Container(
//                           height: 2,
//                           color: Colors.black,
//                         ),
//                         onChanged: (String? value) {
//                           // This is called when the user selects an item.
//                           setState(() {
//                             dropdownValue = value!;
//                             if (dropdownValue == 'PG') {
//                               apiEndPoint = "/pg/v1/pay";
//                             } else {
//                               apiEndPoint = "/v4/debit";
//                             }
//                           });
//                         },
//                         items: apiList
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       )
//                     ],
//                   ),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                       ),
//                       onPressed: startTransaction,
//                       child: const Text('Start Transaction')),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Expanded(
//                             child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                                 ),
//                                 onPressed: isPhonePeInstalled,
//                                 child: const Text('PhonePe App'))),
//                         const SizedBox(width: 5.0),
//                         Expanded(
//                             child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                                 ),
//                                 onPressed: isGpayInstalled,
//                                 child: const Text('Gpay App'))),
//                         const SizedBox(width: 5.0),
//                         Expanded(
//                             child: ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                                 ),
//                                 onPressed: isPaytmInstalled,
//                                 child: const Text('Paytm App'))),
//                       ]),
//                   Visibility(
//                       maintainSize: false,
//                       maintainAnimation: false,
//                       maintainState: false,
//                       visible: Platform.isAndroid,
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Expanded(
//                                 child: ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                                     ),
//                                     onPressed: getPackageSignatureForAndroid,
//                                     child:
//                                     const Text('Get Package Signature'))),
//                             const SizedBox(width: 5.0),
//                             Expanded(
//                                 child: ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1115f2)), // Change the color here
//                                     ),
//                                     onPressed: getInstalledUpiAppsForAndroid,
//                                     child: const Text('Get UPI Apps'))),
//                             const SizedBox(width: 5.0),
//                           ])),
//                   Text("Result: \n $result")
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }