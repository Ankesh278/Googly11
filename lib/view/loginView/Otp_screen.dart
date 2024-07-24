import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:world11/view/loginView/OtpLoginModel/LoginOtpModel.dart';
import 'package:world11/view/loginView/OtpLoginModel/Otp_login.dart';
import '../../App_Widgets/CustomText.dart';
import '../../Notification_Service/Notification_Service_Class.dart';
import '../../bottom_navigation_bar/bottom_navigation_screen.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import 'login_view.dart';

class OtpView extends StatefulWidget {
  final mobile_number;
  OtpView({Key? key,required this.mobile_number}) : super(key: key);

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _resendLoading = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;
  bool _isTimerRunning = false;
  Notification_Services notification_services=Notification_Services();
  String device_Token='';
  bool isLoading= false;
  @override
  void initState() {
    super.initState();
    notification_services.requestNotificationPermission();
    notification_services.firebaseInit(context);
    // notification_services.isTokenRefresh();
    notification_services.getDeviceToken().then((value){
      device_Token=value;
      print("device_Id:::::::::"+value);
    });
    startResendTimer();
    // Initialize SmsAutoFill
    SmsAutoFill().listenForCode;
  }

  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen((result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //       if(!isDeviceConnected && isAlertSet == false){
  //         showDialogBox();
  //         setState(() {
  //           isAlertSet = true;
  //         });
  //       }
  //     },
  //     );

  showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('No Connection'),
        content: const Text('Please check your internet connectivity'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              setState(() {
                isAlertSet = false;
              });
              isDeviceConnected = await InternetConnectionChecker().hasConnection;
              if (!isDeviceConnected) {
                showDialogBox(); // Pass the context here
                setState(() {
                  isAlertSet = true;
                });
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    subscription.cancel();
    super.dispose();
  }


  void startResendTimer() {
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _resendTimer?.cancel();
          _resendTimer = null;
          _isTimerRunning = false;
        }
      });
    });
    _isTimerRunning = true;
  }

  Future<void> signUp(String phone) async {
    final String apiUrl = 'https://admin.googly11.in/api/signup';

    // Set up the request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    // Set up the request body
    Map<String, String> body = {
      'phone': phone,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        LoginOtpModel otpModel=LoginOtpModel.fromJson(jsonDecode(response.body));
        print('Response: ${response.body}');
        print('Response: ${otpModel.otp}');
        if(otpModel.status==1){
          Fluttertoast.showToast(msg: "Otp send successfully");
        }else if(otpModel.status==0){
          Fluttertoast.showToast(msg: "Please Enter correct number");
        }
      } else {
        // Handle error response
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:Stack(
        children: [

          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(image: AssetImage(ImageAssets.bagroundImage),fit: BoxFit.cover,),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: size.height *0.43,
              width: size.width *.8,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4)
              ),
              child: Column(
                children: [
                  SizedBox(height: 15,),
                  CustomPaddedText(
                    text: 'Verify with Otp',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16
                  ),
                  ),

                  SizedBox(height: 10,),
                  CustomPaddedText(
                    text: 'OTP sent to your mobile no. +91 ${widget.mobile_number}',
                    style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginView()));
                    },
                    child: Text(
                      'Change',
                       style: TextStyle(
                        color: Colors.white, // Use a color that represents a link
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Add underline for a typical link appearance
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: PinCodeTextField(
                      appContext: context,
                       keyboardType: TextInputType.number,
                      obscureText: false,
                      textStyle: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      cursorHeight: 13,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 35,
                        fieldWidth: 30,
                        activeFillColor: Colors.white,
                      ),
                      length: 6,
                      controller: _otpController,
                      onCompleted: (otp) {
                        // Handle OTP completion
                        print("Completed: $otp");
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Resend OTP in ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' $_resendSeconds s',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_resendLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:  SpinKitFadingCircle(
                              color: Colors.white,
                              //strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      GestureDetector(

                        onTap: () async {
                          _resendSeconds=30;
                          if (!_isTimerRunning && !_resendLoading) {
                            setState(() {
                              _resendLoading = true;
                            });

                            // Perform OTP resend logic
                            await signUp(widget.mobile_number);

                            startResendTimer(); // Move the timer start outside the if condition

                            setState(() {
                              _resendLoading = false;
                            });
                          } else {
                            // Handle case where resend is not allowed yet or already in progress
                            print('Resend not allowed yet or already in progress...');
                          }
                        },
                        child: Text(
                          '  Resend',
                          style: TextStyle(
                            color: _isTimerRunning || _resendLoading ? Colors.grey : Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: _isTimerRunning || _resendLoading
                                ? TextDecoration.none
                                : TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: InkWell(
                      onTap: (){
                        if(_otpController.text.length<6 || _otpController.text.isEmpty){
                          Get.snackbar(
                            "Required Field",
                            "Please fill all fields ",
                            icon: Icon(
                              Icons.pin,
                              color: Colors.red,
                            ),
                            backgroundColor: Colors.white,
                            colorText: Colors.red[900],
                          );
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });
                          Otp_Login(_otpController.text,device_Token).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: isLoading
                                ? Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child:   SpinKitFadingCircle(
                                  color: Colors.redAccent,
                                  size: 50.0,
                                )
                              ),
                            ) : CustomPaddedText(
                              text: 'Verify',style: TextStyle(
                                color: Colors.white,fontWeight: FontWeight.bold,
                            ),),),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  CustomPaddedText(
                    text: 'Facing any issue? Please email us at:',
                    style: TextStyle(color: Colors.grey[400],fontSize: 11,fontWeight: FontWeight.bold),),
                  CustomPaddedText(
                    text: 'support@Googly11.com',
                    style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ) ,
    );
  }

  Future<void> Otp_Login(String Otp,String Device_token) async {
    final String apiUrl = 'https://admin.googly11.in/api/otpverify';
    String device_type='';
    if(Platform.isAndroid){
      device_type="android";
    } else if(Platform.isIOS){
      device_type="ios";
    }

    // Set up the request headers
    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    // Set up the request body
    Map<String, String> body = {
      'otp': Otp,
      'device_token':Device_token,
      'device_type': device_type
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      print('API call failed with status ${response.statusCode}');
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        OtpLogin otpModel=OtpLogin.fromJson(jsonDecode(response.body));
        if(otpModel.status==1){
          SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
          sharedPreferences.setString("token", otpModel.accessToken);
          sharedPreferences.setString("mobile_number", otpModel.user!.phone);
          sharedPreferences.setString("invite_code", otpModel.user!.invite_code);
          sharedPreferences.setString("UserName", otpModel.user!.userName);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                (route) => false,
          );
          Fluttertoast.showToast(msg: "Login successfully");
        }else{
          Fluttertoast.showToast(msg: "Please enter correct Otp",textColor: Colors.white,backgroundColor: Colors.red);
        }
      } else if(response.statusCode==401){
        OtpLogin otpModel=OtpLogin.fromJson(jsonDecode(response.body));
         if(otpModel.status==0){
           Fluttertoast.showToast(msg: "Please enter correct Otp",textColor: Colors.white,backgroundColor: Colors.red);
        }else{
           Fluttertoast.showToast(msg: "Please enter correct Otp",textColor: Colors.white,backgroundColor: Colors.red);
         }
        // Handle error response
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }
}

