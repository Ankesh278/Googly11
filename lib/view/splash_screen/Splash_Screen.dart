import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/bottom_navigation_bar/bottom_navigation_screen.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import 'package:world11/view/loginView/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
   AnimationController? _controller;
   Animation<double>? _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller!);

    _controller!.forward();
    Future.delayed(const Duration(seconds: 4), () {
      navigateToScreen();
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  void navigateToScreen() {
    checkPreferences().then((hasValues) {
      if (hasValues) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.splashScreen),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        // Animated text
        AnimatedPositioned(
          duration: Duration(seconds: 4), // Should match the duration of the AnimationController
          curve: Curves.easeInOut,
          bottom: MediaQuery.of(context).size.height * 1.0 * (1.0 - _animation!.value), // Adjust the value for the desired bottom position
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.black.withOpacity(0.0),
            child: Center(
              child: Image(
                image: AssetImage(
                  ImageAssets.made_in_india_logo
                ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<bool> checkPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? user_name = prefs.getString("UserName");
    String? invite_code = prefs.getString("invite_code");
    String? mobile_number = prefs.getString("mobile_number");
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("user_name");
    print("email" + email.toString());
    print("user_id" + userName.toString());
    print('mobile' + mobile_number.toString());
    print("invite_code" + invite_code.toString());
    print('user_name' + user_name.toString());
    return token != null && user_name != null && invite_code != null && mobile_number != null || email != null && userName != null;
  }
}
