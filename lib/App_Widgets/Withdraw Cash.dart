import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/BankVerificationModel/BankVerification.dart';
import '../ApiCallProviderClass/API_Call_Class.dart';
import '../Model/BankDataSendToserver_Model/BankDataSendServer.dart';
import '../Model/GetBankDetails/Data.dart';
import '../Model/OtpUpiSend/OtpResponseUpi.dart';
import '../Model/Otp_Verify_ModelUpi/Otp_Verify_Model_Upu.dart';
import '../Model/Send_Data_To_Server_Upi/Send_Data_To_Server_Upi_Details.dart';
import '../Model/UpiVerification/UpiDetailsList.dart';
import '../Model/UpiVerification/UpiValidateResponse.dart';
import '../Model/UserAllData/GetUserAllData.dart';
import '../Model/WalletModel/Data.dart';
import '../Model/WalletModel/WallelModelData.dart';
import '../Model/WithdrawRequestModel/WithdrawRequestResponse.dart';
import '../resourses/Image_Assets/image_assets.dart';
import '../view/Add Email Address.dart';
import '../view/View_Transactions.dart';
import '../view/create_your_team/adharvoteridPickup/adharvoteridPickup.dart';
class WithdrawCash extends StatefulWidget {
  const WithdrawCash({super.key});
  @override
  State<WithdrawCash> createState() => _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> with SingleTickerProviderStateMixin{
   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController=TextEditingController();
  TextEditingController _enterAccountNumber=TextEditingController();
  TextEditingController _enteryourmobileName=TextEditingController();
  TextEditingController _enterYourName=TextEditingController();
  TextEditingController _textIfscCode=TextEditingController();
  TextEditingController Address_text=TextEditingController();
  TextEditingController State_text=TextEditingController();
  TextEditingController Zipcode=TextEditingController();

 // TextEditingController _reEnterAccountNumber=TextEditingController();
 // TextEditingController _Upi_Id_Controller=TextEditingController();
   String? _email;
   String? _userName;
   String _token='';
   String _mobile_number='';
   bool isSearching=false;
   bool isSearchingUpi=false;
   late TabController _tabController;
   List<UpiDetailsList> upiDetailsList = [];
   WalletResponseData? walletResponseData;
   int _selectedTabIndex = 0;
   String? _EmailStatus;

   void getPrefrenceData() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? email = prefs.getString("email_user");
     String? userName = prefs.getString("UserName");
     String mobile_number = prefs.getString("mobile_number").toString();
     String? token=prefs.getString("token");
     setState(() {
       _email=email;
       _userName=userName;
       _token=token!;
       _mobile_number=mobile_number;
       getUserWalletData(_token);
       fetchUserTeam(_token);
     });
     fetchUserAllData(_token);
     print("email"+_email.toString());
     print("user_id"+_userName.toString());
   }

   @override
   void initState() {
    // TODO: implement initState
     _tabController =  TabController(length: 2, vsync: this, initialIndex: 0);
     getPrefrenceData();
    super.initState();
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

   Future<void> fetchUserTeam(String token) async {
     final ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
     apiProvider.getUpiDetails(token);
     apiProvider.getBankDetails(token);
   }


   @override
   void dispose() {
     _tabController.dispose();
     super.dispose();
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

     print("ssss"+signature);

     return signature;
   }

   Future<void> callBankAccountValidationAPI(String Name,String Mobile,String Account ,String ifsc,ApiProvider apiProvider,String address,String State,String zipcode) async {
    final String apiUrl = 'https://api.cashfree.com/verification/bank-account/sync';
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
      'accept': 'application/json',
      'x-client-id': clientId,
      'x-client-secret': clientSecret,
      'X-CF-Signature': signature,
    };
    print("Headers: $headers");

    final Map<String, dynamic> data = {
      "bank_account": Account,
      "ifsc": ifsc,
      "phone": Mobile,
      "name": Name,
    };
    print("Data  : "+data.toString());

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );


