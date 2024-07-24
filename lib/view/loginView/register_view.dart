import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../App_Widgets/CustomText.dart';
import '../../App_Widgets/custom_textField.dart';
import '../../resourses/Image_Assets/image_assets.dart';
import 'login_view.dart';


class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}
class _RegistrationViewState extends State<RegistrationView> {
  final registration = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(

      body:SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image(image: AssetImage(ImageAssets.bagroundImage),fit: BoxFit.cover,),
            ),
            Container(
              width: double.infinity,
              height: 600,
              decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.5)
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 100, left: 40),
              height: size.height *.6,
              width: size.width *.8,
              decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.5)
              ),
              child: Column(
                children: [
                  SizedBox(height: 1,),
                  CustomPaddedText(
                    text: 'Register',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20
                  ),),
                 Form(
                   key: registration,
                   child: Column(
                     children: [
                       SizedBox(height: 20,),
                       CustomTextField(
                         labelText: "Enter Email",
                         prefixIcon: Icons.ice_skating,
                       ),
                       SizedBox(height: 20,),
                       CustomTextField(
                         prefixIcon: Icons.ice_skating,
                         labelText: "Enter Email",
                       ),
                       SizedBox(height: 20,),
                       CustomTextField(
                         prefixIcon: Icons.ice_skating,
                         labelText: "Enter Email",
                       ),
                       SizedBox(height: 20,),
                       CustomTextField(
                         prefixIcon: Icons.ice_skating,
                         labelText: "Enter Email",
                       ),
                       SizedBox(height: 20,),
                       CustomTextField(
                         prefixIcon: Icons.ice_skating,
                         labelText: "Enter Email",
                       ),
                     ],
                   ),
                 ),

                  SizedBox(height: 40,),
                  InkWell(
                    onTap: (){
                      if(registration.currentState!.validate()){
                        return null;
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Center(
                          child: CustomPaddedText(
                            text: 'Register',style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold
                          ),)),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 90),
                width: double.infinity,
                height: size.height *0.15,
                decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.5)
                ),
                child: Column(
                  children: [
                    CustomPaddedText(
                      padding: EdgeInsets.only(top: 50),
                      text: 'By Registering/Logging you accept you are 18+ and you accept\n our Terms & Condition',
                      style: TextStyle(color: Colors.white,fontSize: 12,),),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 610,left: 120),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(LoginView());
                    },
                    child: CustomPaddedText(
                        style: TextStyle(
                            color: Colors.white
                        ),
                        text: 'Existing User  ?'),
                  ),
                  InkWell(
                    onTap: (){
                      Get.to(LoginView());
                    },
                    child: CustomPaddedText(
                      text: 'LOGINS',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomPaddedText(
                text: 'GOOGLY11',
                style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ) ,
    );
  }
}
