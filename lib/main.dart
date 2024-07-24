import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:upgrader/upgrader.dart';
import 'package:world11/ApiCallProviderClass/API_Call_Class.dart';
import 'package:world11/firebase_options.dart';
import 'package:world11/view/splash_screen/Splash_Screen.dart';
import 'package:provider/provider.dart';
import 'Localization/LocalizationClass.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader().initialize();
  await Upgrader.clearSavedSettings();
  //FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FlutterDownloader.initialize(debug: true);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp();
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int internetChanged = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      debugPrint(status.toString());
      switch (status) {
        case InternetConnectionStatus.connected:
          if (internetChanged == 1) {
            Get.snackbar(
              "Internet is back",
              "Great, your internet connection is restored.",
              icon: Icon(
                Icons.signal_wifi_4_bar_lock_rounded,
                color: Colors.green,
              ),
              backgroundColor: Colors.white,
              colorText: Colors.green[900],
            );
            setState(() {
              internetChanged = 0;
            });
          }
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            internetChanged++;
          });
          Get.snackbar(
            "No Internet Connection",
            "Please check your internet.",
            icon: Icon(
              Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
              color: Colors.red,
            ),
            backgroundColor: Colors.white,
            colorText: Colors.red[900],
          );
          break;
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Googly11',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: Locale('en', 'US'),
      translations: Languages(),
      fallbackLocale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
