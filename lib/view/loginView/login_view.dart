import 'dart:async';
import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/view/loginView/OtpLoginModel/LoginOtpModel.dart';
import 'package:world11/view/loginView/Otp_screen.dart';
import '../../App_Widgets/CustomText.dart';
import '../../bottom_navigation_bar/bottom_navigation_screen.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import 'package:http/http.dart' as http;

import 'google_signin_api.dart';

class LoginView extends StatefulWidget {
   var user;
   LoginView({Key? key,  this.user}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _loginKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;

  final TextEditingController _phoneController = TextEditingController();
  bool isAgeConfirmed = false;
  bool receiveUpdates = false;
  String dob='';

  TextEditingController date_of_birth=TextEditingController();
  DateTime selectedDate = DateTime.now();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getConnectivity();
  }
  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen((result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //       if(!isDeviceConnected && isAlertSet == false){
  //
  //         showDialogBox();
  //         setState(() {
  //           isAlertSet = true;
  //         });
  //       }
  //     },
  //     );



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date_of_birth.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }

  }

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
  String formatDate(String dob) {
    // Assuming dob is in the format "YYYY-MM-DD HH:mm:ss"
    List<String> parts = dob.split(" ");
    return parts[0]; // Only taking the date part
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
                height: size.height *0.5,
                width: size.width *.8,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                ),
              child: Column(
                children: [
                  SizedBox(height: 15,),
                 CustomPaddedText(
                     text: 'Login/Register',style: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                   fontSize: 16
                 ),),
                  SizedBox(height: 15,),
                Form(
                  key: _loginKey,
                  child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6,right: 6),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        height: 40, // Set your desired height
                        // Set your desired width
                        child: TextFormField(
                          controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number'  ;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10), // Adjust content padding if needed
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            prefixIcon: Icon(Icons.phone, color: Colors.black,size: 15),
                            hintText: "Enter mobile number"
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 6.0, top: 6, right: 6),
                    //   child: GestureDetector(
                    //     onTap: () => _selectDate(context),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       ),
                    //       height: 40,
                    //       child: AbsorbPointer(
                    //         child: TextField(
                    //           controller: date_of_birth,
                    //           decoration: InputDecoration(
                    //             hintText: "Enter date of birth",
                    //              // Center the hint text
                    //             contentPadding: EdgeInsets.only(left: 15.0,), // Add left margin for hint text
                    //             border: InputBorder.none,
                    //             prefixIcon: Icon(Icons.calendar_month, color: Colors.black,size: 15),
                    //           ),
                    //           style: TextStyle(color: Colors.black),
                    //
                    //           textAlign: TextAlign.justify, // Center the input text
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                  ],
                ),
              ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          // if (states.contains(MaterialState.selected)) {
                          //   return Colors.white; // Set the background color when checked
                          // }
                          return Colors.white;// Use the default background color when unchecked
                        }),
                        value: isAgeConfirmed,
                        checkColor: Colors.green,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            isAgeConfirmed = value!;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black     , // Set the desired border color here
                            width: 2.0, // Set the desired border width here
                          ),
                          borderRadius: BorderRadius.circular(4.0), // Set the desired border radius here
                        ),
                      ),
                      Text('I confirm that I am 18+ years in age',style: TextStyle(color: Colors.white,
                          fontSize: 12,fontWeight: FontWeight.bold),)
                    ],
                  ),

              SizedBox(height: 5,),
                  InkWell(
                    onTap: () async {
                      DateTime currentDate = DateTime.now();
                      int age = currentDate.year - selectedDate.year;
                      if (currentDate.month < selectedDate.month || (currentDate.month == selectedDate.month && currentDate.day < selectedDate.day)) {
                        age--;
                      }
                      print("Age:::::::"+age.toString());
                      if (_phoneController.text == "" || _phoneController.text.isEmpty) {
                        Get.snackbar(
                          "Required Field",
                          "Please enter your mobile number",
                          icon: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                          backgroundColor: Colors.white,
                          colorText: Colors.red[900],
                        );
                      } else if (!isAgeConfirmed) {
                        Get.snackbar(
                          "Required Field",
                          "Please click on Checkbox to confirm",
                          icon: Icon(
                            Icons.check,
                            color: Colors.red,
                          ),
                          backgroundColor: Colors.white,
                          colorText: Colors.red[900],
                        );
                      } else if (_phoneController.text.length != 10) {
                        Get.snackbar(
                          "Extra Digit",
                          "Please Enter only Ten digit number",
                          icon: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                          backgroundColor: Colors.white,
                          colorText: Colors.red[900],
                        );
                      }
                      // else if (age < 18) {
                      //   Get.snackbar(
                      //     "Age Restriction",
                      //     "You must be at least 18 years old to register",
                      //     icon: Icon(
                      //       Icons.warning,
                      //       color: Colors.red,
                      //     ),
                      //     backgroundColor: Colors.white,
                      //     colorText: Colors.red[900],
                      //   );
                      // }
                      else {
                        signUp(_phoneController.text);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: _isLoading
                              ?  SpinKitFadingCircle(color: Colors.white)
                              : CustomPaddedText(
                            text: 'CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Get offers and updates on Whatsapp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                       // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: receiveUpdates,
                      onChanged: (value) {
                        setState(() {
                          receiveUpdates = value;
                        });
                      },
                      activeColor: Colors.green, // Set the color of the active switch
                    ),
                  ],
                  ),
                ),
              InkWell(
                onTap: () async {
                  //signInWithGoogle();
                  User? users = await _signInWithGoogle();
                  var user = await LoginAPi.login();
                  if (user != null) {
                    print('Login successfully!!!!!');
                    print("User::::::::::"+user.id);
                    showAlert();
                    print(user.photoUrl);
                    print(user.email.toString());
                    print(user..toString());
                    final SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setString('email_user', user.email.toString());
                    sp.setString('user_name', user.displayName.toString());
                    sp.setString('user_photo', user.photoUrl.toString());
                    print("user_name:::: "+user.displayName.toString());
                    print("user_name:::: "+user.photoUrl.toString());
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(ImageAssets.Google),),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
                ],
              ) ,
             )
           ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Align(
              alignment: Alignment.topCenter,
              child: CustomPaddedText(
                text: 'GOOGLY11',
                style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
          ),
         ]
       )
     );
    }


  Future<void> signUp(String phone) async {
    setState(() {
      _isLoading = true;
    });
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
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        LoginOtpModel otpModel=LoginOtpModel.fromJson(jsonDecode(response.body));
        print('Response: ${response.body}');
        print('Response: ${otpModel.otp}');
        if(otpModel.status==1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => OtpView(mobile_number: _phoneController.text)));
          Fluttertoast.showToast(msg: "Otp send successfully");
        }else if(otpModel.status==0){
          Fluttertoast.showToast(msg: "Please Enter correct number");
        }
      } else {
        // Handle error responseg
        print('API call failed with status ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  void showAlert() async {
    QuickAlert.show(
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
              (route) => false,
        );
      },
      context: context,
      title: 'Login Successfully',
      type: QuickAlertType.success,
    );
  }


  Future<User?> _signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in, googleUser will be null
      if (googleUser == null) {
        throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Sign in failed with error: $e');
      return null;
    }
  }


}





