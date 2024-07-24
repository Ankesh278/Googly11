import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:world11/bottom_navigation_bar/bottom_navigation_screen.dart';
class Notification_Services{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
 final  FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async{
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("user grant permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("user grant provisional permission");
    }else{
      print("user denied permission");
    }
  }
  void initLocalNotifications(BuildContext context,RemoteMessage message)async{
    var androidInitLocalNotification=const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings =const  DarwinInitializationSettings();

    var initializationSetting= InitializationSettings(
        android: androidInitLocalNotification,
        iOS: iosInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload){
        handleMessage(context, message);
      }
    );
  }
  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {
      if(kDebugMode){
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());
      print("type:::::::::::"+message.data['redirect'].toString());
    }
      if(Platform.isAndroid){
        initLocalNotifications(context,message);
        showNotification(message);
      }else{
        // initLocalNotifications(context,message);
        showNotification(message);
      }

    });
  }

  Future<void> showNotification(RemoteMessage message) async{

    AndroidNotificationChannel channel=AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
        importance: Importance.max
    );

    AndroidNotificationDetails androidNotificationDetails= AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: "This is a test Notification",
        importance: Importance.high,
        priority:  Priority.high,
        ticker: 'ticker',
    );

  const  DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    NotificationDetails notificationDetails= NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero,(){
      // Assuming message.notification!.body contains the JSON data
      String jsonData = message.notification!.body.toString();

      // Decode the JSON data
      // Map<String, dynamic> matchData = jsonDecode(jsonData);

      // // Extract team names from the decoded JSON data
      // String team1 = matchData['team1'] ?? 'Team 1'; // If 'team1' key is absent, default to 'Team 1'
      // String team2 = matchData['team2'] ?? 'Team 2'; // If 'team2' key is absent, default to 'Team 2'

      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          '$jsonData', // Display team names in the notification
          notificationDetails,
      );
    });

  }

  void handleMessage(BuildContext context,RemoteMessage message){
    print("type:::::::::::"+message.data['redirect'].toString());
    if(message.data['redirect'].toString() == 'lineup') {
      Navigator.push(context,MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
    }

  }

  Future<String> getDeviceToken() async{
   String? token= await messaging.getToken();
   return token!;
  }
  void isTokenRefresh() async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }
}