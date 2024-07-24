import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/Model/SendFeedback_Data_Response/SendFeedbackResponse.dart';

class FeedBackDesign extends StatefulWidget {
  const FeedBackDesign({super.key});

  @override
  State<FeedBackDesign> createState() => _FeedBackDesignState();
}

class _FeedBackDesignState extends State<FeedBackDesign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textController2 = TextEditingController();
  bool _isFocused = true;
  bool isButtonEnabled = false;
  String? _email;
  String? _userName;
  String _token='';
  int _rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefrenceData();
  }

  Future<void> getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _token=token!;
    });
    print("email:::::::::"+_email.toString());
    print("user_id"+_userName.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'.tr,style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false, // Set this to false to hide the default back button
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color:Colors.white),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop(); // This example assumes you want to navigate back
          },
        ),
      ),
      body:  Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Feedback for Googly11",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      TextFormField(
                        controller: textController2,
                        decoration: InputDecoration(
                          hintText: 'Enter some Feedback',
                          labelText: _isFocused ? 'Enter Feedback' : '',
                          labelStyle: TextStyle(
                            color: _isFocused ? Colors.blue : Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          setState(() {
                            _isFocused = true;
                          });
                        },
                        validator: (value) {
                          // Validate the input and return an error message if invalid
                          if (value == null || value.isEmpty ) {
                            return 'Please enter some feedback';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      SizedBox(height: 20),
                      RatingBar.builder(
                        initialRating: _rating.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: _onButtonPressed,
                  child: Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void _onButtonPressed() {
    if (_formKey.currentState!.validate() && _rating != 0) {
      submitFeedback(textController2.text, _rating, _token);
    }else{
      Fluttertoast.showToast(msg: "Rate the app",backgroundColor: Colors.black,textColor: Colors.white);
    }
  }
  void submitFeedback(String feedback,int rating,String token_) async {
    String url = 'https://admin.googly11.in/api/submit-feedback';
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token_',
    };

    Map<String, dynamic> body = {
      'content': feedback.toString(),
      'rating': rating.toString(),
    };

    try {
      var response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        SendFeedbackResponse sendFeedbackResponse=SendFeedbackResponse.fromJson(json.decode(response.body));
        if(sendFeedbackResponse.status == 1){
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }else{
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }
        print('Feedback submitted successfully!');
        print('Response: ${response.body}');
      } else if(response.statusCode == 400) {
        SendFeedbackResponse sendFeedbackResponse=SendFeedbackResponse.fromJson(json.decode(response.body));
        if(sendFeedbackResponse.status == 1){
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }else{
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }
        print('Failed to submit feedback. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }else{
        SendFeedbackResponse sendFeedbackResponse=SendFeedbackResponse.fromJson(json.decode(response.body));
        if(sendFeedbackResponse.status == 1){
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }else{
          Fluttertoast.showToast(msg: "${sendFeedbackResponse.message.toString()}",backgroundColor: Colors.black,textColor: Colors.white);
        }
        print('Failed to submit feedback. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error submitting feedback: $error');
    }
  }
}