    print("response"+response.body.toString());
    if (response.statusCode == 200) {
      final aadharVerification = BankVerification.fromJson(json.decode(response.body));

      print("Account status  "+aadharVerification.accountStatus);
      print("Status code   "+aadharVerification.accountStatusCode);


      if (aadharVerification.accountStatus == "VALID"  && aadharVerification.accountStatusCode == "ACCOUNT_IS_VALID") {
        setState(() {
          isSearching = true;
          _enterAccountNumber.clear();
          _enteryourmobileName.clear();
          _enterYourName.clear();
          Zipcode.clear();
          State_text.clear();
          _textIfscCode.clear();


        });
        callUserBankDetailsApi(_token,Mobile,Account,ifsc,aadharVerification.bankName,
            aadharVerification.city,aadharVerification.branch,
            aadharVerification.referenceId.toString(),aadharVerification.micr.toString(),
          aadharVerification.nameAtBank,apiProvider,address,State,zipcode

        ).then((_) {
          // Reset the status after the API call is complete
          setState(() {
            isSearching = false;
          });
        });
    } else if(aadharVerification.accountStatusCode == 100 && aadharVerification.accountStatusCode == 400 ){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your Account Do not verify ! Somethings! went wrong",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(top: 80), // Adjust the margin to control the position
          ),
        );
    }
      else if(aadharVerification == 104){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Somethings! went wrong",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(top: 80), // Adjust the margin to control the position
          ),
        );
      }
    }
  }

   Future<void> callUPIBankVerification(String Mobile_number,String user_mobile) async {
    final String apiUrl = 'https://api.invincibleocean.com/invincible/mobileUpi';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'clientId': '9899a03dbe943a4b8cfbf42b6dffe329:f10777d9177394b0b52aa4fa623aba7d',
      'secretKey': 'sw1PRticKzthNupFgSfMnVKIBTtaJMDyeW2PZK6zPbGg3JCNAHvI7zHeMD8aAkeh0',
    };

    final Map<String, dynamic> data = {
      "mobileNumber": Mobile_number,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    print("response"+response.bodyBytes.toString());
    print("response"+response.body.toString());
    if (response.statusCode == 200) {
      final aadharVerification = UpiValidateResponse.fromJson(json.decode(response.body));
      if (aadharVerification.code == 200 ) {
        upiDetailsList=aadharVerification.result!.upiDetailsList!;
        _openBottomSheetDialog(upiDetailsList,user_mobile);
    } else if(aadharVerification.code == 404 ){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No UPI exist! , in this number",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(top: 80), // Adjust the margin to control the position
          ),
        );
    } else if(aadharVerification.code == 402 ){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Something went wrong!!",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Set the behavior to floating
            margin: EdgeInsets.only(top: 80), // Adjust the margin to control the position
          ),
        );
    }
    }
  }

  void _openBottomSheetDialog(List<UpiDetailsList> upiDetailsList,String mobile_number) {
     showModalBottomSheet(
       context: context,
       elevation: 10,
       builder: (BuildContext context) {
         return YourBottomSheet(upiDetailsList,_token,mobile_number);
       },
     );
   }

   Future<void> WithdrawRequestRaisedForUpi(String _token,String amount,String Upi_Id) async {
     final String apiUrl = 'https://admin.googly11.in/api/withdraw_wining_request';

     // Set up the request headers
     Map<String, String> headers = {
       'Accept': 'application/json',
       'Authorization': 'Bearer $_token'
     };

     // Set up the request body
     Map<String, dynamic> body = {
       'amount': amount,
       'upi_id': Upi_Id,
     };

     try {
       final response = await http.post(
         Uri.parse(apiUrl),
         headers: headers,
         body: body,
       );
       print('Response _Data Wallet: ${response.body}');

       if(response.statusCode == 200) {
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  1){
           ShowWithdrawPopup(_token,textEditingController.text);
         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('Response: ${response.body}');
         // Handle the successful response here
       } else if(response.statusCode == 400){
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  1){
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed with status 400${response.statusCode}');
         print('Response: ${response.body}');
       } else if(response.statusCode == 404){
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  0){
           Navigator
               .push(context,
               MaterialPageRoute(
                   builder: (context)=>
                       AdharVoterIDPickUp())
           );
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed with status 404${response.statusCode}');
         print('Response: ${response.body}');
       }
     } catch (e) {
       // Handle exceptions
       print('Error: $e');
     }
   }
   Future<void> WithdrawRequestRaisedForBank(String _token,String amount,String bank_Id) async {
     final String apiUrl = 'https://admin.googly11.in/api/withdraw_wining_request';

     // Set up the request headers
     Map<String, String> headers = {
       'Accept': 'application/json',
       'Authorization': 'Bearer $_token'
     };

     // Set up the request body
     Map<String, dynamic> body = {
       'amount': amount,
       'bank_id': bank_Id,
     };

     try {
       final response = await http.post(
         Uri.parse(apiUrl),
         headers: headers,
         body: body,
       );
       print('Response _Data Wallet: ${response.body}');

       if(response.statusCode == 200) {
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  1){
           ShowWithdrawPopup(_token,textEditingController.text);
         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('Response: ${response.body}');
         // Handle the successful response here
       } else if(response.statusCode == 400){
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  1){

         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed with status 400${response.statusCode}');
         print('Response: ${response.body}');
       }else if(response.statusCode == 404){
         WithdrawRequestResponse withdrawRequestResponse = WithdrawRequestResponse.fromJson(json.decode(response.body));
         if(withdrawRequestResponse.status ==  1){

         }else{
           Fluttertoast.showToast(msg: "${withdrawRequestResponse.message}",textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed with status 404${response.statusCode}');
         print('Response: ${response.body}');
       }
     } catch (e) {
       // Handle exceptions
       print('Error: $e');
     }
   }


   Future<void> callUserBankDetailsApi(String token,String mobile_number,
       String Account_no,String ifsc_Code,String bank_Name,String city,String branch,String refid,
       String micr,String name_at_bank,ApiProvider apiProvider,String address,String state,String zipCode) async {
     String apiUrl = 'https://admin.googly11.in/api/user_bank_details';
     Map<String, String> headers = {
       'Accept': 'application/json',
       'Authorization': 'Bearer $token',
     };

     Map<String, String> body = {
       'mobile_number': mobile_number,
       'account_number': Account_no,
       'coform_account_number': Account_no,
       'ifsc_code': ifsc_Code,
       'bank_name': bank_Name,
       'city': city,
       'branch': branch,
       'refid': refid,
       'micr': micr,
       'name_at_bank': name_at_bank,
       'address':address,
       'city':city,
       'state' : state,
       'zipcode': zipCode
     };
     print("body_bank"+body.toString());
     try {
       final response = await http.post(
         Uri.parse(apiUrl),
         headers: headers,
         body: body,
       );
       print('API call failed. Status code: ${response.statusCode}');
       print('Response: ${response.body}');
       if (response.statusCode == 200) {
         BankDataSendServer bankDataSendServer=BankDataSendServer.fromJson(json.decode(response.body));
         if(bankDataSendServer.status == 1){
           showAlert(apiProvider,token);
         }else{
           Fluttertoast.showToast(msg: bankDataSendServer.message,textColor: Colors.white,backgroundColor: Colors.black);
         }
       } else if(response.statusCode == 400){
         BankDataSendServer bankDataSendServer=BankDataSendServer.fromJson(json.decode(response.body));
         if(bankDataSendServer.status == 1){
           Fluttertoast.showToast(msg: bankDataSendServer.message,textColor: Colors.white,backgroundColor: Colors.black);
         }else{
           Fluttertoast.showToast(msg: bankDataSendServer.message,textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed. Status code: ${response.statusCode}');
         print('Response: ${response.body}');
       } else if(response.statusCode == 422){
         BankDataSendServer bankDataSendServer=BankDataSendServer.fromJson(json.decode(response.body));
         if(bankDataSendServer.status == 1){
           Fluttertoast.showToast(msg: bankDataSendServer.message,textColor: Colors.white,backgroundColor: Colors.black);
         }else{
           Fluttertoast.showToast(msg: bankDataSendServer.message,textColor: Colors.white,backgroundColor: Colors.black);
         }
         print('API call failed. Status code: ${response.statusCode}');
         print('Response: ${response.body}');
       }
     } catch (error) {
       print('Error during API call: $error');
     }
   }

   void showAlert(ApiProvider provider,String token) async {
     QuickAlert.show(
       onConfirmBtnTap: () {
         provider.getBankDetails(token);
        Navigator.of(context).pop();
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text(
               "Your Bank Account is Added successful",
               style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
             ),
             backgroundColor: Colors.green,
             behavior: SnackBarBehavior.floating, // Set the behavior to floating
             margin: EdgeInsets.only(top: 80), // Adjust the margin to control the position
           ),
         );
       },
       context: context,
       title: 'Your Bank Account is Added successful',
       type: QuickAlertType.success,
     );
   }
  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

// Validate mobile number (numeric and non-empty)
  String? validateMobileNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return 'Mobile number must contain only numbers';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits long';
    }
    return null;
  }


