import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:world11/Model/UserInfoUpdate/UserInfoUpdate.dart';
import '../Model/DeleteAccount/DeleteAccountResponse.dart';
import '../Model/UserAllData/GetUserAllData.dart';
import '../view/loginView/google_signin_api.dart';
import '../view/loginView/login_view.dart';

class MyInfo_Setting extends StatefulWidget {
  const MyInfo_Setting({super.key});

  @override
  State<MyInfo_Setting> createState() => _MyInfo_SettingState();
}

class _MyInfo_SettingState extends State<MyInfo_Setting> {
  TextEditingController userController=TextEditingController();
  TextEditingController date_of_birth=TextEditingController();
  DateTime selectedDate = DateTime.now();

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
  var selectedLanguage="en_US";
  String _token= '';
  int selectedValue=0;
  String userName='';
  String dob='';
  String gender='';
  @override
  void initState() {
    super.initState();
    getSpData();
  }

  Future<void> getSpData() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String token=  sharedPreferences.getString("token").toString();
    String selected_Value_Locale=  sharedPreferences.getString("Local_value").toString();
    setState(() {
      _token=token;
      selectedLanguage=selected_Value_Locale;
      fetchData(_token);
    });
  }

  void updateUserInfo(String Name,String gender,String dateOfBirth) async {
    String bearerToken = '$_token';
    // Define the API endpoint
    String apiUrl = 'https://admin.googly11.in/api/user_info_update';
    // Prepare the form data
    Map<String, String> formData = {
      'name': '$Name',
      'gender': '$gender',
      'dob': '$dateOfBirth',
    };

    // Prepare the headers
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };

    // Make the POST request
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: formData,
        headers: headers,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        UserInfoUpdate userInfoUpdate= UserInfoUpdate.fromJson(jsonDecode(response.body));
        if(userInfoUpdate.status== 1){
          Fluttertoast.showToast(msg: "Your Details is update successfully",textColor: Colors.green,backgroundColor: Colors.white);
          fetchData(_token);
          Navigator.of(context).pop();
        }
        print('Request successful: ${response.body}');
      } else if(response.statusCode==400){
        UserInfoUpdate userInfoUpdate= UserInfoUpdate.fromJson(jsonDecode(response.body));
        if(userInfoUpdate.status== 0){
          Fluttertoast.showToast(msg: "Bad Request"+userInfoUpdate.message,textColor: Colors.green,backgroundColor: Colors.white);
        }
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during the HTTP request: $e');
    }
  }

  Future<void> fetchData(String token) async {
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
            userName=userAllData.user!.name;
            dob=userAllData.user!.userKyc!.dob;
            gender=userAllData.user!.userKyc!.gender;
            print("gender::::::::"+gender);
            print("dob::::::::"+dob);
            if (gender == 'M') {
              selectedValue = 1;
            } else if (gender == 'F') {
              selectedValue = 2;
            } else if (gender == 'O') {
              selectedValue = 3;
            }
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

  @override
  Widget build(BuildContext context) {
    String formattedDOB = dob.isNotEmpty ? formatDate(dob) : "Enter date of birth";
    return Scaffold(
      appBar: AppBar(
        title: Text('MY_INFO_setting'.tr,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Divider( // Add a Divider here
                color:  Color(0xFFEDF0EE),  // Customize the color of the divider
                thickness: 5.0,   // Adjust the thickness of the divider
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: Text('Select a language'),
                            content: Container(
                              height: 150,
                              width: 200,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('English'),
                                    leading: Radio(
                                      value: 'en_US',
                                      groupValue: selectedLanguage.isNotEmpty ? selectedLanguage : 'en_US',
                                      onChanged: (value) async {
                                        setState(()  {
                                          selectedLanguage = value! as String;
                                        });
                                        SharedPreferences sp =await SharedPreferences.getInstance();
                                        sp.setString("Local_value", value! as String);
                                        Get.updateLocale(Locale('en_US'));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Hindi'),
                                    leading: Radio(
                                      value: 'hindi_IND',
                                      groupValue: selectedLanguage.isNotEmpty ? selectedLanguage : 'hindi_IND',
                                      onChanged: (value) async {
                                        setState(()  {
                                          selectedLanguage = value! as String;
                                        });
                                        SharedPreferences sp =await SharedPreferences.getInstance();
                                        sp.setString("Local_value", value! as String);
                                        Get.updateLocale(Locale('hindi_IND'));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("App_language".tr, style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )),
                        Text(selectedLanguage == 'en_US' ? "English".tr : "Hindi".tr, style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Divider( // Add a Divider here
                  color:  Color(0xFFEDF0EE), // Customize the color of the divider
                  thickness: 6.0,   // Adjust the thickness of the divider
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFEDF0EE),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Replace the Text widget with a TextField widget
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextField(
                            controller: userController ,
                            decoration: InputDecoration(
                              hintText:  userName != "" ? userName : "Enter User Name",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFEDF0EE),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: date_of_birth,
                          decoration: InputDecoration(
                            hintText: formattedDOB,
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Gender".tr,style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          // Handle radio button 1 selection
                          setState(() {
                            selectedValue = value! as int;
                          });
                        },
                      ),
                      Text('Male'.tr),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          // Handle radio button 2 selection
                          setState(() {
                            selectedValue = value! as int ;
                          });
                        },
                      ),
                      Text('Female'.tr),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 3,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          // Handle radio button 3 selection
                          setState(() {
                            selectedValue = value! as int;
                          });
                        },
                      ),
                      Text('Others'.tr),
                    ],
                  ),
                ],
              ),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color:  Color(0xFFEDF0EE),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                ),
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 25,bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              _showAlertDialog(context,_token);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.power_settings_new_outlined,color: Colors.grey,weight: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text("LOGOUT".tr,style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  ),
                                ),
                               ],
                              ),
                          ),
                          InkWell(
                            onTap: (){
                              DeleteAccountAlert(context,_token);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.delete,color: Colors.grey,weight: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text("DELETE ACCOUNT".tr,style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  ),
                                ),
                               ],
                              ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if(userName != null && userName.isNotEmpty && dob != null && dob.isNotEmpty && gender.isNotEmpty){
                            Fluttertoast.showToast(msg: "Your Profile is already Updated",textColor: Colors.green,fontSize: 18);
                          }else{
                            if(selectedValue==1){
                              updateUserInfo(userController.text, "M", date_of_birth.text);
                            }else if(selectedValue == 2){
                              updateUserInfo(userController.text, "F", date_of_birth.text);
                            }else if(selectedValue == 3){
                              updateUserInfo(userController.text, "O", date_of_birth.text);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Set the background color to blue
                        ),
                        child: Text(
                          "UPDATE PROFILE".tr,
                          style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dob) {
    // Assuming dob is in the format "YYYY-MM-DD HH:mm:ss"
    List<String> parts = dob.split(" ");
    return parts[0]; // Only taking the date part
  }

  void _showAlertDialog(BuildContext context,String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("LOGOUT".tr),
          content: Text("Are logout".tr),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text("NO".tr),
            ),
            TextButton(
              onPressed: () async {
                var user = await LoginAPi.signOut;
                logout(token);
                final SharedPreferences sp = await SharedPreferences.getInstance();
                sp.remove("email_user");
                sp.remove("user_photo");
                sp.remove("user_name");
                sp.remove("token");
                sp.remove("mobile_number");
                sp.remove("invite_code");
                sp.remove("UserName");
                sp.remove("Local_value");

                sp.clear();

                String userName=sp.getString("user_name").toString();
                String userPhoto=sp.getString("user_photo").toString();
                print("user_name:::::"+userName+"::::::"+userPhoto);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                      (route) => false,
                );
                if (user == null) {
                  print('logout');
                }
              },
              child: Text("YES".tr),
            ),
          ],
        );
      },
    );
  }
  void DeleteAccountAlert(BuildContext context,String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete"),
          content: Text("Are you sure!\nDo you really want to Delete your account"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text("NO".tr),
            ),
            TextButton(
              onPressed: () async {
                Delete_Account(token);
                final SharedPreferences sp = await SharedPreferences.getInstance();
                sp.remove("email_user");
                sp.remove("user_photo");
                sp.remove("user_name");
                sp.remove("token");
                sp.remove("mobile_number");
                sp.remove("invite_code");
                sp.remove("UserName");
                sp.remove("Local_value");

                sp.clear();

                String userName=sp.getString("user_name").toString();
                String userPhoto=sp.getString("user_photo").toString();
                print("user_name:::::"+userName+"::::::"+userPhoto);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                      (route) => false,
                );
              },
              child: Text("YES".tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> Delete_Account(String token) async {
    final String url = 'https://admin.googly11.in/api/delete_account';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        DeleteAccountResponse upiResponse=DeleteAccountResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }
      } else if(response.statusCode == 400){
        DeleteAccountResponse upiResponse=DeleteAccountResponse.fromJson(json.decode(response.body));
        if(upiResponse.status == 1){
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);

        }else{
          Fluttertoast.showToast(msg: upiResponse.message.toString(),textColor: Colors.white,backgroundColor: Colors.black);
        }

        // Handle other status codes
        print('DELETE request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error during DELETE request: $e');
    }
  }

  Future<void> logout(String token) async {
    final String apiUrl = 'https://admin.googly11.in/api/logout';

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );
      print('Logout failed. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        UserInfoUpdate update=UserInfoUpdate.fromJson(jsonDecode(response.body));
        if(update.status==1){
          Fluttertoast.showToast(msg: "Logout successfully",textColor: Colors.white,toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.red);
        }else{
          Fluttertoast.showToast(msg: "Something went wrong",textColor: Colors.white,toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.red);
        }
        print('Logout successful');
      } else if(response.statusCode==401) {
        Fluttertoast.showToast(msg: "Unauthenticated",textColor: Colors.white,toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.red);
        print('Logout failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during logout request: $error');
    }
  }


}
