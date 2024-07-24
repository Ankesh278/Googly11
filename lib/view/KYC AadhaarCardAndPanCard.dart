import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world11/bottom_navigation_bar/bottom_navigation_screen.dart';
import 'dart:io';
import 'package:world11/resourses/Image_Assets/image_assets.dart';
import '../Model/UserAllData/GetUserAllData.dart';
// import 'create_your_team/adharvoteridPickup/adharvoteridPickup.dart';
class KYC_AadhaarCardAndPanCardUpload extends StatefulWidget {
  const KYC_AadhaarCardAndPanCardUpload({super.key});
  @override
  State<KYC_AadhaarCardAndPanCardUpload> createState() =>
      _KYC_AadhaarCardAndPanCardUploadState();
}

class _KYC_AadhaarCardAndPanCardUploadState
    extends State<KYC_AadhaarCardAndPanCardUpload> {
  bool isStep1Completed = false;
  String selectedOption = 'aadhar'; // Default selected option
  String selectedNewOptions='Upload Aadhaar Card ';
  String selectedImage = ImageAssets.aadhar;// Track the selected image
  String selectedImage_back = ImageAssets.aadhar_back;// Track the selected image
  File? _image;
  File? _image2;
  String? _email;
  String? _userName;
  String _token='';
  String? _userPhoto;
  bool _uploadInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    getPrefrenceData();
    super.initState();
  }

  void getPrefrenceData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email_user");
    String? userName = prefs.getString("UserName");
    String? userPhoto=prefs.getString("user_photo");
    String? token=prefs.getString("token");
    setState(() {
      _email=email;
      _userName=userName;
      _userPhoto=userPhoto;
      _token=token!;
      fetchUserAllData(token.toString());
    });
    print("email"+_email.toString());
    print("user_id"+_userName.toString());
  }

  Future<void> fetchUserAllData(String token) async {
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
            _userName=userAllData.user!.userName;
            _userPhoto=userAllData.user!.userKyc!.userImage;
          });
          var responseData = jsonDecode(response.body);
          print('API call successful');
          print('Response  All user : $responseData');
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
          isStep1Completed = true;
        _image = File(pickedFile.path);
      });
    }
  }
  Future<void> _pickImage2() async {
    final pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image2 = File(pickedFile.path);
      });
    }
  }

  void uploadDocuments(String type) async {
    String apiUrl = 'https://admin.googly11.in/api/user_document_upload';
    String token = _token;
    if (_uploadInProgress) {
      return;
    }
    setState(() {
      _uploadInProgress = true;
    });

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    print("headers: $headers");

    // Prepare the request body
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    request.fields['documnet_type'] = type;

    print("request: $request");

    // Add image files
    File frontImageFile = _image!;
    File backImageFile = _image2!;
    print("frontImageFile: ${frontImageFile.path}");
    print("backImageFile: ${backImageFile.path}");
    request.files.add(await http.MultipartFile.fromPath('doc_front_image', frontImageFile.path));
    request.files.add(await http.MultipartFile.fromPath('doc_back_image', backImageFile.path));

    try {
      print("sending request...");
      var response = await request.send();

      // Check the status code
      print("Status Code: ${response.statusCode}");

      // Read and print the response
      var responseBody = await response.stream.bytesToString();
      print("responseBody: $responseBody");

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Document Uploaded Successfully", fontSize: 15, backgroundColor: Colors.green, textColor: Colors.white);
        setState(() {
          _uploadInProgress = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  MyBottomNavigationBar()));
      } else {
        Fluttertoast.showToast(msg: "Error uploading document. Status Code: ${response.statusCode}", fontSize: 15, backgroundColor: Colors.red, textColor: Colors.white);
      }
    } catch (error) {
      print('Error: $error');
      Fluttertoast.showToast(msg: "Error uploading document. Check logs for details.", fontSize: 15, backgroundColor: Colors.red, textColor: Colors.white);
    }finally {
      // Hide the progress dialog when the upload is complete (success or failure)
      setState(() {
        _uploadInProgress = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KYC Verification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff780000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    selectedNewOptions,
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
                padding: const EdgeInsets.only(left: 10, top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 150,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 1.2, color: Colors.grey),
                            ),
                            child: _image != null
                                ? Image.file(_image!, fit: BoxFit.cover) // Display the selected image
                                : Image(
                              image: AssetImage(selectedImage), // Dynamically select the image
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18, left: 10),
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(); // Trigger image picking
                            },
                            child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Color(0xFF1115f2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1.2, color: Colors.grey),
                              ),
                              child: Center(
                                child: _image == null
                                    ? Text(
                                  'Upload Front',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  'Change Image', // Display this text when an image is selected
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Step 2',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: isStep1Completed
                              ? Container(
                            height: 150,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1.2, color: Colors.grey),
                            ),
                            child:_image2 != null
                                ? Image.file(_image2!, fit: BoxFit.cover) // Display the selected image
                                : Image(
                              image: AssetImage(selectedImage_back), // Dynamically select the image
                            ),
                          )
                              : Container(
                            height: 150,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1.2, color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                'Step 1 Incomplete',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18, left: 10),
                          child: isStep1Completed
                              ? GestureDetector(
                            onTap: (){
                              if (_image2 != null && _image != null) {
                                print("image saved "+_image.toString());
                                print("image 2 "+_image2.toString());
                               uploadDocuments(selectedOption);
                              } else {
                                _pickImage2();
                              }
                            },
                                child: Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Color(0xFF1115f2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1.2, color: Colors.grey),
                            ),
                           child: Center(
                             child: _uploadInProgress
                                 ?   SpinKitFadingCircle(
                               color: Colors.redAccent,
                               size: 50.0,
                             )
                                 : (_image2 == null
                                 ? Text(
                               'Upload Back',
                               style: TextStyle(
                                 fontWeight: FontWeight.w500,
                                 color: Colors.white,
                               ),
                             )
                                 : Text(
                               'Send To Server', // Display this text when an image is selected
                               style: TextStyle(
                                 fontWeight: FontWeight.w500,
                                 color: Colors.white,
                               ),
                             )),
                           ),
                              ),
                             )
                              : Container(
                            height: 40,
                            width: 250,
                            color: Colors.grey.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                'Step 1 Incomplete',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.05,
                width: size.width * 0.05,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'or'.toUpperCase(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose other ID Proof ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Show the bottom sheet when the text is clicked
                        showMyBottomSheet(context);
                      },
                      child: Text(
                        "  Click here",
                        style: TextStyle(
                          color: Color(0xFF1115f2),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showMyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            height: 270,
            child: Column(
              children: [
                ListTile(
                  title: Text('Aadhaar Card'),
                  leading: Radio(
                    value: 'aadhar',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _image=null;
                        _image2=null;
                        isStep1Completed=false;
                        selectedOption = value! as String ;
                        selectedImage = ImageAssets.aadhar; // Set the selected image
                        selectedNewOptions="Upload Aadhaar Card";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: Text('Pan'),
                  leading: Radio(
                    value: 'pan',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _image=null;
                        _image2=null;
                        isStep1Completed=false;
                        selectedOption = value! as String;
                        selectedImage = ImageAssets.ba2;
                        selectedNewOptions="Upload Pan Card";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Add this function in your State class
  // Future<void> _uploadToServer() async {
  //   // Implement your logic to send data to the server, e.g., use Dio, http package, etc.
  //   // Example using http package:
  //   Fluttertoast.showToast(
  //       msg: "Data will send to server",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  //   // if (_image2 != null) {
  //   //   var request = http.MultipartRequest('POST', Uri.parse('your_server_endpoint'));
  //   //   request.files.add(await http.MultipartFile.fromPath('file', _image2!.path));
  //   //
  //   //   try {
  //   //     var response = await request.send();
  //   //     if (response.statusCode == 200) {
  //   //       // Handle a successful upload
  //   //       print('Image uploaded successfully');
  //   //     } else {
  //   //       // Handle upload failure
  //   //       print('Image upload failed');
  //   //     }
  //   //   } catch (error) {
  //   //     print('Error uploading image: $error');
  //   //   }
  //   // }
  // }

}
