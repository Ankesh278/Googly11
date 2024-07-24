import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../bottom_navigation_bar/bottom_navigation_screen.dart';

class ConnectionLostScreen extends StatefulWidget {


  const ConnectionLostScreen({Key? key,}) : super(key: key);

  @override
  State<ConnectionLostScreen> createState() => _ConnectionLostScreenState();
}

class _ConnectionLostScreenState extends State<ConnectionLostScreen> {

  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // subscription = Connectivity().onConnectivityChanged.listen((result) async {
    //   isDeviceConnected = await InternetConnectionChecker().hasConnection;
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/10_Connection Lost.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.065,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 25,
                    color: Color(0xFF59618B).withOpacity(0.17),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6371AA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  isDeviceConnected = await InternetConnectionChecker().hasConnection;
                  if (isDeviceConnected) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
                          (route) => false,
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Check Your Internet Connection",backgroundColor: Colors.black,textColor: Colors.white);
                  }
                },
                child: Text(
                  "retry".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