// Validate account number (numeric and non-empty)
  String? validateAccountNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your account number';
    }
    if (!RegExp(r'^[0-9]*$').hasMatch(value)) {
      return 'Account number must contain only numbers';
    }
    return null;
  }

// Validate re-entered account number (matches the account number)
  String? validateReEnterAccountNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please re-enter your account number';
    }
    if (value != _enterAccountNumber.text) {
      return 'Account numbers do not match';
    }
    return null;
  }
  String? validateAddress(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter your Address';
    }

    return null;
  }
  String? validateState(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter your State';
    }

    return null;
  }
  String? validateZipcode(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter your Pin code';
    }

    return null;
  }

  String? validateIFSCCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the IFSC Code';
    }
    if (value.length != 11) {
      return 'IFSC Code should be 11 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body:  Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey, // Set the color of the border
                width: 2.0,         // Set the width of the border
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffe0dfa2),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                    border: Border.all(
                      color: Color(0xffb5b5b5),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Text('Withdrawable Balance : ₹ ${walletResponseData != null ? walletResponseData!.totalEarnings : 0}',style: TextStyle(color: Colors.black87,fontSize: 13),),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewTransactions()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10 ,top: 10 ),
                                child: Text('History',style: TextStyle(color: Colors.indigoAccent),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Container(
                          width: 240, // Adjust the width as needed
                          child: TextField(
                            controller: textEditingController,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                                setState(() {
                                  textEditingController.text = value;
                                });
                              // Whenever the text changes, check if the entered amount is less than 100
                              // if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) < 100) {
                              //   // Show toast message if the entered amount is less than 100
                              //   Fluttertoast.showToast(
                              //     msg: "Amount must be at least 100 ₹",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.BOTTOM,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0,
                              //   );
                              // }
                            },
                            decoration: InputDecoration(
                              hintText: '₹ Enter Amount to withdraw*', // Set the hint text here
                            ),
                          ),
                        ),
                      ),
                    ),
                    Consumer<ApiProvider>(
                      builder: (context, dataProvider, _) {
                        return InkWell(
                          onTap: (dataProvider.selectedIndex != -1 || dataProvider.selectedIndexBank != -1) &&
                              (textEditingController.text.isNotEmpty && int.tryParse(textEditingController.text) != null && int.parse(textEditingController.text) >= 100)
                              ? () {
                            if(_selectedTabIndex == 0){
                              setState(() {
                                isSearchingUpi = true;
                              });
                              WithdrawRequestRaisedForBank(_token, textEditingController.text,dataProvider.selectedBankId).then((_) {
                                setState(() {
                                  isSearchingUpi = false;
                                });
                              });
                            }else if(_selectedTabIndex == 1){
                              setState(() {
                                isSearchingUpi = true;
                              });
                              WithdrawRequestRaisedForUpi(_token, textEditingController.text,dataProvider.selectedUpiId ).then((_) {
                                setState(() {
                                  isSearchingUpi = false;
                                });
                              });

                            }else{
                              Fluttertoast.showToast(msg: "Please select a bank type",fontSize: 13,backgroundColor: Colors.black,textColor: Colors.white);
                            }
                              }
                              : () {
                            // Show toast message if no radio button is selected or the entered amount is invalid
                            Fluttertoast.showToast(
                              msg: "Please select a bank and enter a valid amount",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 5, top: 20),
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (dataProvider.selectedIndex != -1 || dataProvider.selectedIndexBank != -1) &&
                                  (textEditingController.text.isNotEmpty && int.tryParse(textEditingController.text) != null && int.parse(textEditingController.text) >= 100)
                                  ? Colors.green
                                  : Colors.grey[300], // Change button color based on selection and entered amount
                            ),
                            child: Center(
                              child: isSearchingUpi
                                  ? Center(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child:   SpinKitFadingCircle(
                                    color: Colors.redAccent,
                                    size: 50.0,
                                  )
                                ),
                              ) : Text(
                                'withdraw',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 5),
                      child: Text('Withdrawal Amount to be greater than ₹100',style: TextStyle(color: Colors.black54,fontSize: 12),),
                    )
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 10),
                      child: Text('Govt policy 30% Tax will apply on Net Winnings ',style: TextStyle(color: Colors.black,fontSize: 10),),
                    )
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                DefaultTabController(
                  length: 3, // Set the length to the number of tabs
                  child: Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.red,
                          indicatorColor: Colors.transparent,
                          controller: _tabController,
                          unselectedLabelColor: Colors.black,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(width: 2.0, color: Colors.red), // Set the thickness and color of the underline
                            insets: EdgeInsets.symmetric(horizontal: 16.0), // Adjust the horizontal padding of the underline
                          ),
                          tabs: [
                            Tab(text: 'BANK'),
                            Center(
                              child: Tab(child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("UPI",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(width: 8,),
                                  Text("Faster",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold,backgroundColor: Colors.red),),
                                ],
                              ),),
                            ),
                          ],
                          onTap: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                              print("_selectedTabIndex:::::::::"+index.toString());// Update the selected tab index when a tab is tapped
                            });
                          },
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey[100],
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // SingleChildScrollView(
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Container(
                                //       width: double.infinity,
                                //       child: Column(
                                //         children: [
                                //           Padding(
                                //             padding: const EdgeInsets.only(top: 20),
                                //             child: Container(
                                //               width: double.infinity,
                                //               decoration: BoxDecoration(
                                //                 borderRadius: BorderRadius.circular(10),
                                //                 border: Border.all(
                                //                   color: Colors.grey, // Set the color of the border
                                //                   width: 2.0,         // Set the width of the border
                                //                 ),
                                //               ),
                                //               child: Column(
                                //                 children: [
                                //                   Container(
                                //                     height: 40,
                                //                     width: double.infinity,
                                //                     decoration: BoxDecoration(
                                //                         color: Color(0xffe0dfa2),
                                //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                //                         border: Border.all(
                                //                             color: Color(0xffb5b5b5),
                                //                             width: 1.5
                                //                         )
                                //                     ),
                                //                     child: Column(
                                //                       children: [
                                //                         Center(
                                //                           child: Row(
                                //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                             children: [
                                //                               Padding(
                                //                                 padding: const EdgeInsets.only(left: 10,top: 10),
                                //                                 child: Text('UPI ID VERIFICATION',style: TextStyle(color: Colors.black87,fontSize: 13),),
                                //                               ),
                                //                             ],
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   SizedBox(
                                //                     height: 5,
                                //                   ),
                                //                   Consumer<ApiProvider>(
                                //                     builder: (context, dataProvider, _) {
                                //                       List<All_Upi_Data> upiDetailsList = dataProvider.all_Upi_Data_get;
                                //                       return Padding(
                                //                         padding: const EdgeInsets.only(left: 2, right: 2, top: 2),
                                //                         child: dataProvider.all_Upi_Data_get != null && dataProvider.all_Upi_Data_get.isNotEmpty
                                //                             ? Container(
                                //                             height: size.height * 0.3,
                                //                           child: ListView.builder(
                                //                             itemCount: upiDetailsList.length,
                                //                             itemBuilder: (BuildContext context, int index) {
                                //                               final event = upiDetailsList[index];
                                //                               return Column(
                                //                                 children: [
                                //                                   InkWell(
                                //                                     onTap:(){
                                //                                       dataProvider.setSelectedUpiId(event.id.toString());
                                //                                       dataProvider.toggleSelection(index); // Assuming index is accessible here
                                //                                     },
                                //                                     child: ListTile(
                                //                                       leading: Radio(
                                //                                         value: index,
                                //                                         groupValue: dataProvider.selectedIndex,
                                //                                         onChanged: (value) {
                                //                                           dataProvider.setSelectedUpiId(event.id.toString());
                                //                                           dataProvider.toggleSelection(value!);
                                //                                         },
                                //                                       ),
                                //                                       title: Text(
                                //                                         "UPI ID: ${event.upiId}",
                                //                                         style: TextStyle(
                                //                                           fontSize: 12,
                                //                                           color: Colors.black,
                                //                                           fontWeight: FontWeight.bold,
                                //                                         ),
                                //                                       ),
                                //                                       trailing: InkWell(
                                //                                         onTap: () {
                                //                                           // Show a confirmation dialog if needed
                                //                                           showDialog(
                                //                                             context: context,
                                //                                             builder: (BuildContext context) {
                                //                                               return AlertDialog(
                                //                                                 title: Text("Confirmation"),
                                //                                                 content: Text("Do you want to remove your Upi?"),
                                //                                                 actions: [
                                //                                                   TextButton(
                                //                                                     onPressed: () {
                                //                                                       Navigator.pop(context);
                                //                                                     },
                                //                                                     child: Text("Cancel"),
                                //                                                   ),
                                //                                                   TextButton(
                                //                                                     onPressed: () {
                                //                                                       dataProvider.deleteUPI(event.id!.toInt(), _token);
                                //                                                       dataProvider.getUpiDetails(_token);
                                //                                                       Navigator.pop(context);
                                //                                                     },
                                //                                                     child: Text("Remove"),
                                //                                                   ),
                                //                                                 ],
                                //                                               );
                                //                                             },
                                //                                           );
                                //                                         },
                                //                                         child: Text(
                                //                                           "remove",
                                //                                           style: TextStyle(
                                //                                             fontSize: 10,
                                //                                             color: Colors.blue,
                                //                                             fontWeight: FontWeight.bold,
                                //                                           ),
                                //                                         ),
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                                   Divider(
                                //                                     color: Colors.grey, // Customize the color of the divider
                                //                                     thickness: 1.0, // Customize the thickness of the divider
                                //                                   ),
                                //                                 ],
                                //                               );
                                //                             },
                                //                           ),
                                //                         )
                                //                             : Container(),
                                //                       );
                                //                     },
                                //                   ),
                                //
                                //                   Padding(
                                //                     padding: const EdgeInsets.only(bottom: 8),
                                //                     child: Row(
                                //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //                       crossAxisAlignment: CrossAxisAlignment.center,
                                //                       children: [
                                //                         Column(
                                //                           children: [
                                //                             Align(
                                //                               alignment: Alignment.centerLeft,
                                //                               child: Padding(
                                //                                 padding: const EdgeInsets.only(top: 5, left: 10),
                                //                                 child: Container(
                                //                                   width: 250, // Adjust the width as needed
                                //                                   child: TextFormField(
                                //                                     controller: _Upi_Id_Controller,
                                //                                     style: TextStyle(color: Colors.black),
                                //                                     decoration: InputDecoration(
                                //                                       hintStyle: TextStyle(fontSize: 12,color: Colors.black),
                                //                                       hintText: 'Enter your Mobile Number*', // Set the hint text here
                                //                                     ),
                                //                                     onChanged: (value) {
                                //                                       setState(() {
                                //                                         _Upi_Id_Controller.text = value;
                                //                                       });
                                //                                     },
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                             Align(
                                //                               alignment: Alignment.centerLeft,
                                //                               child: Padding(
                                //                                 padding: const EdgeInsets.only(top: 5, left: 10),
                                //                                 child: Container(
                                //                                     color: Colors.yellow[200],
                                //                                     width: 250, // Adjust the width as needed
                                //                                     child: Text("Format - XXXXXX8624",style: TextStyle(fontSize: 10),)
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                         Visibility(
                                //                           visible: _Upi_Id_Controller.text.length == 10, // Show button only when text length is 10
                                //                           child: InkWell(
                                //                             onTap: () async {
                                //                               if (_Upi_Id_Controller.text.length == 10) {
                                //                                 setState(() {
                                //                                   isSearchingUpi = true;
                                //                                 });
                                //                                 callUPIBankVerification(_Upi_Id_Controller.text, _mobile_number).then((_) {
                                //                                   setState(() {
                                //                                     isSearchingUpi = false;
                                //                                   });
                                //                                 });
                                //                               } else {
                                //                                 Fluttertoast.showToast(
                                //                                   msg: "Enter 10 digit mobile number",
                                //                                   fontSize: 14,
                                //                                   textColor: Colors.red,
                                //                                   backgroundColor: Colors.black,
                                //                                 );
                                //                               }
                                //                             },
                                //                             child: Container(
                                //                               height: 35,
                                //                               width: 60,
                                //                               decoration: BoxDecoration(
                                //                                 color: Colors.green,
                                //                                 borderRadius: BorderRadius.all(Radius.circular(8)),
                                //                               ),
                                //                               child: Center(
                                //                                 child: isSearchingUpi
                                //                                     ? Center(
                                //                                   child: Container(
                                //                                     height: 30,
                                //                                     width: 30,
                                //                                     child:  SpinKitFadingCircle(
                                //                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                //                                     ),
                                //                                   ),
                                //                                 )
                                //                                     : Text(
                                //                                   'Search',
                                //                                   style: TextStyle(color: Colors.white, fontSize: 11),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey, // Set the color of the border
                                                    width: 2.0,         // Set the width of the border
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xffe0dfa2),
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                                                          border: Border.all(
                                                              color: Color(0xffb5b5b5),
                                                              width: 1.5
                                                          )
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 10,top: 10),
                                                                  child: Text('Bank Details',style: TextStyle(color: Colors.black87,fontSize: 13),),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Consumer<ApiProvider>(
                                                      builder: (context, dataProvider, _) {
                                                        List<BankAllData> upiDetailsList = dataProvider.all_Bank_Data_get;
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 2, right: 2, top: 2),
                                                          child: dataProvider.all_Bank_Data_get != null && dataProvider.all_Bank_Data_get.isNotEmpty
                                                              ? Container(
                                                            height: size.height * 0.3,
                                                            child: ListView.builder(
                                                              itemCount: upiDetailsList.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                final event = upiDetailsList[index];
                                                                return Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: (){
                                                                        dataProvider.setSelectedBankId(event.id.toString());
                                                                        dataProvider.toggleSelectionBank(index);
                                                                      },
                                                                      child: ListTile(
                                                                        leading: Radio(
                                                                          value: index,
                                                                          groupValue: dataProvider.selectedIndexBank,
                                                                          onChanged: (value) {
                                                                            dataProvider.setSelectedBankId(event.id.toString());
                                                                            dataProvider.toggleSelectionBank(value! as int );
                                                                          },
                                                                        ),
                                                                        title: Column(
                                                                          children: [
                                                                            Text(
                                                                              "Bank Name: ${event.bankName}",
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "Account Number: XXXXXX${event.accountNumber != null && event.accountNumber!.length >= 4 ? event.accountNumber!.substring(event.accountNumber!.length - 4): ''}",
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        trailing:  InkWell(
                                                                          onTap: () {
                                                                            // if(event.verify_status == 0){
                                                                            //   showDialog(
                                                                            //     context: context,
                                                                            //     builder: (BuildContext context) {
                                                                            //       return AlertDialog(
                                                                            //         title: Text("Confirmation"),
                                                                            //         content: Text("Do you want to Verify your Bank Account Details?"),
                                                                            //         actions: [
                                                                            //           TextButton(
                                                                            //             onPressed: () {
                                                                            //               Navigator.pop(context);
                                                                            //             },
                                                                            //             child: Text("Cancel"),
                                                                            //           ),
                                                                            //           TextButton(
                                                                            //             onPressed: () {
                                                                            //               dataProvider.VerifyBank(event.id!.toInt(), _token);
                                                                            //               dataProvider.getBankDetails(_token);
                                                                            //               dataProvider.notifyListeners();
                                                                            //               Navigator.pop(context);
                                                                            //             },
                                                                            //             child: Text("Verify"),
                                                                            //           ),
                                                                            //         ],
                                                                            //       );
                                                                            //     },
                                                                            //   );
                                                                            // }else if(event.verify_status == 1){
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: Text("Confirmation"),
                                                                                    content: Text("Do you want to Remove your Bank Account Details?"),
                                                                                    actions: [
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text("Cancel"),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          dataProvider.deleteBank(event.id!.toInt(), _token);
                                                                                          dataProvider.getBankDetails(_token);
                                                                                          dataProvider.notifyListeners();
                                                                                          setState(() {
                                                                                            
                                                                                          });
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Text("Remove"),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              );
                                                                            // }

                                                                          },
                                                                          child: Text(
                                                                            "Remove Account",
                                                                            style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.blue,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: Colors.grey, // Customize the color of the divider
                                                                      thickness: 1.0, // Customize the thickness of the divider
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          )
                                                              : Container(),
                                                        );
                                                      },
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            controller: _enterYourName,
                                                            validator: validateName,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter Your Name*', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            validator: validateMobileNumber,
                                                            controller: _enteryourmobileName,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter Mobile Number*', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            validator: validateAccountNumber,
                                                            controller: _enterAccountNumber,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter Account Number*', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            validator: validateState,
                                                            controller: State_text,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter Your State', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            validator: validateAddress,
                                                            controller: Address_text,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter your Address', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, left: 10),
                                                        child: Container(
                                                          width: 250, // Adjust the width as needed
                                                          child: TextFormField(
                                                            validator: validateZipcode,
                                                            controller: Zipcode,
                                                            style: TextStyle(color: Colors.black),
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter your Pin code', // Set the hint text here
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 10, left: 10),
                                                            child: Container(
                                                                width: 240, // Adjust the width as needed
                                                                child: TextFormField(
                                                                  controller: _textIfscCode,
                                                                  style: TextStyle(color: Colors.black),
                                                                  decoration: InputDecoration(
                                                                    hintText: 'IFSC Code*',
                                                                    suffixIcon: Icon(
                                                                      Icons.help_outline,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  validator: validateIFSCCode,
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                        Consumer<ApiProvider>(
                                                          builder: (context, dataProvider, _){
                                                            return   InkWell(
                                                              onTap: () async {
                                                                if (_formKey.currentState!.validate()) {
                                                                  // Check if user's email is verified
                                                                  if (_EmailStatus == "1") {
                                                                    // Set the status to 'searching' before making the API call
                                                                    setState(() {
                                                                      isSearching = true;
                                                                    });

                                                                    try {
                                                                      // Make the API call
                                                                      callBankAccountValidationAPI(
                                                                        _enterYourName.text,
                                                                        _enteryourmobileName.text,
                                                                        _enterAccountNumber.text,
                                                                        _textIfscCode.text,
                                                                        dataProvider,
                                                                        Address_text.text,
                                                                        State_text.text,
                                                                        Zipcode.text,
                                                                      ).then((_) {
                                                                        setState(() {
                                                                          isSearching = false;
                                                                        });
                                                                      });
                                                                    } catch (e) {
                                                                      // Handle any errors from the API call
                                                                      setState(() {
                                                                        isSearching = false;
                                                                      });
                                                                      // Display error message or handle the error as per your requirement
                                                                    }
                                                                  } else {
                                                                    // Navigate to another screen for email verification
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmailAddress()));
                                                                  }
                                                                }

                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                width: 50,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                ),
                                                                child: Center(
                                                                  child: isSearching
                                                                      ? Center(
                                                                    child: Container(
                                                                      height: 30,
                                                                      width: 30,
                                                                      child:   SpinKitFadingCircle(
                                                                        color: Colors.redAccent,
                                                                        size: 50.0,
                                                                      )
                                                                    ),
                                                                  )
                                                                      : Text(
                                                                    'Search',
                                                                    style: TextStyle(color: Colors.white, fontSize: 11),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },

                                                        )

                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 150,
                                          width: double.infinity,
                                          child: Image.asset(
                                            ImageAssets.no_events_available,fit: BoxFit.contain,

                                          ),
                                        ),
                                        Text("Coming Soon...",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _handleSearch(ApiProvider dataProvider) async {
    if (_formKey.currentState!.validate()) {
      // Set the status to 'searching' before making the API call
      setState(() {
        isSearching = true;
      });

      // Make the API call
      await callBankAccountValidationAPI(
        _enterYourName.text,
        _enteryourmobileName.text,
        _enterAccountNumber.text,
        _textIfscCode.text,
        dataProvider, Address_text.text,State_text.text,Zipcode.text
      );

      // Reset the status after the API call is complete
      setState(() {
        isSearching = false;
      });
    }
  }
  Future<void> ShowWithdrawPopup(String token, String Price) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: WithdrawSuccessfulPopup(Price),

        );
        setState(() {

        });
      },
    );
  }
}

class YourBottomSheet extends StatefulWidget {
  final List<UpiDetailsList> upiDetailsList;
  var _token,mobile_number;
  YourBottomSheet(this.upiDetailsList,this._token,this.mobile_number);

  @override
  _YourBottomSheetState createState() => _YourBottomSheetState();
}
class _YourBottomSheetState extends State<YourBottomSheet> {
  int selectedIndex = -1;
  bool _isConfirming = false;
  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = -1;
      } else {
        selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Select an UPI ID',
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: widget.upiDetailsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final event = widget.upiDetailsList[index];

                  return InkWell(
                    onTap: () {
                      _toggleSelection(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10),
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: index == selectedIndex ? 2 : 1,
                            color: index == selectedIndex
                                ? Colors.green
                                : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                      "Name :", style: TextStyle(fontSize: 13)
                                  ),
                                  Text(
                                    event.name.toString(),
                                    style: TextStyle(fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text("UPI ID :",
                                      style: TextStyle(fontSize: 13)),
                                  Text(
                                    event.upiId.toString(),
                                    style: TextStyle(fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet on Cancel
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isConfirming = true;
                      });

                      if (selectedIndex != -1) {
                        UpiDetailsList selectedUpi = widget.upiDetailsList[selectedIndex];
                        OtpSendModel(selectedUpi, widget._token,widget.mobile_number).then((_) {
                          // Set _isConfirming back to false after the OTP request is completed
                          setState(() {
                            _isConfirming = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedIndex != -1 ? Colors.green : Colors.grey,
                      ),
                      child:  Center(
                        child: _isConfirming
                            ? Center(child:  SpinKitFadingCircle(color: Colors.white,)) // Show progress indicator
                            : Text(
                          'Confirm',
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
      ),
    );
  }



  Future<void> OtpSendModel(UpiDetailsList selectedUpi,String token,String user_Mobile) async {
    final url = 'https://admin.googly11.in/api/send-upi-otp';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Error: ${response.statusCode}');
      print('Error::::: ${response.body}');
      if (response.statusCode == 200) {
        OtpResponseUpi otpResponseUpi=OtpResponseUpi.fromJson(json.decode(response.body));
        if(otpResponseUpi.status == 1){
          Fluttertoast.showToast(msg: "${otpResponseUpi.message}",fontSize: 14,backgroundColor: Colors.green,textColor: Colors.white);
          Navigator.of(context).pop();
          showOtpDialog(selectedUpi,token,user_Mobile);
        }else{
          Fluttertoast.showToast(msg: "${otpResponseUpi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      } else if(response.statusCode == 400){
        OtpResponseUpi otpResponseUpi=OtpResponseUpi.fromJson(json.decode(response.body));
        if(otpResponseUpi.status == 1){
          Fluttertoast.showToast(msg: "${otpResponseUpi.message}",fontSize: 14,backgroundColor: Colors.green,textColor: Colors.white);
        }else{
          Fluttertoast.showToast(msg: "${otpResponseUpi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
        // Request failed, handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
  }

  Future<void> showOtpDialog(UpiDetailsList upiDetailsList, String token, String user_Mobile) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Set to false to prevent dismissing by tapping outside or pressing back button
      builder: (BuildContext context) {
        return AlertDialog(
          content: AlertDialogClass(upiDetailsList, token, user_Mobile),
        );
      },
    );
  }

}


class AlertDialogClass extends StatefulWidget {
  final UpiDetailsList upiDetailsList;
  var _token , userMobile;
  AlertDialogClass(this.upiDetailsList,this._token,this.userMobile);

  @override
  _AlertDialogState createState() => _AlertDialogState();
}
class _AlertDialogState extends State<AlertDialogClass> {
  TextEditingController Otp_Controller=TextEditingController();
  bool isSearching=false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey[500],
            margin: EdgeInsets.all(8),
            child: Center(
                child: Text(
                  "Enter OTP to Save UPI Details +91 XXXXXX${widget.userMobile != null && widget.userMobile.length >= 4 ? widget.userMobile.substring(widget.userMobile.length - 4) : ''}",
                  style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        width: 130, // Adjust the width as needed
                        child: TextFormField(
                          controller:Otp_Controller ,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 12,color: Colors.black),
                            hintText: 'Enter OTP*', // Set the hint text here
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Consumer<ApiProvider>(
                    builder: (context, dataProvider, _){
                      return InkWell(
                        onTap: () async{
                          if(Otp_Controller.text.isNotEmpty && Otp_Controller.text.length == 6){
                            setState(() {
                              isSearching = true;
                            });
                            verifyUpiOtp(widget._token,Otp_Controller.text,dataProvider).then((_) {
                              setState(() {
                                isSearching = false;
                              });
                            });
                          }else{
                            Fluttertoast.showToast(msg: "Please Enter Your Otp!",fontSize: 14,textColor: Colors.black,backgroundColor: Colors.red);
                          }

                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Center(
                            child: isSearching
                                ? Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child:  SpinKitFadingCircle(
                                  color: Colors.redAccent,
                                  size: 50.0,
                                )
                              ),
                            )
                                : Text(
                              'Save',
                              style: TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                      );
                    }

                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Resend Otp",
                style: TextStyle(
                    color: Colors.blue,fontSize: 13,fontWeight: FontWeight.bold
                ),),
            ),
          )
        ],
      ),
    );
  }

  Future<void> verifyUpiOtp(String token, String otp,ApiProvider api_provider) async {
    final url = 'https://admin.googly11.in/api/verify-upi-otp';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {'otp': otp},
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        OtpVerifyModel_Upi otpVerifyModel_Upi=OtpVerifyModel_Upi.fromJson(json.decode(response.body));
        if(otpVerifyModel_Upi.status == 1){
          _sendSelectedUpiToServer(widget.upiDetailsList,widget._token,api_provider);
        } else{
          Fluttertoast.showToast(msg: "${otpVerifyModel_Upi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      } else if(response.statusCode == 400){
        OtpVerifyModel_Upi otpVerifyModel_Upi=OtpVerifyModel_Upi.fromJson(json.decode(response.body));
        if(otpVerifyModel_Upi.status == 1){
          Fluttertoast.showToast(msg: "${otpVerifyModel_Upi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        } else{
          Fluttertoast.showToast(msg: "${otpVerifyModel_Upi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      }else if(response.statusCode == 404){
        OtpVerifyModel_Upi otpVerifyModel_Upi=OtpVerifyModel_Upi.fromJson(json.decode(response.body));
        if(otpVerifyModel_Upi.status == 1){
          Fluttertoast.showToast(msg: "${otpVerifyModel_Upi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        } else{
          Fluttertoast.showToast(msg: "${otpVerifyModel_Upi.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
  }

  void _sendSelectedUpiToServer(UpiDetailsList selectedUpi,String token,ApiProvider apiProvider) async {
    final String apiUrl = 'https://admin.googly11.in/api/store-upi-details';

    final Map<String, dynamic> requestBody = {
      'upiId': selectedUpi.upiId,
      'name': selectedUpi.name,
      'pspName': selectedUpi.pspName,
      'code': selectedUpi.code,
      'payeeType': selectedUpi.payeeType,
      'bankIfsc': selectedUpi.bankIfsc,
    };

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Replace with your actual token
    };
    print("Upi_Id"+selectedUpi.upiId.toString());
    print("name"+selectedUpi.name.toString());
    print("pspName"+selectedUpi.pspName.toString());
    print("code"+selectedUpi.code.toString());
    print("payeeType"+selectedUpi.payeeType.toString());
    print("bankIfsc"+selectedUpi.bankIfsc.toString());

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );
      print("response_Body"+response.body);
      print("response"+response.statusCode.toString());

      if (response.statusCode == 200) {
        SendDataToServerUpiDetails sendDataToServerUpiDetails=SendDataToServerUpiDetails.fromJson(json.decode(response.body));
        if(sendDataToServerUpiDetails.status == 1){
          apiProvider.getUpiDetails(token);
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "${sendDataToServerUpiDetails.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);

        }else{
          Fluttertoast.showToast(msg: "${sendDataToServerUpiDetails.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      } else if(response.statusCode == 400){
        SendDataToServerUpiDetails sendDataToServerUpiDetails=SendDataToServerUpiDetails.fromJson(json.decode(response.body));
        if(sendDataToServerUpiDetails.status == 1){
          Fluttertoast.showToast(msg: "${sendDataToServerUpiDetails.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }else{
          Fluttertoast.showToast(msg: "${sendDataToServerUpiDetails.message}",fontSize: 14,backgroundColor: Colors.black,textColor: Colors.white);
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

class WithdrawSuccessfulPopup extends StatefulWidget {
  var price;
  WithdrawSuccessfulPopup(this.price);

  @override
  WithdrawAlertState createState() => WithdrawAlertState();
}
class WithdrawAlertState extends State<WithdrawSuccessfulPopup> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color: Colors.lightBlue[100],
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/celebration.gif',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your withdraw request has been sent successfully",
                style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                "\u20B9 ${widget.price}",
                style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15), // Add spacing
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTransactions()));// Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color// Button height and width
                ),
                child: Text('OK'),
              ),

            ],
          ),

        ],
      ),
    );
  }

}
