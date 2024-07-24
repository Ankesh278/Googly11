import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import '../view/NoInternetScreen.dart';
import 'League.dart';
import 'account.dart';
import 'controller_bottom_navigation.dart';
import 'home_screen.dart';
import 'more.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final controller = Get.put(BottomNavigationController());
  late StreamSubscription subscription;
  var isDeviceConnected=false;
  bool isAlertSet=false;
  final List<Widget> _pages = [
    HomeScreen(),
    League(),
    Account(),
    More(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getConnectivity();
  }
  // getConnectivity() =>
  //     subscription = Connectivity().onConnectivityChanged.listen((result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //       if(!isDeviceConnected && isAlertSet == false){
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => ConnectionLostScreen()),
  //         );
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
              if (isDeviceConnected) {
                // Trigger a rebuild of the widget tree
                setState(() {});
              } else {
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
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.red,
          type: BottomNavigationBarType.shifting,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage(ImageAssets.league),),
              label: 'Winners',
            ),
            
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account_outlined),
              label: 'Account',
            ),
            
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_open_rounded),
              label: 'Refer & Earn',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
